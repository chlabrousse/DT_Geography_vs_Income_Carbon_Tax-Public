%% Create initial V based on simple C policy

function s = SS_V_guess(p, choc) 
   
load('save_guess.mat', 'guess');
s = guess;

% Fixed values
s.tau_h = choc.tau_h ;
s.tau_f = choc.tau_f ;
s.vec_T = choc.vec_T ;
s.p_F = p.p_F;
% Guess initial densité
s.density.tot = p.vec_d ; % Guess initial de densité
s.tau = 0.1;

for var = p.list_var ; s.guess.(var) = s.(var) ; end

% Bellman
C_guess = s.rk*p.s(:,1) + 1+ p.s(:,2) ;
if isfield(p, 'Ve_guess')
    s.Ve_guess = p.Ve_guess ;
else
    s.Ve_guess = log(C_guess)/(1-p.beta) ;
end

% Algo
s.diff = 10 ; s.it = 0;

tic


end