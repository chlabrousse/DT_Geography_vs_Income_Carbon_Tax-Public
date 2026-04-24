%% 0 ) Initialization and parameters
clear variables
addpath('Fonctions','Steady state','Transition','Save','Figures calibration')    
p = f_parameters_geo ;

% Charge Jacobian and Vguess
% A = load('save_jacinv.mat') ; p.jacinv = A.jacinv ;
% A = load('save_Ve_guess.mat') ; p.Ve_guess = A.Ve_guess ;

%% s: One tax with G
s(1) = SS_conv(p, p.s_shock(1));  

%% 1) Plot migration matrix, model and data
fig_mat_migration(p, s(1))

%% 2) Energy mix by geography and income
fig_energy_mix3(p, s(1))

%% 3) Plot cross density Geography x Income
fig_cross_densite2(p, s(1))
%fig_cross_densite_diff(p, s(1))

%% 4) Calibration income inequality
fig_calib_heterogeneity(p, s(1))

%% 5) Untargeted fiscal calibration
fig_fiscal_calib2(p, s(1))