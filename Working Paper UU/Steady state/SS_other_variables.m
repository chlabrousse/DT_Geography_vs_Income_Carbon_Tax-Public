function s = SS_other_variables(p, s)

% Government budget constraint
s.Transfer = s.density.tot'*s.Transfer_type ;
depenses_gov = s.R*p.public_debt + s.Transfer ;
revenus_VAT  = p.VAT.*( s.C + s.p_N.*s.N_h + p.p_F.*s.F_h  ) ;
revenus_K    = p.tax_capital*s.R*s.B_h  ;
revenus_W = s.density.tot'*s.TaxL ;   
s.revenus_gov = revenus_VAT + revenus_K + revenus_W + s.CTR ;    
s.G = s.revenus_gov - depenses_gov ;

% Market clearing Y
vec_Cost_mig = sum(s.V.H.*p.migracost,2) ;
s.Cost_mig = s.density.tot'*vec_Cost_mig ;
s.I = p.delta*s.K ;
s.F = s.F_h + s.F_y + s.F_N ;
s.Export = p.p_F.*s.F ; 
s.diff_Y = ( s.y /(s.C + s.I + s.G + s.Export + s.Cost_mig ) - 1 )*100;

% Other values
s.GDP = s.y + s.p_N.*s.N_h;
s.CE = zeros(p.n,1) ; % to use the quintile function without transition

% Display results
disp(['__________________ tau H = ' num2str(s.tau_h) ' -- tau F = ' num2str(s.tau_f)   ' ______________________' ]) ; 
disp(['r (%):  '  num2str(round((s.R)*100,2) ) ' --- Fossil :  '  num2str(s.F ,2) ' --- Time:  '  num2str(round(toc,1)) ]) ; 
disp([ 'Clearing Y = '  num2str(round(s.diff_Y,3))  ' --- K/Y = ' num2str(round(s.B_h/s.GDP ,2)) ]) ; 

% Density and values by type
A = reshape(s.density.tot,p.nb*p.nz,p.nk) ;
s.density.k = sum(A) ;
B = reshape( sum(A,2) , p.nb, p.nz) ;
s.density.z = sum(B) ;
s.density.b = sum(B,2) ;
v = s.V ; 
u = sum(v.H.*v.k.u,2) ;
s.u = s.density.tot'*u ;
for ik = 1:p.nk
    % Density of Z for each k, weighted by density of k
    I = (p.s(:,3)==ik) ;
    d = s.density.tot(I) ;
    B = reshape(A(:,ik),p.nb,p.nz)/sum(d) ;
    s.density.kz(:,ik) = sum(B) ;
    s.density.kb(:,ik) = sum(B,2) ;
    % Migration matrix k to k'
    s.matrice_migration(ik,:) = d'*(v.H(I,:))/sum(d) ;
    % Utility
    s.u_k(ik) = u(I)'*d/sum(d) ;
end

% Save coefficients for next time
if 1 == 0
    guess = s.guess; save('save_guess.mat', 'guess'); 
    Ve_guess = s.Ve_guess; save('save_Ve_guess.mat', 'Ve_guess'); 
    jacinv = s.jacinv; save('save_jacinv.mat', 'jacinv'); 
    density = s.density.tot ; save('save_density.mat', 'density'); 
end

end
