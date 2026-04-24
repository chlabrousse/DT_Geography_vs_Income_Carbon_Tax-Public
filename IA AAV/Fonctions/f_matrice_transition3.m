function matrice_transition = f_matrice_transition3(p, bp, H)

% Pour plus de clarte
nz = p.nz ; nb = p.nb ; 

% Optimal indexes : Put the rule on the grid
bp = min(p.bmax,bp) ;
bp = max(p.bmin,bp) ;
[~,~,ligne_inf] = histcounts(bp,p.bgrid);
ligne_sup = min( ligne_inf + 1, nb ) ; % point superieur

% Find Weights for inferior and superior bounds
poids_sup = ( bp - p.bgrid(ligne_inf) ) ./ (p.bgrid(ligne_sup) - p.bgrid(ligne_inf) ) ;
poids_inf = 1 - poids_sup ;

% Créer les matrices pour chaque Z
B_ligne_sup = repmat(ligne_sup,1,nz) ;
B_ligne_inf = repmat(ligne_inf,1,nz) ;
B_poids_sup = repmat(poids_sup,1,nz) ;
B_poids_inf = repmat(poids_inf,1,nz) ;

% Coller pour inf et sup
C_ligne = [B_ligne_inf , B_ligne_sup] ;
C_poids = [B_poids_inf , B_poids_sup] ;

% Indice total de ligne
ligne = C_ligne + p.ligne_kz ;

% Poids de k
poids_k = repmat(H,1,nz*2) ;
% Indice total de poids
poids = C_poids.*p.poids_z.*poids_k ;

% Créer la matrice sparse
matrice_transition = sparse(ligne(:), p.i_col(:), poids(:), p.n, p.n) ;


end
