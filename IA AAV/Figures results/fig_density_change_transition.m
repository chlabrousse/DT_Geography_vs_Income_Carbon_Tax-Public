%% Plot matrice transition modele et data

function fig_density_change_transition(p, s, tr)

for t=1:p.T-1
    for ik = 1:p.nk
        I = (p.s(:,3)==ik) ;
        d = tr.density(I,t) ;
        % Migration matrix k to k'
        P(t).matrice_migration(ik,:) = d'*(tr.V(t).H(I,:))/sum(d) ;
    end
end

fig_mat_migration_transition(P(1), P(3), P(5), P(10), s(1))



end