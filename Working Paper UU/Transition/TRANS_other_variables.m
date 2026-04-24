function tr = TRANS_other_variables(p, tr, choc, SS_debut, SS_final)

T = p.T ;
% Valeurs de transition
for t=1:T-1
    pop = tr.density(:,t) ; rule = tr.V(t) ;
    tr.C(t) = sum(rule.k.c.*rule.H,2)'*pop  ;
    % Gouv
    revenus_W(t) = pop'*(rule.taxL ) ;   
    Transfer_type = p.Transfer_init + tr.CTR(t)*tr.vec_T ;
    tr.Transfer(t) = pop'*Transfer_type ;
    % Utilité
    tr.U(t) = sum(rule.k.u.*rule.H,2)'*pop  ;
    % Migracost
    vec_Cost_mig = sum(rule.H.*p.migracost,2) ;
    tr.Cost_mig(t) = pop'*vec_Cost_mig ;
end
tr.C(T) = SS_final.C ;
tr.F_h(T) = SS_final.F_h ;
tr.N_h(T) = SS_final.N_h ;
revenus_W(T) = revenus_W(T-1) ;
tr.Cost_mig(T) = tr.Cost_mig(T-1) ;
tr.Transfer(T) = SS_final.Transfer ;

% Gouv
depenses_gov = tr.R*p.public_debt + tr.Transfer ;
revenus_VAT  = p.VAT.*( tr.C + tr.p_N.*tr.N_h + p.p_F.*tr.F_h  ) ;
revenus_K    = p.tax_capital*tr.R.*tr.B_h  ;
tr.revenus_gov = tr.CTR + revenus_VAT + revenus_K + revenus_W ;    
tr.CTR = (1+p.VAT)*tr.tau_h.*tr.F_h + tr.tau_f.*(tr.F_y+tr.F_N) ; 
tr.G = tr.revenus_gov - depenses_gov ;

% Clearing Y
K_next = [tr.K(2:T), SS_final.K] ;
tr.I = K_next - (1-p.delta)*tr.K ;
tr.F = tr.F_h + tr.F_y + tr.F_N ;
tr.Export = p.p_F.*tr.F ; 
clearing_Y = tr.y - tr.C - tr.I - tr.G - tr.Export - tr.Cost_mig ;
tr.clearing_Y = 100*clearing_Y./tr.y ;

% Calculs par type k
for t=1:T-1
    d_tempo = tr.density(:,t) ; v = tr.V(t) ;
    C     = sum(v.H.*v.k.c,2) ;
    lS_eff = p.lS*p.s(:,2).*p.z_type ; 
    H     = sum(v.H.*v.k.H,2) ;
    for ik = 1:p.nk   
        I = (p.s(:,3)==ik) ; dk = d_tempo(I) ;
        % Labor et housing
        tr.L_h(ik,t)  = lS_eff(I)'*d_tempo(I) ;
        tr.H_k_demand(ik,t)  = H(I)'*d_tempo(I) ;
        % Densité par K
        tr.density_k(ik,t) = sum(dk) ;
        % Variables pondérées par densité
        tr.c_k(ik,t) = C(I)'*dk/sum(dk) ;
    end
end


end
