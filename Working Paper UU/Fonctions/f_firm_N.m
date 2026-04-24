function s = f_firm_N(p , s)

% FOC
pf = p.p_F + s.tau_f ;
s.p_N = ( s.rk./p.zeta ).^(p.zeta).*( pf./(1-p.zeta) ).^(1-p.zeta)  ;
s.k_N = s.p_N.*p.zeta.*s.N./s.rk ;
s.F_N = s.p_N.*(1-p.zeta).*s.N./pf ;

% Profit
s.profit_N = s.p_N.*s.N - s.rk.*s.k_N - pf.*s.F_N ; 

end