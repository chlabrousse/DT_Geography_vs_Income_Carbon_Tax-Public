function s = SS_mesure_1asset(p, s)
           
    %% Transition matrix
    v = s.V ;
    matrice_transition = f_matrice_transition3(p, v.k.ap, v.H) ;
    s.mat = matrice_transition ;

    %% Density     
    %d_tempo = ones(p.n,1)/p.n ;
    d_tempo = s.density.tot ;
    %d_tempo = p.vec_d ;
    test = 1 ;
    while test > 10^(-8)
        density1 = matrice_transition*d_tempo;
        test = sum(sum(abs(density1-d_tempo))) ;
        d_tempo = density1;
    end
    s.density.tot = d_tempo ;
    A = reshape(s.density.tot,p.nb*p.nz,p.nk) ;
    s.density.k = sum(A) ;
    
    % Compute aggregate variables
    s.B_h   = sum(v.k.ap.*v.H,2)'* d_tempo  ;
    s.F_h   = sum(v.k.Fh.*v.H,2)'* d_tempo  ;
    s.N_h   = sum(v.k.Nh.*v.H,2)'* d_tempo  ;
    s.E_h   = sum(v.k.eh.*v.H,2)'* d_tempo  ;
    s.C     = sum(v.k.c.*v.H,2)'* d_tempo  ;
    
    % Compute variables by type k
    Exp_H = sum(v.H.*v.k.expH,2) ;
    Exp_Tot = sum(v.H.*v.k.expT,2) ;
    Exp_E = sum(v.H.*v.k.expE,2) ;
    Exp_F = sum(v.H.*v.k.expF,2) ;
    C     = sum(v.H.*v.k.c,2) ;
    H     = sum(v.H.*v.k.H,2) ;
    for ik = 1:p.nk   
        I = (p.s(:,3)==ik) ; dk = d_tempo(I) ;
        % Labor and housing
        s.L_h(ik,1)  = s.lS_eff(I)'*d_tempo(I) ;
        s.H_k_demand(ik,1)  = H(I)'*d_tempo(I) ;
        % Variables weighted by density
        s.Exp_E_k(ik) = Exp_E(I)'*dk/sum(dk) ;
        s.Exp_F_k(ik) = Exp_F(I)'*dk/sum(dk) ;
        s.Exp_H_k(ik) = Exp_H(I)'*dk/sum(dk) ;
        s.c_k(ik) = C(I)'*dk/sum(dk) ;
        s.Exp_tot_k(ik) = Exp_Tot(I)'*dk/sum(dk) ;
    end
    % Other
    s.CTR_implied = (1+p.VAT).*s.tau_h.*s.F_h + s.tau_f.*(s.F_y+s.F_N) ;

    

end
