function tr = TRANS_mesure(p, tr , t, pop, rule)

tr.B_h(t+1) = sum(rule.k.ap.*rule.H,2)'*pop  ;
tr.F_h(t)   = sum(rule.k.Fh.*rule.H,2)'*pop  ;
tr.N_h(t)   = sum(rule.k.Nh.*rule.H,2)'*pop  ;
% Calculs par type k
lS_eff = p.lS*p.s(:,2).*p.z_type ; 
H     = sum(rule.H.*rule.k.H,2) ;
for ik = 1:p.nk   
    I = (p.s(:,3)==ik) ; 
    tr.L_h(ik,t)  = lS_eff(I)'*pop(I) ;
    tr.H_k_demand(ik,t)  = H(I)'*pop(I) ;
end
% Autres
%tr.CTR_implied(t) = (1+p.VAT).*tr.tau_h(t).*tr.F_h(t) + tr.tau_f(t).*(tr.F_y(t)+tr.F_N(t)) ; 


end




