function s = SS_conv(p, choc)

% Initial guess and first run
s = SS_V_guess(p, choc) ;
s = ffA(p,s) ;
s = SS_newton(p, s) ;
damp = 0.75 ; new = 100 ; 

while max(abs(s.diff) ) >  p.tolconv*50 && s.it <=200
    % if s.it==15 ; damp=damp/2 ; end
    % if sum(abs(s.diff)) < 1 ; 0.05 ; end
    d = -(s.jacinv*damp*s.Erreur(:));
    for i = 1:length(p.list_var) ; s.guess.(p.list_var(i)) = s.(p.list_var(i)) + d(i) ; end
    Old_Error = s.Erreur(:) ;
    s = ffA(p,s) ;
    % New jacobian si on ne l'a pas déjà en paramètre
    if ~isfield(p, 'jacinv')
        u = s.jacinv*(s.Erreur(:)-Old_Error);
        s.jacinv = s.jacinv + ((d-u)*(d'*s.jacinv))/(d'*u);
    end
    if mod(s.it,new) == 0 ; s = SS_newton(p, s) ; disp('Jaco change') ; end
end
s = SS_other_variables(p, s) ;

%% MAIN FUNCTION TO COMPUTE THE ERROR GIVEN THE GUESSES
function s = ffA(p,s)
    for var = p.list_var ; s.(var) = s.guess.(var) ; end
    s = f_firm_N(p , s) ;
    s = f_firm_Y(p , s) ;
    s = SS_VFI_two_goods(p, s);
    s = SS_mesure_1asset(p, s);
    s = SS_clearing(p, s);
    disp(['Tot:   ' num2str(sum(abs(s.diff))) ]);
end

end
