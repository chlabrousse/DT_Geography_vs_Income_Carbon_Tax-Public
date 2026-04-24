function s = SS_clearing(p, s)

%% Errors
s.it =  s.it +1;     
[s.Erreur,s.diff] = deal([]) ;

% Capital Market (rK)
a = s.B_h ;
b = s.K + s.H_supply + p.public_debt ;
s.Erreur = [s.Erreur, a - b] ;        
s.diff   = [s.diff, (a./b -1)*100] ;

% Nuclear/Electricity energy markets (N )
a = s.N ;
b = s.N_h + s.N_y ;
s.Erreur = [s.Erreur, a - b] ;        
s.diff   = [s.diff, (a./b -1)*100] ;

% Carbon tax revenue (CTR) (eps to avoid NaN value)
a = s.CTR + eps ;
b = s.CTR_implied + eps ;
s.Erreur = [s.Erreur, a - b] ;        
s.diff   = [s.diff, (a./b -1)*100] ;
%s.diff   = [s.diff, 0] ;

% Clearing labor markets 
a = s.l_y_k' ;
b = s.L_h' ;
s.Erreur = [s.Erreur, a - b] ; 
s.diff   = [s.diff, (a./b -1)*100] ;

% Clearing housing markets 
a = s.H_k_demand' ;
b = s.H_k_supply' ;
s.Erreur = [s.Erreur, a - b] ;        
s.diff   = [s.diff, (a./b -1)*100] ;


end 