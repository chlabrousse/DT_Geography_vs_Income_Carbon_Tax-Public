function m = run_newton(var, p, s, choc)
    v_tempo = s ; 
    v_tempo.(var) = s.(var) + choc  ; 

    % Computations
    v_tempo = f_firm_N(p , v_tempo) ;
    v_tempo = f_firm_Y(p , v_tempo) ;
    v_tempo = SS_VFI_two_goods(p, v_tempo); 
    v_tempo = SS_mesure_1asset(p, v_tempo);
    v_tempo = SS_clearing(p, v_tempo);
    m = (v_tempo.Erreur(:) - s.Erreur(:))./choc;   
end
