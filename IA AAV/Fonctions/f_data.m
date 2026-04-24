function p = f_data

%% DATA

% Order: 'Rural', 'Petite', 'Moyenne', 'Grande', 'Paris' 
% Data density by region
% p.data.share_k = [0.235, 0.260, 0.185, 0.134] ; % DT Insee
p.data.share_k = [0.134, 0.188, 0.307, 0.223] ; % IA Insee
p.data.share_k(5) = 1-sum(p.data.share_k) ;

% Calibration E/Exp and F/Exp by region
p.data.share_E = [12.2, 11.5, 9.4, 7.3, 5.7] ;
p.data.share_F = [8.1, 7.6, 5.8, 4.5, 2.9] ;
% Calibration E/Exp et F/Exp by quintile
p.data.share_E_quintile = [10.1 10.2 9.8 8.9 7.5] ;
p.data.share_F_quintile = [5.8 6.4 6.4 5.7 4.6] ;

% 5-year migration matrix by region
p.data.mat_migration = ... 
   [0.8741    0.0769    0.0333    0.0126    0.0031
    0.0979    0.8309    0.0449    0.0232    0.0030
    0.0611    0.1018    0.7940    0.0376    0.0055
    0.0406    0.0867    0.0764    0.7880    0.0083
    0.0165    0.0221    0.0178    0.0176    0.9259 ] ;

% Cross correlation quintile/geography
% p.data.mat_cross = ... % DT INSEE
%    [0.1772    0.2101    0.2230    0.2079    0.1818
%     0.2470    0.2585    0.1983    0.1492    0.1470
%     0.2561    0.2699    0.1873    0.1305    0.1562
%     0.2683    0.2867    0.1757    0.1125    0.1568
%     0.2044    0.2552    0.1679    0.1222    0.2503 ] ;

p.data.mat_cross = ... % DT IA
   [0.1532    0.1399    0.3011    0.3036    0.1020
    0.1665    0.1778    0.3007    0.2582    0.0966
    0.1615    0.2032    0.2948    0.2153    0.1249
    0.1504    0.2275    0.3116    0.2133    0.0970
    0.1083    0.2129    0.3054    0.1875    0.1858 ] ;

% Consumption ratio wrt Paris by region 
data_Insee_Ck = [ 27076,	26748, 	25699,	26962,	31772 ];
p.data.ratio_Ck = 100*data_Insee_Ck./data_Insee_Ck(5) ;
% Share of consumption
share_Ck = data_Insee_Ck.*p.data.share_k;
p.data.share_Ck = 100*share_Ck./sum(share_Ck) ;

% Revenu by region (column) and invdist 16-22-23-22-16 (row)
p.data.revenu = ...
   [6863        6927        6061        5607        6902
   14954       15028       13732       13042       15565
   19548       19994       19279       19188       23521
   23915       25011       24972       25849       32351
   38783       42709       43132       45163       65163 ] ;

% Repartition of profits by quintile
p.data.part_profit = [1.461373 2.319725 3.361836 6.044013 86.813054] ;


%% Aggregate targets
p.data.G_Y = 0.2934;  % Auray (2022)
p.data.wl_GDP = 0.65;  % Cette et al. (2019)
p.data.N_y_E_y = 0.3007 ; % PLF 2023

p.data.pF_F_GDP = .04 ; % https://www.notre-environnement.gouv.fr/themes/economie/article/l-energie#:~:text=La%20France%20dépendante%20à%2050%20%25%20d'énergies%20fossiles%20importées&text=La%20France%20importe%20la%20quasi,milliards%20d'euros%20en%202022.
p.data.GVT_GDP = .5; % PLF 2023
p.data.Housing_Weath = .66; % BdF Yann = 53% de la wealth = 5 MAIS faut enlever dette publique = 1
p.data.W_GDP = 5; % PLF 2023
p.data.share_housing_spending = 0.20 ; 
p.data.F_y_F = 75.5538723/100; % Comptes de la Nation 2022
p.data.F_h_F = 1-p.data.F_y_F; % share Fh/F

%% CO2 per worker

% Regression coeffs tCO2 per worker
coeff_E_city   = [0  -6.5919   -9.1298  -13.2037  -15.8207 ] ;
coeff_E_income = [0  -0.9966    0.7929    4.4550    8.9893  ] ;

% Shares to put back in absolute values
share_income = [0.2 0.2 0.2 0.2 0.2 ] ;
share_city   = [0.2235    0.1271    0.1289    0.3654    0.1551] ;
mean_CO2_data = 14.3023 ;

% In absolute values
CO2_income = mean_CO2_data + coeff_E_income - share_income*coeff_E_income' ;
CO2_city   = mean_CO2_data + coeff_E_city   - share_city*coeff_E_city' ;

% Firms' total CO2 by region and quintile
C02_weighted = CO2_city.*p.data.share_k ;
p.data.share_CO2_city = C02_weighted/sum(C02_weighted) ;
C02_weighted = CO2_income.*share_income ;
p.data.share_CO2_income = C02_weighted/sum(C02_weighted) ;


%% CO2 per worker UU
% Regression coeffs tCO2 per worker
% coeff_E_city   = [0  -2.58521   -3.726  -7.414  -11.39409 ] ;
%coeff_E_income = [0  -1.0532    -0.7888   1.11582   7.13742 ] ;
coeff_E_city   = [0  -4.525751   -7.62894  -10.117994  -14.22448 ] ;
coeff_E_income = [0  -0.88347    -0.59950   1.45051   7.97593 ] ;

% Shares to put back in absolute values
share_income = [0.2 0.2 0.2 0.2 0.2 ] ;
share_city   = [0.1189291    0.1863563    0.2946215    0.2250155    0.1750776] ;
mean_CO2_data = 14.11378 ;

% In absolute values
CO2_income = mean_CO2_data + coeff_E_income - share_income*coeff_E_income';
CO2_city   = mean_CO2_data + coeff_E_city   - share_city*coeff_E_city';
% CO2_city   = [21.97, 17.44, 14.34, 11.85, 7.75];

% Firms' total CO2 by region and quintile
C02_weighted = CO2_city.*p.data.share_k ;
p.data.share_CO2_city = C02_weighted/sum(C02_weighted) ;


end


