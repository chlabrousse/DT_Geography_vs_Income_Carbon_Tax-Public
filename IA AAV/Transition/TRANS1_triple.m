function tr = TRANS1_triple(p, choc, SS_debut, SS_final, inv_J, varargin)

% Initial and final values
T = p.T ; tic_transition = tic ;
tr.density = repmat(SS_debut.density.tot, 1, T) ; % pour le C
tr.B_h(1) = SS_debut.B_h ;  
tr.Ve(:,T) = SS_final.V.Ve ;  
tr.tau_h = SS_debut.tau_h + choc.tau_h ;
tr.tau_f = SS_debut.tau_f + choc.tau_f ;
tr.vec_T = SS_final.vec_T ;

% Guess
for var = p.list_var ; tr.(var)(1:T) = SS_final.(var) ; end
if ~isempty(varargin) % If there is a guess
    for var = p.list_var ; tr.(var)(1:T-1) = varargin{1}.(var)(1:T-1) ; end
end
tr.x = [] ; 
for var = p.list_var ; tr.x = [tr.x , tr.(var)(1:T-1)] ; end


%% Transition shock in t = 1
tr.it = 0; tr.Erreur_max = 10 ; 
while max(tr.Erreur_max) > 1e-2 && tr.it <100 ; tic
    tr = f_firm_N(p , tr) ;
    tr = f_firm_Y(p , tr) ;
    for t=T-1:-1:1 ;  tr = TRANS_backward(p, t, tr)  ;  end
    for t=1:T-1    ;  tr = TRANS_forward(p, tr , t)   ;  end 
    tr = TRANS_ajust(p, tr, inv_J) ;
end
disp(['Calcul de la Transition : ' num2str(toc(tic_transition),2) ' secondes']) 
tr = TRANS_other_variables(p, tr, choc, SS_debut, SS_final) ;


end
