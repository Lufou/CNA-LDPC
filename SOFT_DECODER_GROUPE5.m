function result = SOFT_DECODER_GROUPE5(c, H, p, MAX_ITER)
  
   function isBinaryVector = isBinaryVector(vector)
        % Vérifie si le vecteur ne contient que des 0 et des 1
        uniqueValues = unique(vector);
        isBinaryVector = isequal(uniqueValues, [0; 1]);
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

    [nb_lines_c, nb_col_c] = size(c);
    [nb_lines_p, nb_col_p] = size(p);
    [nb_lines_H, nb_col_H] = size(H);
    
    % Vérifier les paramètres c, p et H
    if nb_lines_c ~= nb_lines_H || nb_col_c > 1 || ~isBinaryVector(c)
        disp("c doit être un vecteur colonne binaire de dimension [N, 1] avec N égal au nombre de colonnes de H.");
        return
    elseif nb_lines_p ~= nb_lines_c || nb_col_p > 1 || ~isProbabilityVector(p)
        disp("p doit être un vecteur colonne de probabilités entre 0 et 1 de dimension [N, 1] comme le vecteur c");
        return
    elseif ~isBinaryMatrix(H)
        disp("H doit être une matrice de parité binaire de dimension [M, N].");
        return
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   parity = 0;
   iter = 0;
   [nb_lines_H, nb_col_H] = size(H);
   q_1 = initq(H, p, nb_lines_H, nb_col_H);
   r_1 = zeros(nb_lines_H, nb_col_H);
   while ((parity == 0)&&(iter<MAX_ITER))
        r_1 = calculate_r_1(q_1);
   end
   result = c;
end

function q = initq(H, p, nb_lines_H, nb_col_H)
    q = zeros(nb_lines_H, nb_col_H);
    for i = 1:nb_lines_H
        for j = 1:nb_col_H
            if H(i, j)
                q(i, j) = p(j);
            end
        end
    end
end

function r_1 = calculate_r_1(q_1)
    [nb_lines_q, nb_col_q] = size(q_1);
    for i = 1:nb_lines_q
        for j = 1:nb_col_q
            sum_prod = 1;
            for k = 1:nb_lines_q
                if (k == i)
                    continue;
                end
                sum_prod = sum_prod * (1-2*q_1(k,j));
            end
            r_1(i,j) = 1 - (0.5 + 0.5*sum_prod);
        end
    end
end
