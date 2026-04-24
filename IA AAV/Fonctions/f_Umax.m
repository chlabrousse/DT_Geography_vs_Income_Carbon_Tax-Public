function U = f_Umax(p, s)

% Prices
pC = (1+p.VAT) ; pE = (s.pe_h).*pC ; pH = s.pH_h ;
% (1-sigma)*epsilon_i
sig = (1-p.sigma) ;
sC = sig*p.epsilon_C ; sE = sig*p.epsilon_E ; sH = sig*p.epsilon_H ; 
% Lambda*p_i^(1-sigma)
lC = p.Lambda_C*pC^sig ; lE = p.Lambda_E*pE.^sig ; lH = p.Lambda_H*pH.^sig ;

% Initial bounds
U_low = 0*s.RHS ;
U_top = 2*s.RHS+1 ;
diff = 10 ; it = 0 ; 
target = p.bmin + 1e-6 ;

while max(abs(diff),[],'all') > 1e-6 && it < 1000
    it = it+1 ;
    U = (U_low+U_top)/2 ;
    E = (lC.*U.^sC + lE.*U.^sE + lH.*U.^sH ).^( 1/sig )  ;
    fap  = s.RHS - E  ;
    diff = fap - target ;
    U_low(diff>0) = U(diff>0) ;
    U_top(diff<0) = U(diff<0) ;
    %max(abs(diff),[],'all')
end
if it == 1000 ; disp('umax error') ; end


end
