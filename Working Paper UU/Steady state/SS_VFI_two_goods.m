function s = SS_VFI_two_goods(p, s)     

% Prices for households
pf = p.p_F+s.tau_h ; p.eh = p.epsilon_h ;
p.m1 = (s.p_N/pf).^p.eh.*p.gamma_h./(1-p.gamma_h) ;
p.m2 = (1-p.gamma_h).^(1./p.eh) + (p.gamma_h).^(1./p.eh).*p.m1.^( (p.eh-1)./p.eh) ;
s.pe_h = p.m2.^(-p.eh./(p.eh-1) ).*(s.p_N + pf.*p.m1) ;
s.pH_h = kron(s.p(:),ones(p.nb*p.nz,1)) ;

% Right-hand side and labor choice
a = p.s(:,1) ; z = p.s(:,2) ;
s.Transfer_type = p.Transfer_init + s.CTR*s.vec_T ;
s.w_h = kron(s.w(:),ones(p.nb*p.nz,1)) ;
s.lS_eff = p.lS*z.*p.z_type ; 
s.NLI  = p.lambda*(s.w_h.*s.lS_eff).^(1-p.tau) ;
s.TaxL = s.w_h.*s.lS_eff - s.NLI ;
s.v_profit = p.grid_profit*s.profit_tot./sum(p.grid_profit.*s.density.tot) ;
s.RHS  = (1-p.tax_capital).*s.R.*a + a + s.NLI + s.Transfer_type + s.v_profit ;
s.RHS  = s.RHS - p.migracost - s.pe_h.*(1+p.VAT).*p.ebar ;
s.RHS  = max(s.RHS, 0.001) ;
%s.RHS  = max(s.RHS, 0.00001) ;
p.Umax = f_Umax(p, s) ;

% VFI
vdiff = 1; iters = 0; Nhoward = 30;  
V_Vec = s.Ve_guess ;
while vdiff > p.tolV
    iters = iters + 1;
    % Solve problem
    v = f_solve_VF_two_goods2(p, V_Vec, s);
    % Update VF guess
    vdiff = norm(V_Vec - v.Ve,1)/norm(V_Vec,1) ;
    V_Vec = v.Ve; 

    % Howard improvment
    for howard = 1:Nhoward %30
        Ve_coeff = reshape(V_Vec, p.dim);
        for ik = 1:p.nk
            V_interp = griddedInterpolant({p.bgrid,p.zgrid},Ve_coeff(:,:,ik),'spline');
            V_howard_k(:,ik) = v.k.u(:,ik) + p.beta*V_interp(v.k.ap(:,ik),z); 
        end
        x = V_howard_k/p.gumb ;
        V_howard = p.gumb*( x(:,1) + log( sum( exp( x-x(:,1) ),2 ) ) ) ;
        V_Vec = p.Emat*V_howard;
    end
end


%% Values for calibration

% Expenditures 
C_exp = (1+p.VAT)*v.k.c ;
E_exp = (1+p.VAT).*s.pe_h.*v.k.eh ; 
H_exp = s.pH_h.*v.k.H ; 
v.k.expT = C_exp + E_exp + H_exp ;
v.k.expE = 100*E_exp./v.k.expT ;
v.k.expH = 100*H_exp./v.k.expT ;
% Energy mix
F_exp = (1+p.VAT).*pf.*v.k.Fh ; 
N_exp = (1+p.VAT).*s.p_N.*v.k.Nh ;
v.k.expF = 100*F_exp./v.k.expT ;
v.k.expN = 100*N_exp./v.k.expT ;

% Save
s.V = v ;
s.Ve_guess = v.Ve ;
% TEST : s.pe_h.*v.k.eh - s.p_N.*v.k.Nh - (s.p_F+s.tau_h).*v.k.Fh

end