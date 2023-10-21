M = 5;
N = 7; 
% c, un vecteur colonne binaire de dimension [N, 1];
c = zeros(N,1);
% H, une matrice de parité de dimension [M, N] constituée de true et false;
matrice_de_parite = randi([0, 1], M, N);

% p, un vecteur colonne de dimension [N, 1] tel que p(i) est la probabilité que c(i) == 1 sachant qu on a reçu un certain signal ;
p = rand(N, 1);
% MAX_ITER, un entier strictement positif spécifiant le nombre maximal d%itérations que peut effectuer le décodeur et retournant
MAX_ITER=10;
% c_cor le vecteur colonne binaire de dimension [N, 1] issu du décodage.
c_cor=zeros(N,1);
