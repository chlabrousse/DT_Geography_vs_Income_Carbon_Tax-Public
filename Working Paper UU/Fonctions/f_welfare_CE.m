function CE = f_welfare_CE(p, s, tr)

% Target to reach
V1 = tr.V(1).V ;
% Values at the SS
V0 = s.V.V ;
U0 = sum(s.V.H.*s.V.k.U,2);
% Equality: V_0-log(U0)+log(U_eq)=V1 donc U_eq=exp[V1-V0+log(U0)]
U_eq = exp(V1-V0+log(U0));
% Find the C0*x that yields this U_eq
c0  = sum(s.V.H.*s.V.k.c,2);
eh0 = sum(s.V.H.*s.V.k.eh,2);
H0  = sum(s.V.H.*s.V.k.H,2);
A = (p.sigma-1)/p.sigma ;
lC = p.Lambda_C.^(1/p.sigma) ;
lE = p.Lambda_E.^(1/p.sigma) ;
lH = p.Lambda_H.^(1/p.sigma) ;

fV = @(x)  lC.*( c0.*(1+x/100)./(U_eq.^p.epsilon_C) ).^A ...
         + lE.*( (eh0-p.ebar) ./(U_eq.^p.epsilon_E) ).^A  ...
         + lH.*( (H0)         ./(U_eq.^p.epsilon_H) ).^A - 1 ;

[CE,diff] = fsolve(fV,0*V0) ;
disp(max(abs(diff)))


end