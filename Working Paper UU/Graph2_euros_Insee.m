%% 1) income to change results in euros
d = s(1).density.tot ; 
a = f_quantile_new2(p, 5, d, s(1)) ;

% Put a price index with the disposable income from Insee 2018
DI_Insee = [10030	15910	19730	23680	28150	33320	39260	46450	57230	102880] ; % Source Insee 2018 - Revenus et patrimoine des ménages 
QI_Insee = mean(reshape(DI_Insee,2,5)) ;

% Disposable income in model per quintiles
QI_model = a.quintile.TI;
price_index =  mean(QI_Insee)/mean(QI_model);
QI_model = QI_model.*price_index;

% Disposable income in model per cities
QI_model_cities = a.type.TI;
price_index_cities =  mean(QI_Insee)/sum(QI_model_cities.*s(1).density.k);
QI_model_cities = QI_model_cities.*price_index_cities;

scale_Insee = 15.666667;

%% 2) euros tau_h vs tau_f
QQ = fig_W_cross_double(p, s(1), tr10G, tr01G);
a = QQ.quintile.WE10/scale_Insee.*QI_model/100;
b = QQ.type.WE10/scale_Insee.*QI_model_cities/100;

a2 = QQ.quintile.WE01/scale_Insee.*QI_model/100;
b2 = QQ.type.WE01/scale_Insee.*QI_model_cities/100;

%% 3) euros G
QQ = fig_W_cross_double(p, s(1), tr11G, tr11G);
a = QQ.quintile.WE10/scale_Insee.*QI_model/100;
b = QQ.type.WE10/scale_Insee.*QI_model_cities/100;


%% Other experiments
d = s_opti(1).density.tot ; 
a = f_quantile_new2(p, 5, d, s_opti(1)) ;

% Disposable income in model per quintiles
QI_model = a.quintile.TI;
price_index =  mean(QI_Insee)/mean(QI_model);
QI_model = QI_model.*price_index;

% Disposable income in model per cities
QI_model_cities = a.type.TI;
price_index_cities =  mean(QI_Insee)/sum(QI_model_cities.*s_opti(1).density.k);
QI_model_cities = QI_model_cities.*price_index_cities;



%% 3) euros pour G
QQ_G = fig_W_cross_double(p, s_opti(1), tr10G, tr11G_10);
a_G = QQ_G.quintile.WE01/scale_Insee.*QI_model/100;
b_G = QQ_G.type.WE01/scale_Insee.*QI_model_cities/100;



%% 3) euros pour transferts
QQ_T = fig_W_cross_double(p, s_opti(1), tr11G_10, tr11T_uni_10);
a_T_uni = QQ_T.quintile.WE01/scale_Insee.*QI_model/100;
b_T_uni = QQ_T.type.WE01/scale_Insee.*QI_model_cities/100;

QQ_T_target = fig_W_cross_double(p, s_opti(1), tr11T_inc_10, tr11T_geo_10);
a_T_inc = QQ_T_target.quintile.WE10/scale_Insee.*QI_model/100;
b_T_inc = QQ_T_target.type.WE10/scale_Insee.*QI_model_cities/100;

a_T_geo = QQ_T_target.quintile.WE01/scale_Insee.*QI_model/100;
b_T_geo = QQ_T_target.type.WE01/scale_Insee.*QI_model_cities/100;


