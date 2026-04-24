%% 0 ) Initialization and parameters
clear variables
addpath('Fonctions','Steady state','Transition','Save')    
p = f_parameters_geo ;

% Charge Jacobian and Vguess
A = load('save_jacinv.mat') ; p.jacinv = A.jacinv ;
A = load('save_Ve_guess.mat') ; p.Ve_guess = A.Ve_guess ;

%% s: One tax with G
% 1) 0-0-G 
s(1) = SS_conv(p, p.s_shock(1) );  
% 2) 0-1-G 
s(2) = SS_conv(p, p.s_shock(2) ); % s(2).F/s(1).F
% 3) 1-0-G 
s(3) = SS_conv(p, p.s_shock(3) ); % s(3).F/s(1).F
% 4) 1-1-G
s(4) = SS_conv(p, p.s_shock(4) ); % s(4).F/s(1).F


%% s_opti: Optimal to reduce by 10%, starting from 00

% 1) 0-0-G, initial
[A.tau_h,A.tau_f]=deal(0) ; A.vec_T = p.vecT.G ;
s_opti(1) = SS_conv(p, A ); 
% 2) 1-1-G
[A.tau_h,A.tau_f]=deal(0.155254737062905) ; A.vec_T = p.vecT.G ;
s_opti(2) = SS_conv(p, A ); % s_opti(2).F/s_opti(1).F
% 3) 1-1-T_uni
[A.tau_h,A.tau_f]=deal(0.165184056728116) ; A.vec_T = p.vecT.T ;
s_opti(3) = SS_conv(p, A ); % s_opti(3).F/s_opti(1).F
% 4) 1-1-T_inc
[A.tau_h,A.tau_f]=deal(0.177187192132417) ; 
A.vec_T = load("vec_T_inc.mat").vec_T_inc ;
s_opti(4) = SS_conv(p, A ); % s_opti(4).F/s_opti(1).F
% 5) 1-1-T_geo
[A.tau_h,A.tau_f]=deal(0.174451167871978) ; 
A.vec_T = load("vec_T_geo.mat").vec_T_geo ;
s_opti(5) = SS_conv(p, A ); % s_opti(5).F/s_opti(1).F









