
function m = f_run(tr_init, var, p, chocX, SS, d_trans)

% 1) Create shocks
T = p.T ;
tr_Jaco = tr_init ; 
tr_Jaco.density = repmat(SS.density.tot, 1, p.T) ;
tr_Jaco.(var)(T-1) = SS.(var) + chocX ;

% 2) Backward and compute transition matrixes
tr_Jaco = f_firm_N(p , tr_Jaco) ;
tr_Jaco = f_firm_Y(p , tr_Jaco) ;
for t=T:-1:1  
    tr_Jaco = TRANS_backward(p, t, tr_Jaco)  ;
    a(t).mat = f_matrice_transition3(p, tr_Jaco.V(t).k.ap, tr_Jaco.V(t).H ) ;
end 

% 3) Calcul des clearing pour le choc à chaque période
% 3) Compute clearing for each period shock
for s=1:T-1 % Date of the shock
    Jaco_tempo = tr_init ;
    % 3.1) Households clearing
    for t=1:T-1
        if t > s+1        % If the s-shock has no effect at t, same matrix and rule as SS 
            matrice = SS.mat ;
            rule  = SS.V ;  
        elseif t <= s+1   % Before or during the shock
            X = (T-1) - (s-t) ; % distance to the shock
            matrice = a(X).mat  ;
            rule  = tr_Jaco.V(X) ;  
        end
        d_trans(:,t+1) = matrice*d_trans(:,t) ;
        % Compute aggregate variables
        Jaco_tempo = TRANS_mesure(p, Jaco_tempo , t, d_trans(:,t), rule) ;
    end 
    
    % 3.2) Values for firms and government
    Jaco_tempo.(var)(s) = SS.(var) + chocX ;
    Jaco_tempo = f_firm_N(p , Jaco_tempo) ;
    Jaco_tempo = f_firm_Y(p , Jaco_tempo) ;
    
    % 3.3) Compute clearing and create the matrix 
    [Erreur,~]  = TRANS_clearing(p, Jaco_tempo)  ; 
    mat_derivees.(var)(:,s) = Erreur(:)/chocX ; 
end 

m = mat_derivees.(var) ;

end