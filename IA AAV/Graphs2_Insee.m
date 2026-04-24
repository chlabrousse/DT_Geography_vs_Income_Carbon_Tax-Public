addpath('Fonctions','Steady state','Transition','Figures calibration','Figures results','Save') 

%% 1) tau_h vs tau_f
QQ = fig_W_cross_double(p, s(1), tr10G, tr01G);
a = round(QQ.quintile.WE10,1);
b = round(QQ.type.WE10,1);

a2 = round(QQ.quintile.WE01,1);
b2 = round(QQ.type.WE01,1);

%% 2) tau h et tau f: G
QQ = fig_W_cross_double(p, s(1), tr11G, tr11G);
aG = round(QQ.quintile.WE10,2);
bG = round(QQ.type.WE10,2);


%% 3) transferts
QQ_T = fig_W_cross_double(p, s_opti(1), tr11T_uni_10, tr11T_geo_10);
a_T_uni = round(QQ_T.quintile.WE10,1);
b_T_uni = round(QQ_T.type.WE10,1);
a_T_geo = round(QQ_T.quintile.WE01,1);
b_T_geo = round(QQ_T.type.WE01,1);

% share of transfers in total income: uniform
QQ_test = fig_W_cross_double(p, s_opti(3), tr11T_uni_10, tr11T_geo_10);
(QQ_test.quintile.T - p.Transfer_init)./QQ_test.quintile.TI*100

% share of transfers in total income: income X geo
QQ_test2 = fig_W_cross_double(p, s_opti(5), tr11T_uni_10, tr11T_geo_10);
(QQ_test2.quintile.T - p.Transfer_init)./QQ_test2.quintile.TI*100



%% 4) valeur taxes carbone en euros

% Dépenses en euros dans F = 1466 euros
% (1+tva)*(pF+tau_h).*F_h = 1466
% donc tau_h + p.p_F = 14666/((1 + p.VAT).*3.7) en euros
% tau_h = x.*(tau_h+p_F)
all = 1466/((1 + p.VAT).*3.7);
tau_h = s(1).tau_h./(s(1).tau_h+p.p_F).*all;
tau_f = p.data.ratio_PLF.*tau_h;

% donc en euros:  s(1).tau_h  = 0.6625 = 160.1460 euros
tau_h_only = s(2).tau_h./s(1).tau_h.*tau_h-tau_h;
tau_f_only = s(3).tau_f./s(1).tau_f.*tau_f-tau_f;

tau = s(4).tau_f./s(1).tau_f.*tau_f-tau_f;
% equivalent: tau = s(4).tau_h./s(1).tau_h.*tau_h-tau_h;

tau_T = s_opti(3).tau_f./s(1).tau_f.*tau_f-tau_f;
tau_T_geo = s_opti(5).tau_f./s(1).tau_f.*tau_f-tau_f;