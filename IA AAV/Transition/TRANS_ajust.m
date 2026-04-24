function tr = TRANS_ajust(p, tr, inv_J)

%% 1) Calcul de l'erreur et nouveau guess
T = p.T ;
[Erreur,tr.diff] = TRANS_clearing(p , tr) ; 

%% Affichage
tr.it = tr.it+1; k = 1:T-1 ;
tr.Erreur_max = max( abs(tr.diff') ) ; 
disp(['It '  num2str(tr.it) ' -- Diff : '  num2str(tr.Erreur_max,2)  ' -- Time: '  num2str(toc,2)   ]) ;
% Sauvegarde pour IRF
%[tr.R_save,  tr.Y_save, tr.tau_save] = deal(tr.R, tr.Y, tr.tau); 

%% Nouveau guess
tr.dampening = .5 ; 
tr.x = tr.x - (inv_J*tr.dampening*Erreur(:))';
n_guess = length(p.list_var) ; i_var = 0 ;
x2 = reshape(tr.x,T-1,n_guess) ;
for var = p.list_var
    i_var = i_var + 1 ;
    tr.(var)(k)  = x2(:,i_var); 
end


end

