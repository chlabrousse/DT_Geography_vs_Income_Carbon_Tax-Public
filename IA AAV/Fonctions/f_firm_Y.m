function s = f_firm_Y(p,s)

% Values
s.y_k = [s.Y1 ; s.Y2 ; s.Y3 ; s.Y4 ; s.Y5] ; 
pf = p.p_F + s.tau_f ;
ey = p.epsilon_y ;
om = p.omega_y ;
sy = p.sigma_y ;
gy = p.gamma_y;
alpha = p.alpha;

% BUNDLE E: Compute pE
m1 = (s.p_N./pf).^ey.*gy./(1-gy) ;
m2 = (1-gy).^(1./ey) + (gy).^(1./ey).*m1.^( (ey-1)./ey) ;
s.pE = m2.^(-ey/(ey-1) ).*(s.p_N + pf.*m1) ;

% MAX PROFIT: Compute E and X
k1 = (p.a*sy-sy+1)/p.a ;
s.E_y_k = om.*p.a.^(sy).*s.pE.^(-sy).*s.y_k.^k1 ;
S = (sy-1)/sy ;
X = ( (1-om).^(-1/sy) .* ( (s.y_k).^(S/p.a) - om.^(1/sy).*(s.E_y_k).^(S)  ) ).^(1/S)  ; 
pX = s.pE.*( (1-om)./om.*s.E_y_k./X).^(1/sy) ;

% BUNDLE X
s.l_y_k = (alpha./s.rk.*pX).^(alpha/(alpha-1) ).*X ; 
s.k_y_k = X.^(1/alpha).*s.l_y_k.^( (alpha-1)/alpha) ;
s.w = (1-alpha)/alpha*s.rk.*(X./s.l_y_k).^(1/alpha) ;

% Compute Fy and Ny
s.N_y_k = s.E_y_k.*m2.^(-ey/(ey-1) ) ;
s.F_y_k = m1.*s.N_y_k ;

% Check
s.profit_Y_k =  s.y_k - s.rk.*s.k_y_k - s.w.*s.l_y_k - s.pE.*s.E_y_k ; 
% pE.*s.E_y_k - s.p_N.*s.N_y_k - pf.*s.F_y_k ;

% Aggregation
s.k_y = sum(s.k_y_k) ;
s.y   = sum(s.y_k) ; 
s.E   = sum(s.E_y_k) ; 
s.profit_Y =  sum(s.profit_Y_k) ; 
s.N_y = sum(s.N_y_k) ; 
s.F_y = sum(s.F_y_k) ;   

% Housing
s.p = [s.p1 ; s.p2 ; s.p3 ; s.p4 ; s.p5] ;
s.H_k_supply = p.H_k.*s.p.^p.delta_F ;
s.H_supply = sum(s.H_k_supply) ;

% Interest rate given to households
s.K = s.k_N + s.k_y ;
pH_H = sum(s.H_k_supply.*s.p) ;
s.R = ( (s.rk-p.delta).*s.K + pH_H)./(s.K + s.H_supply) ;
s.profit_tot = s.profit_Y + s.profit_N ;

end

