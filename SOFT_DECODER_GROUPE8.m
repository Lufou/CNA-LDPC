function c_cor = SOFT_DECODER_GROUPE8(c,H,p,MAX_ITER)

    %Initialisation des variables de calcul : on récupère le nombre de lignes
    %et de colonnes de H et c. On crée un vecteur temporaire d'estimation du
    %mot code temp_c_cor

    [c_rows, c_cols] = size(c);
    [H_rows, H_cols] = size(H);
    temp_c_cor = c;

    %Verification des conditions d'utilisation du Soft Decoder


    %On vérifie que c est un vecteur de dimension [N,1]

    if (c_cols == 1 && c_rows == 1)
        disp("ERREUR : c doit être un vecteur ayant pour forme [N,1]");
    end

    %On vérifie que c est bien un vecteur binaire

    for i=1: c_rows
        for j=1 : c_cols
            if c(i,j) <  0 || c(i,j) > 1
                disp("ERREUR : c n'est pas un vecteur binaire");
            end
        end
    end

    %On vérifie que H est bien une matrice binaire 

    for row = 1:H_rows
       for col = 1:H_cols
            if H(row,col) < 0 || H(row,col) > 1
                disp("ERREUR : la matrice H n'est pas une matrice binaire");
                return
            end
       end
    end

    %On transpose c en vecteur colonne si besoin pour la suite des vérification et de l'algo

    if isvector(c) && (c_cols > 1)
        dimension = c_cols;
    else
        dimension = c_rows;
    end

    %On vérifie que les dimensions de H sont compatible avec le vecteur c

    if dimension ~= H_cols
        disp("ERREUR : les dimensions de c et H ne sont pas compatibles");
        return
    end

    %Initialisation

    %On crée 2 matrices : une qui contiendra les messages allant des v-nodes
    %vers les c-nodes, et l'autre qui contiendra les réponses des c-nodes vers
    %les v-nodes

    mess =  -1 * ones(H_rows, dimension);
    resp = -1 * ones(H_rows, dimension);

    %A ce stade les matrices sont remplies de -1, afin de distinguer par la
    %suite les ocnnexions entre les v-nodes et les c-nodes

    %On initialise la matrice de messages. 
    %Pour les cases correspondant à un lien entre un v-node (en colonne) et un
    %c-node (en ligne), on remplace la valeur -1 par la probabilité p(i)
    %correspondante

    for row = 1:H_rows
        for col = 1:H_cols
            if H(row, col) == 1
                mess(row, col) = p(col);
            end
        end
    end

    %Début des itérations

    for a = 1:MAX_ITER

        %Les c-nodes calculent leur réponse en fonction du message des v-nodes

        for row = 1:H_rows
            for col = 1:dimension
                result = ones(1,2);
                num = abs(prod(1-2*mess,2));
                result(1) = 0.5 + (0.5*(num(row)/(1-2*mess(row,col))));
                result(2) = 1- result(1);
                resp(row, col) = result(1);
            end
        end

         %Les v-nodes mettent à jour leur message en fonction de la réponse des
         %c-nodes

        for col = 1:dimension

            message=resp(:,col);
            message_temp=prod(abs(resp),1);
            message_temp_op=prod(nonzeros(1-abs(message)),1);
            product(1) = message_temp(col);
            product(2) = message_temp_op;
            q_temp = zeros(1,2);
            q_temp(1) = (1-p(col))*product(1);
            q_temp(2) = p(col)*product(2);

            %On calcule la valeur de Ki, avant de mettre à jour la valeur de q

            Ki = 1/(q_temp(1)+ q_temp(2));

            qi = ones(1,2);
            qi(1) = Ki*q_temp(1);
            qi(2) = Ki*q_temp(2);

            %On compare Q(0) et Q(1) afin de déterminer la valeur finale de
            %l'estimation de la valeur du bit
            
            if qi(2) > qi(1)
                temp_c_cor(col)= 1;
            else
                temp_c_cor(col)= 0;
            end

            %Mise à jour des valeurs des messages des v-codes

            for row = 1 : H_rows
              q_prime = zeros(1,2);
              reponse = zeros(1,2);

              %recalcul du K pour chaque element avant la mise à jour
              q_prime(1)= q_temp(1)/resp(row, col);
              q_prime(2)= q_temp(2)/ (1 - resp(row, col));
              ki_t = 1 / (q_prime(1) + q_prime(2));

              %Mise à jour des valeurs des messages
              reponse(1) = ki_t * q_prime(1);
              reponse(2) = ki_t * q_prime(2);
              mess(row,col) = reponse(1);
            end


        end
        
        %On effectue le test de parité pour voir si le mot code estimé est
        %le bon. Si le test est correcte, on arrête les itérations et on
        %renvoie le mot code. Sinon on continue jusqu'au nombre max
        %d'itérations

        parity = test_parite(temp_c_cor, H ,H_rows, dimension);
        if sum(parity) == 0
            c_cor = temp_c_cor;
            return
        end
        
    %Dans le cas où le nombre max d'itérations a été atteint, on renvoie la
    %valeur finale calculée même si celle ci n'est pas correcte
    
    end
    c_cor = temp_c_cor;
end

%On defini une deuxième fonction afin d'effectuer le test de parité, et
%éviter les itérations superficielles

function vector = test_parite(c, H, rows, cols)
    vector = zeros(rows, 1);
    for row = 1:rows
        test = 0;
        for col = 1:cols
            if H(row, col) ~= 0
                test = c(col) + test;
            end
        end
        vector(row) = mod(test, 2);
    end
end


