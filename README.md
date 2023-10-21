# CNA-LDPC

Ce projet contiendra du Matlab, j'adore le Matlab (c'est faux)

Soft decoder :
Etape 1 : Chaque 𝑐i envoie ses probas qij(0) et qij(1) et à ses fj correspondants.
𝑞ij(0): probabilité que yi corresponde à un 0
𝑞𝑖𝑗(1) : probabilité que yi corresponde à un 1

Etape 2 : Chaque fj va retourner à chaque ci les probabilités de 0 et de 1 qu’il pense correct (on exclut bien le noeud i dans le calcul des probas à lui renvoyer)

Etape 3 : Chaque 𝑐i re-calcule ses probabilités de 0 et de 1 en fonction de toutes les données reçues par les fj
Ainsi, on détermine une estimation pour chaque 𝑐i en fonction des valeurs calculées précédemment :
Enfin, on fait le parity-check avec tous les 𝑐i estimés. S’il réussit, on considère que la correction est bonne, sinon on retourne à l’étape 2
