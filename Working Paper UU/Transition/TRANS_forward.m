function tr= TRANS_forward(p, tr , t)

%% 1) Trouver la matrice de transition avec la decision rule
rule = tr.V(t) ;
matrice_transition = f_matrice_transition3(p, rule.k.ap, rule.H ) ;
tr.mat(t).mat = matrice_transition ;

%% 2) Trouver la densite suivante avec la matrice de transition
tr.density(:,t+1) = matrice_transition*tr.density(:,t) ;

%% 3) Calcul des agrégats
tr = TRANS_mesure(p, tr , t, tr.density(:,t), rule) ;

end




