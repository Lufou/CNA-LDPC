function result = SOFT_DECODER_GROUPE5(c, H, p, MAX_ITER)
    [nb_lines_c, nb_col_c] = size(c);
    [nb_lines_p, nb_col_p] = size(p);
    [nb_lines_H, nb_col_H] = size(H);
    
    % Vérifier les paramètres c, p et H
    if nb_lines_c ~= nb_col_H || nb_col_c > 1 || ~isBinaryVector(c)
        disp("c doit être un vecteur colonne binaire de dimension [N, 1] avec N égal au nombre de colonnes de H.");
        return
    elseif nb_lines_p ~= nb_lines_c || nb_col_p > 1 || ~isProbabilityVector(p)
        disp("p doit être un vecteur colonne de probabilités entre 0 et 1 de dimension [N, 1] comme le vecteur c");
        return
    elseif ~isBinaryMatrix(H)
        disp("H doit être une matrice de parité binaire de dimension [M, N].");
        return
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   q = initq(H, p, nb_lines_H, nb_col_H);  
   r_1 = zeros(nb_lines_H, nb_col_H);
   for iter = 1:MAX_ITER
        r_1 = calculate_r_1(r_1, q);
        
        q = calculate_q(q, r_1, p);
        
        Q = calculate_Q(p, r_1);
        
        for i = 1:nb_col_H
            if (Q(2, i) > Q(1,i))
                c(i) = 1; 
            else
                c(i) = 0;
            end
        end
        
        is_even = check_parity(nb_col_H, c);
        
        if (is_even)
           break; 
        end
   end
   result = c;
end

function is_even = check_parity(H, c)
    [c_nodes, v_nodes] = size(H);
    check = zeros(c_nodes, 1);
    for i = 1:c_nodes
        parity = 0;
        for j = 1:v_nodes
            if H(i, j) ~= 0
                parity = parity + c(j);
            end
        end
        check(i) = mod(parity, 2);
    end
    is_even = sum(check) == 0;
end
   
function isBinaryVector = isBinaryVector(vector)
     % Vérifie si le vecteur ne contient que des 0 et des 1
     uniqueValues = unique(vector);
     isBinaryVector = true;
     for i=uniqueValues
         if i~=0 & i~=1
             isBinaryVector = false;
         end
     end
end
   
function isProbabilityVector = isProbabilityVector(vector)
     % Vérifie si le vecteur contient des probabilités entre 0 et 1
     isProbabilityVector = all(vector >= 0 & vector <= 1);
end
   
function isBinaryMatrix = isBinaryMatrix(matrix)
     % Vérifie si la matrice ne contient que des valeurs binaires (0 et 1)
     uniqueValues = unique(matrix);
     isBinaryMatrix = isequal(uniqueValues, [0; 1]);
end

function q = initq(H, p, nb_lines_H, nb_col_H)
    q = zeros(2, nb_lines_H, nb_col_H);
    for i = 1:nb_lines_H
        for j = 1:nb_col_H
            if H(i, j)
                q(1, i, j) = 1 - p(j);
                q(2, i, j) = p(j);
            end
        end
    end
end

function r_1 = calculate_r_1(r_1, q)
    [nb_lines_r_1, nb_col_r_1] = size(r_1);
    q_1 = squeeze(q(2,:,:));
    for i = 1:nb_lines_r_1
        for j = 1:nb_col_r_1
            sum_prod = 1;
            for k = 1:nb_col_r_1
                if (k == j)
                    continue;
                end
                sum_prod = sum_prod * (1-2*q_1(i,k));
            end
            r_1(i,j) = 1 - (0.5 + 0.5*sum_prod);
        end
    end
end

function q = calculate_q(q, r_1, p)
    [nb_lines_r, nb_col_r] = size(r_1);
    K = zeros(nb_lines_r, nb_col_r);
    for i = 1:nb_lines_r
        for j = 1:nb_col_r
            sum_prod_1 = 1;
            sum_prod_0 = 1;
            for k = 1:nb_lines_r
                if (k == i)
                    continue;
                end
                sum_prod_1 = sum_prod_1 * r_1(k,j);
                sum_prod_0 = sum_prod_0 * (1-r_1(k,j));
                %disp("prod_1="+sum_prod_1);
            end
            q(1,i,j) = (1-p(j)) * sum_prod_0;
            q(2,i,j) = p(j) * sum_prod_1;
            K(i,j) = 1/(q(1,i,j) + q(2,i,j));
            %disp("q(1,"+i+","+j+") = "+q(1,i,j));
            %disp("q(2,"+i+","+j+") = "+q(2,i,j));
            %disp("K("+i+","+j+"= "+K(i,j));
            q(1,i,j) = K(i,j) * q(1,i,j);
            q(2,i,j) = K(i,j) * q(2,i,j);
        end
    end
    %disp(q(1,1,1));
    %disp(q(2,1,1));
end

function Q = calculate_Q(p, r_1)
    [nb_lines_r, nb_col_r] = size(r_1);
    Q = zeros(2, nb_col_r);
    K = zeros(1,nb_col_r);
    for i = 1:nb_col_r
        sum_prod_0 = 1;
        sum_prod_1 = 1;
        for j=1:nb_lines_r     
             sum_prod_1 = sum_prod_1 * r_1(j,i);
             sum_prod_0 = sum_prod_0 * (1 - r_1(j,i));
        end
        Q(1,i) = (1-p(i))*sum_prod_0;
        Q(2,i) = p(i)*sum_prod_1;
        K(i) = 1/(Q(1,i) + Q(2,i));
        Q(1,i) = K(i) * Q(1,i);
        Q(2,i) = K(i) * Q(2,i);
    end
end
