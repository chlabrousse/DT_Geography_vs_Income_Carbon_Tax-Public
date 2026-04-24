function gamma = f_calc_CEV(p, s, V_init, V_target)

% Change in utility
dV = V_target- V_init ;

% parameters
U0 = sum(s.V.k.U.*s.V.H,2);
Exp0 = sum(s.V.k.Exp.*s.V.H,2);

% Prices
pC = (1+p.VAT) ; pE = (s.pe_h).*pC ; pH = s.pH_h ;
% (1-sigma)*epsilon_i
sig = (1-p.sigma) ;
sC = sig*p.epsilon_C ; sE = sig*p.epsilon_E ; sH = sig*p.epsilon_H ; 
% Lambda*p_i^(1-sigma)
lC = p.Lambda_C*pC^sig ; lE = p.Lambda_E*pE.^sig ; lH = p.Lambda_H*pH.^sig ;

% Change in U Comin in analytical form
gamma_U = exp(dV.*(1-p.beta));
U_change = U0.*gamma_U;

f_Exp = @(gamma_Exp) - ( Exp0.*gamma_Exp - ( ( lC.*U_change.^sC + lE.*U_change.^sE + lH.*U_change.^sH ).^( 1/sig )  + pE.*p.ebar ) ).^2;
[gamma_Exp, diff_comin]= f_goldenx( f_Exp  , 0.001 + U0.*0, 10+U0.*0 ) ; 
gamma = (gamma_Exp-1)*100;


end