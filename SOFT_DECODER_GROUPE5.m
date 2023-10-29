function result = SOFT_DECODER_GROUPE5(c, H, p, MAX_ITER)
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