function tr = TRANS_backward(p, t, tr)

% Prix pour le ménage
pf = p.p_F + tr.tau_h(t) ; p.eh = p.epsilon_h ;
p.m1 = (tr.p_N(t)/pf).^p.eh.*p.gamma_h./(1-p.gamma_h) ;
p.m2 = (1-p.gamma_h).^(1./p.eh) + (p.gamma_h).^(1./p.eh).*p.m1.^( (p.eh-1)./p.eh) ;
s.pe_h = p.m2.^(-p.eh./(p.eh-1) ).*(tr.p_N(t) + pf.*p.m1) ;
s.pH_h = kron(tr.p(:,t),ones(p.nb*p.nz,1)) ;

% Richesse et labor choice
a = p.s(:,1) ; z = p.s(:,2) ;
s.Transfer_type = p.Transfer_init + tr.CTR(t)*tr.vec_T ;
w = kron(tr.w(:,t),ones(p.nb*p.nz,1)) ;
s.lS_eff = p.lS*z.*p.z_type ; 
s.NLI  = p.lambda*(w.*s.lS_eff).^(1-p.tau) ;
s.TaxL = w.*s.lS_eff - s.NLI ;
s.v_profit = p.grid_profit*tr.profit_tot(t)./sum(p.grid_profit.*tr.density(:,t)) ;
s.RHS  = (1-p.tax_capital).*tr.R(t).*a + a + s.NLI + s.Transfer_type + s.v_profit ;
s.RHS  = s.RHS - p.migracost - s.pe_h.*(1+p.VAT).*p.ebar ;
s.RHS  = max(s.RHS, 0.001) ;
p.Umax = f_Umax(p, s) ;

% Maximisation
tr.V(t) = f_solve_VF_two_goods2(p, tr.Ve(:,t+1), s);

% La sauvegarde du Ve
tr.Ve(:,t)  = tr.V(t).Ve ;

end