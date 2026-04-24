%% 0 ) Initialization and parameters
clear variables
addpath('Fonctions','Steady state','Transition','Figures calibration','Figures results','Save')    
p = f_parameters_geo ;

%% 1) Load Steady states (code: MAIN_SS)

load('s.mat', 's');
% s(1) 0 - 0 - G 
% s(2) 1 - 0 - G 
% s(3) 0 - 1 - G 
load('s_opti.mat', 's_opti');
% s_opti(1) 0-0-G
% s_opti(2) 10% 1-1-G
% s_opti(3) 10% 1-1-T_uni
% s_opti(4) 10% 1-1-T_inc
% s_opti(5) 10% 1-1-T_geo


%% 2) Load Transitions (code: MAIN_TRANS)

% 2) Transition s00G -> s10G
tr10G = load('tr10G').tr10G ; 

% 3) Transition s00G -> s01G
tr01G = load('tr01G').tr01G ; 

% 4) Transition G 10% s00G -> s11G
tr11G= load('tr11G').tr11G; 

% 5) Transition T_uni 10% s00G -> s11T_uni
tr11T_uni_10 = load('tr11T_uni_10').tr11T_uni_10 ; 

% 6) Transition T_income 10% s00G -> s11T_inc
% tr11T_inc_10 = load('tr11T_inc_10').tr11T_inc_10 ; 

% 7) Transition T_income_geo 10% s00G -> s11T_geo
tr11T_geo_10 = load('tr11T_geo_10').tr11T_geo_10 ; 




