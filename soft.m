function result = SOFT_DECODER_GROUPE1(c_vec, H, p1_vec, MAX_ITER)
    %disp("Soft Decorder: ")
    % Partie A : Intialisation
    %*********************************************************************
    
    % !!!!! p1 va prendre la probabilité qu'on a un bit c[i] = 1 !!!!

    % on considère nos c comme un tableau non pas comme un vecteur pareil
    % pour p1 ( probabilité d'avoir un c(i) = 1
    % étape -1 : convertir c_vecteur en c_tableau et p1_vecteur en p1_tableau
    [c_vec_ligne, c_vec_colone] = size(c_vec);

    c = zeros(1,c_vec_colone);
    for i= 1:c_vec_colone
        for j = 1:c_vec_ligne
            c(i,j) = c_vec(j,i);
        end
    end

    [p1_vec_ligne, p1_vec_colone] = size(p1_vec);
    p1 = zeros(1,p1_vec_colone);
    for i= 1:p1_vec_colone
        for j = 1:p1_vec_ligne
            p1(i,j) = p1_vec(j,i);
        end
    end

    % désormais on a c = [ c1 c2 c3 c4 c5 c6 c7 c8 ]
    % désormais on a p = [ p1 p2 p3 p4 p5 p6 p7 p8 ]
    
    %disp("c_initial")
    %disp(c)
    %disp("p_initial")
    %disp(p)
    
    
    [c_ligne, c_colone] = size(c);
    [~, p1_colone] = size(p1);
    [~, H_colone] = size(H);
    
    %verifier si les variable d'entré sont correct
    if c_colone == 1 && c_ligne == 1
        disp("c doit être de la forme a [N, 1]")
        return
    elseif c_ligne > 1
        disp("c doit être de la forme b [N, 1]")
        return
    elseif c_colone ~= H_colone
        disp("c doit contenir même nombre de colone que H")
        return
    elseif p1_colone ~= c_colone
        disp("c doit contenir même nombre de colone que p")
        return
    end
    

    % je créer un p1_intermediare qui est une copie de p1 classique ce 
    % ce p1_inter une une matrice fantome qui me permettra de modif les
    % valeur p

    
    p1_inter = zeros(1,p1_colone);
    for i= 1:p1_colone
            p1_inter(i) = p1(i);
    end
    
    
    
    % je créer un c_intermediare qui est une copie de c classique ce 
    % ce c_inter une une matrice fantome qui me permettra de modif les
    % valeur c

    c_inter = zeros(1,c_colone);
    for i= 1:c_colone
        c_inter(i) = c(i);
    end
    %*********************************************************************

    % Partie B : Algo
    %*********************************************************************
    check = 0;
    k=0;
    while ((check == 0)&&(k<MAX_ITER))

        % Etape 1 : 
        % Crée un tableau F de f[i] et chaque f[i] est un dictionnaire :
            % key = lien avec les c[i] 
            % element =  p_inter associé (proba que ce soit c[i] = 1)
        F=creation_tab_de_dico_F_p(p1_inter,H);

        
        
        % Etape 2 : 
        % remplir mon tableau des V avec les nouvelles valeurs obtenue
        % après le parity change
        %mon tableau V est tableau de v[i] où chaque v[i] est un dictionnaire 
        %key = mes fi 
        %element = valeur de la fonction intermediaire associé au fi
        V=creation_tab_de_dico_V(F,H,p1_inter);


        %Etape 3 :
        % mettre à jour notre c_inter avec le resultat de la fonction decision des
        % valeurs obtenu par les différent fi après la fonction
        % intermediare
        % puis réaliser le parity_check pour vérifier si les nouvelles
        % valeur de c_inter sont correct

        for i= 1:c_colone
            c_inter(i) = decision(V{i},p1_inter(i));
        end
        
        %refaire un tab de dico
        newF=creation_tab_de_dico_F_c(c_inter,H);
        %puis faire le parity_check
        check = parity_check(newF,H);

    k= k +1;
    
    end
    %*********************************************************************
    c_final = c_inter;
    %fprintf("résultat final après k = %d nombre d'itération : \n",k)
    %disp(c_final)

    % étape final : convertir c_final_tableau en c_final_vecteur
    [c_final_ligne, c_final_colone] = size(c_final);
    c_final_vec = zeros(c_vec_ligne,1);
    for i= 1:c_final_colone
        for j = 1:c_final_ligne
            c_final_vec(i,j) = c_final(j,i);
        end
    end
    result = c_final_vec;
    
end   
%%




%% SECTION 2 : Fonction tier

% 1) fonction creation_tab_de_dico_F_p:
%**************************************************************************************************
% fonction qui permet de créer un tableau de dictionnaire, F où chaque f[i]
% correspond un dictionnaire liens avec les c[i] et leur probabilité p 
function F = creation_tab_de_dico_F_p(p_inter,H)

    [H_ligne, H_colone] = size(H);
    F=cell(1:H_ligne);
    for i = 1:H_ligne
        % le calcule le nombre liens total il y a pour chaque F
        % la valeur qui me servira pour faire les tableau link et value
        nbr_de_lien = 0;
        for l= 1 : H_colone
            if H(i,l)== 1
                nbr_de_lien = nbr_de_lien + 1;
            end
        end

        %je crée un tableau lien qui prendra chaque lien C que possede mes f[i] et qui sera rénitialiser à chaque fois que je change de ligne
        % même chose pour les valeur
        k = 1;
        link1 = zeros(1,nbr_de_lien);    
        value1 = zeros(1,nbr_de_lien);    
        for j = 1:H_colone
            if H(i,j) == 1
                link1(k)= j;
                value1(k)= p_inter(j);
                k = k + 1;
            end
        end

        % Je remplie mon tableau des F
        for j = 1:H_colone
            if H(i,j) == 1
                F{i}=dictionary(link1,value1);
            end
        end
    end
end
%**************************************************************************************************

% 2) fonction creation_tab_de_dico_F_c:
%**************************************************************************************************
% fonction qui permet de créer un tableau de dictionnaire, F où chaque f[i]
% correspond un dictionnaire liens avec les c[i] et leur valeur 
function F = creation_tab_de_dico_F_c(c_inter,H)

    [H_ligne, H_colone] = size(H);
    F=cell(1:H_ligne);
    for i = 1:H_ligne
        % le calcule le nombre liens total il y a pour chaque F
        % la valeur qui me servira pour faire les tableau link et value
        nbr_de_lien = 0;
        for l= 1 : H_colone
            if H(i,l)== 1
                nbr_de_lien = nbr_de_lien + 1;
            end
        end

        %je crée un tableau lien qui prendra chaque lien C que possede mes f[i] et qui sera rénitialiser à chaque fois que je change de ligne
        % même chose pour les valeur
        k = 1;
        link1 = zeros(1,nbr_de_lien);    
        value1 = zeros(1,nbr_de_lien);    
        for j = 1:H_colone
            if H(i,j) == 1
                link1(k)= j;
                value1(k)= c_inter(j);
                k = k + 1;
            end
        end

        % Je remplie mon tableau des F
        for j = 1:H_colone
            if H(i,j) == 1
                F{i}=dictionary(link1,value1);
            end
        end
    end
end
%**************************************************************************************************


%3) fonction creation_tab_de_dico_V:
%**************************************************************************************************
%même idée que pour F sauf que pour chaque colone on regarde toutes les
%lignes pour avoir les liens. On cherche pour chaque c[i] ces liens
function V = creation_tab_de_dico_V(F,H,p)
    [~, p_colone] = size(p);
    [H_ligne, H_colone] = size(H);
    V=cell(1:p_colone);
    for i = 1:H_colone
        
        % je cherche le nbr de liens pour chaque c[i]
        % pour creer link2 et value2
        nbr_de_lien_p = 0;
        for l= 1:H_ligne
            if H(l,i)== 1
                nbr_de_lien_p = nbr_de_lien_p + 1;
            end
        end
        
        %chaque link2(i)=f(i)
        %chaque value(i)= résultat de fonction intermediaire
        k=1;
        link2 = zeros(1,nbr_de_lien_p);    
        value2 = zeros(1,nbr_de_lien_p);
        for j = 1:H_ligne
            if H(j,i) == 1
                link2(k)= j;
                %les valeurs de chaque v[i] est le resultat de
                %intermediaire
                value2(k)= intermediaire(F{j},i);
                k = k + 1;
            end
        end
    
        %je remplie mon tableau V avec tout ces dictionnaires
        for j = 1:H_ligne
            if H(j,i) == 1
                V{i}=dictionary(link2,value2);
            end
        end   
    end
end
%**************************************************************************************************

%4) fonction intermediaire:
%**************************************************************************************************
%faire description
% j'applique la fonction (3) du document ldpc.pdf page 7
% et je met le résultat dans mon p_i que j'ai mis en entré
function p_i = intermediaire(f,i) 
    x=0;
    %f.entries nous donne un tableau de key et de value du dictionnaire
    % size(x,1) prend uniquement la taille de mes key
    nbr_key = size(f.entries,1);
    % le doit mettre entries de f pour manipuler les valeur
    temp = entries(f);
    s= 1;
    for k=1:nbr_key
        if not(temp(k,1).Key == i)
            
            x = 1-2*temp(k,2).Variables;
            s = s*x;
            
        end
    end

    s = 0.5*s + 0.5;
    r = 1 - s ;
    p_i = r;    
end
%**************************************************************************************************

%5) fonction parity_check:
%**************************************************************************************************
% j'additionne tout les c[i] puis je fais le modulo 2 pour chaque f[i] si
% ça donne 0 = true si ça donne 1 = false , je met chaque résultat des f[i]
% dans un tableau puis s'il y a un seul false dans mon tableau je retourne
% false
function check = parity_check(F,H)
    [H_ligne, ~] = size(H);
    check_inter = true;
    tab_check=true(1,H_ligne);
    for k = 1 : H_ligne
        s=0;
        nbr_key = size(F{k}.entries,1);
        temp = entries(F{k});
        for l=1:nbr_key
            %temp(k,1).Variables permet de prendre les key 
            %temp(k,2).Variables permet de prendre les valeur
            s = s + temp(l,2).Variables; 
        end
        if mod(s,2)==0
            tab_check(k)=true;
        else
            tab_check(k)=false;
        end
    end

    for k=1:H_ligne
        check_inter = check_inter * tab_check(k);
    end

    check= check_inter;
end
%**************************************************************************************************

%6) fonction decision
%**************************************************************************************************
%cette fonction permet de prendre une decision quel bit pour c_inter(i) prendre
%en fonction des probabilité donné par les f(i)
% on doit prendre des Q_intermédiare afin de pouvoir trouver le bon Ki
% et ainsi trouver les bon Qi(0) et Qi(1) -> voir la formule du  pdf 
function c_inter=decision(v,p_i)
    Ki=1;
    temp=entries(v);
    Q1_inter=1;
    Q0_inter=1;
    nbr_key= size(v.entries,1);
    for j=1:nbr_key
        %ici j'ai les proba d'avoir 1 pas 0 du coup il me faut p0(i)=1-p1(i)
        Q0_inter=(1-(temp(j,2).Variables))*Q0_inter;
        Q1_inter=temp(j,2).Variables*Q1_inter;

    end 
    %fprintf("Q0_inter = %f \n",Q0_inter);
    %fprintf("Q1_inter = %f \n",Q1_inter);

    Q0_inter2=Ki*(1-p_i)*Q0_inter;
    Q1_inter2=Ki*p_i*Q1_inter;

    %fprintf("Q0 = %f \n",Q0_inter2);
    %fprintf("Q1 = %f \n",Q1_inter2);

    if (Q0_inter2 + Q1_inter2 ~=1)
        Ki = 1 /((p_i*Q1_inter)+((1-p_i)*Q0_inter));
        Q0=Ki*(1-p_i)*Q0_inter;
        Q1=Ki*p_i*Q1_inter;
        %s=Q0+Q1;
        %fprintf("Ki = %f , Q0 + Q1 = %f \n",Ki,s);
        %fprintf("new Q0 = %f , new Q1 = %f",Q0,Q1);
    else
        Q0 = Q0_inter2;
        Q1 = Q1_inter2;
    end
    
    if(Q1>Q0)
        c_inter=1;
    else
        c_inter=0;
    end 
end 
