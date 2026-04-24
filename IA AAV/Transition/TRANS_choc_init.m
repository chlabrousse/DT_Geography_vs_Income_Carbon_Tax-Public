function tr_shock = TRANS_choc_init(p, s)

% Duration
T = p.T ; T_choc = 10 ;

% For each existing SS, create the transition shock

for i_SS = 1:length(s)
    if ~isempty(s(i_SS).rk)
        debut = s(1) ; final = s(i_SS) ;
        Dtau_h = final.tau_h- debut.tau_h ; Dtau_f = final.tau_f- debut.tau_f ;
        tr_shock(i_SS).tau_h(1:T_choc) = linspace(Dtau_h/T_choc,Dtau_h,T_choc) ;
        tr_shock(i_SS).tau_f(1:T_choc) = linspace(Dtau_f/T_choc,Dtau_f,T_choc) ;
        tr_shock(i_SS).tau_h(T_choc+1:T) = final.tau_h - debut.tau_h ;
        tr_shock(i_SS).tau_f(T_choc+1:T) = final.tau_f - debut.tau_f ;
    end
end


end
