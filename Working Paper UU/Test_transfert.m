
%% Uniform
d = s_opti(3).density.tot ; 
q = f_quantile_new2(p, 5, d, s_opti(3)) ;

(q.quintile.T-p.Transfer_init)./q.quintile.TI*100

%% Geo X Income
d = s_opti(5).density.tot ; 
q = f_quantile_new2(p, 5, d, s_opti(5)) ;

(q.quintile.T-p.Transfer_init)./q.quintile.TI*100

(q.type.T-p.Transfer_init)./q.type.TI*100