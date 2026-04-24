%% Plot matrice transition modele et data

function fig_density_change_transition2(p, s, tr, tr2)

for t=1:p.T-1
    for ik = 1:p.nk
        I = (p.s(:,3)==ik) ;
        d = tr.density(I,t) ;
        % Migration matrix k to k'
        P(t).matrice_migration(ik,:) = d'*(tr.V(t).H(I,:))/sum(d) ;

        d2 = tr.density(I,t) ;
        P2(t).matrice_migration(ik,:) = d'*(tr2.V(t).H(I,:))/sum(d) ; 
    end
end

%
mat1 = 0.*s.matrice_migration;
mat2 = mat1;
for t=1:p.T-1
    mat1 = mat1 + P(t).matrice_migration - s.matrice_migration;  
    mat2 = mat2 + P2(t).matrice_migration - s.matrice_migration;  
end 

fig_mat_migration_transition2(mat1, mat2)



end