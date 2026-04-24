function [Erreur,diff] = TRANS_clearing(p, tr)

x = 1:(p.T-1) ;  
[Erreur,diff] = deal([]) ;

% Capital Market (rK)
a = tr.B_h(x) ;
b = tr.K(x) + tr.H_supply(x) + p.public_debt ;
Erreur = [Erreur ; a - b] ;        
diff   = [diff ; (a./b -1)*100] ;

% Nuclear/Electricity energy markets (N )
a = tr.N(x) ;
b = tr.N_h(x) + tr.N_y(x) ;
Erreur = [Erreur ; a - b] ;        
diff   = [diff ; (a./b -1)*100] ;

% Carbon tax revenue (CTR) (eps to avoid NaN value)
CTR_implied = (1+p.VAT).*tr.tau_h(x).*tr.F_h(x) + tr.tau_f(x).*(tr.F_y(x)+tr.F_N(x)) ; 
a = tr.CTR(x) + eps ;
b = CTR_implied + eps ;
Erreur = [Erreur ; a - b] ;        
diff   = [diff ; (a./b -1)*100] ;

% Clearing labor markets 
a = tr.l_y_k(:,x) ;
b = tr.L_h(:,x) ;
Erreur = [Erreur ; a - b] ; 
diff   = [diff ; (a./b -1)*100] ;

% Clearing housing markets 
a = tr.H_k_demand(:,x) ;
b = tr.H_k_supply(:,x) ;
Erreur = [Erreur ; a - b] ;        
diff   = [diff ; (a./b -1)*100] ;

% Pour mettre en colonne le temps
Erreur = Erreur' ;
% plot(Erreur)

end

