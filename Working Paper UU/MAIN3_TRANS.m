
%% Initialize shocks

tr_shock = TRANS_choc_init(p, s) ;
tr_shock_opti = TRANS_choc_init(p, s_opti) ;



%% 2) TRANSITIONS Final with one tax, G

% 2) Transition s00G -> s10G
i = 2 ; 
inv_J = TRANS0_Fake_News(p, s(i));
tr10G = TRANS1_triple(p, tr_shock(i), s(1), s(i), inv_J) ;

% 3) Transition s00G -> s01G
i = 3 ; 
%inv_J = TRANS0_Fake_News(p, s(i));
tr01G = TRANS1_triple(p, tr_shock(i), s(1), s(i), inv_J) ;

% 4) Transition s00G -> s11G
i = 4 ; 
%inv_J = TRANS0_Fake_News(p, s(i));
tr11G = TRANS1_triple(p, tr_shock(i), s(1), s(i), inv_J) ;


%% 3) TRANSITIONS Final with 10% reduction emissions

% 2) Transition G 10% s00G -> s11G
i = 2 ; 
inv_J = TRANS0_Fake_News(p, s_opti(i));
tr11G_10 = TRANS1_triple(p, tr_shock_opti(i), s_opti(1), s_opti(i), inv_J) ;

% 3) Transition T_uni 10% s00G -> s11T_uni
i = 3 ; 
inv_J = TRANS0_Fake_News(p, s_opti(i));
tr11T_uni_10 = TRANS1_triple(p, tr_shock_opti(i), s_opti(1), s_opti(i), inv_J) ;

% 4) Transition T_income 10% s00G -> s11T_inc
i = 4 ; 
%inv_J = TRANS0_Fake_News(p, s_opti(i));
tr11T_inc_10 = TRANS1_triple(p, tr_shock_opti(i), s_opti(1), s_opti(i), inv_J) ;

% 5) Transition T_income_geo 10% s00G -> s11T_geo
i = 5 ; 
%inv_J = TRANS0_Fake_News(p, s_opti(i));
tr11T_geo_10 = TRANS1_triple(p, tr_shock_opti(i), s_opti(1), s_opti(i), inv_J) ;



%% No choc:
tr00G = TRANS1_triple(p, tr_shock(1), s(1), s(1), 1) ;




