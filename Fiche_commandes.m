%%% Utilisation matlab

%% cours



%% commande

%matrice 
% le premier indice d'une matrice est 1 et non 0
A = [0,1 ; 2,1]                             % creation matrice explicite 
%la virgule sépare colonnes et le point viregule sépare les lignes
m = [1 : -0.25 : -1]                        % Création matricite implicite
Vx = zeros(3,4)                             % créer matrice nulle (ligne, colonne)
Vy = ones (3,4)                             % créer une matrice de coeffs 1 (ligne, colonne)
B = eye(4)                                  % donne la matrice identité en 4x4
A(1,2)                                      % donne coeff 1ère ligne / 2ème colonne)
A(:,2)                                      % donne la 2è colonne de la matrice
A(2)                                        % donne la 2è ligne si matrice colonne et la 2è colonne si matrice ligne
A'                                          % transposée de A
tril(A)                                     % partie triangulaire inférieure + diag
triu(A)                                     % partie triangulaire supérieure + diag
diag(rand(4,1))                             % matrice diagonale

%boucles
for i=debut:incrément:fin
end

%calcul
t=1:2:8                                     % pour t partant de 1, allant de 2en 2 et allant jusqu'à 8
Vx(1,:)                                     % prend toutes les valeurs de la 1ère ligne
Vxm=mean(3,2)                               % mean pour faire la moyenne
ceil(3,14)                                  % arrondi supérieur
floor(4,24)                                 % arrondi inférieur
rand(M)                                     % nombre random entre 0 et 1 multiplié par M soit entre 0 et M
sum (Xm)                                    % somme cumulative
sort(A)                                     % classe croissant par colonne
sort(A,'descend')                           % pour classer de façon décroissante par colonne
C(:,2:3)=[]                                 % Enlever toutes les lignes ainsi que la colonne 2 à 3 
reshape                                     % Change le nb de lignes & colonnes ixj=c en i'x j'=c
tic [code...] toc                           % Donne la durée de l'opération entre le tic et le toc
    
%calcul matriciel
der / inv / norm / size / eip (valeurs et vecteurs propres)
m\b                                         % m^-1 * b

%affichage
%par défaut lorsque l'on écrit
plot(t,Y);                                  % ouvre une fenêtre et affiche le graphique dans fenêtre
plot(t,E);                                  % la même fenetre reste là, le graphique d'avant est effacé et le nouveau est tracé
figure;                                     % force l'ouverture d'une nouvelle fenêtre, le prochain plot sera tracé dans cette fenêtre
%commandes à mettre après figure, donne des caractéristiques à figure
xlabel('\psi (rd)')                                     
ylabel('dx/dt (m/s)')                       
title('vitesse de la lame')
legend('théorique','numérique','Location','East');
%
hold on;                                    % si l'on utilise 2 fois plot après cette commande les 2 graphiques s'affichent dans la même fenêtre
subplot(1,2,1)                              % pour faire 2 graphiques ds une même fenêtre(nombre de ligne, nombre de colonnes, indice du graphique) cc'est pour mettre différents graphique en même temps, mettre figure ('name','le titre du coup')
plot(t,Vxm,'LineWidth',2)                   % affichage (abscissee, ordonnée, choisir épaisseur, 2 d'épaisseur)
plot(x,y,'k-')                              % affichage (abscisse, ordonnée, couleur noir et ligne)
U = 4*kappa.*((d./r).^12.-(d./r).^6);       % . pour opération avec un vecteur
grid on                                     % pour modifier le grille ( quand oj modifie l'abscisse par exemple
axis([0 4 -2 5])                            % modifier taille de la fenêtre ( abscisses de 0à 4 et ordonnée de -2 à 5)

%fichier fonction
function dxdt=Pendule_elastique(t,x)        % la trame d'un fichier function, sachant que Pendule_elastique est la fonction, x et t sont les paramètres de la fonction et dxdt est ce qui est renvoyé par la fonction
end
(@Pendule_elastique,t_balayage,x0)             % appel de la fonction dans un fichier script

%utilisation de fonctions mathématiques
phi = @(x) (x.^3+1)./3                      %Déclaration de la fonction phi
phi(beta)                                   %calcul de l'image de beta par phi

% fichiers scripts: renvoient une valeur
Enregistrer le fichier "nom.m"  que l'on peut appeller n'importe où
% fichiers functions: action
Enregistrer le fichier "fonction.m", que l'on appelle n'importe où
M = function(7)
% mat-fichiers
"save fichier A M" permet de sauvegarder dans matlab un fichier, nommé fichier, 
contenant les variables A et M qui seront utilisables dans n'importe quel code créé ensuite