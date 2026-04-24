function p = f_parameters_geo

%% Data
p = f_data ;

%% Parameters Algorithm
[p.nk,nk] = deal(5) ;   % city grid points
[p.nb,nb] = deal(100) ; % asset grid points
[p.nz,nz] = deal(5) ;   % productivity grid points
p.dim     = [nb,nz,nk]; % dimension of the state space
p.n       = nz*nb*nk ;  % total grid points
p.T       = 100;        % duration transition
p.tolV    = 1e-8;       % tolerance for the VFI
p.tolconv = 1e-4;       % tolerance for the SS
liste1 = ["rk" , "N", "CTR"] ;
liste2 = ["Y1", "Y2", "Y3", "Y4", "Y5"] ;
liste3 = ["p1", "p2", "p3", "p4", "p5"] ;
p.list_var = [liste1, liste2, liste3] ;

addpath('Save')  
load("guess_calibration.mat")
calib = guess;

%% Parameters Households
p.region = {'Rural', 'Small', 'Medium', 'Large', 'Paris' } ;
p.beta  = 0.94;  % discount factor 
p.sigma = 0.2 ;  % ES btw energy and other goods
p.gumb  = 0.1 ;  % variance gumble shock
p.Lambda_E = calib.Lambda_E ; % share energy
p.Lambda_H = 1.464322529681014 ; % share housing 
p.Lambda_C = 1 ;                 % share C
p.epsilon_C = 1;       % ES of C in Comin utility 
p.epsilon_E = 0.9 ;    % ES ofE in Comin utility
p.epsilon_H = 0.25 ;   % ES of H in Comin utility
p.epsilon_h = 1.5 ;    % ES between N and F
p.lS = 1/3 ;           % Labor supply
ebar_grid = [calib.ebar1, calib.ebar2, calib.ebar3, calib.ebar4,  0] ; % energy requirement by city
p.ebar     = kron(ebar_grid(:),ones(p.nb*p.nz,1)) ;  % grid energy requirement by city
gamma_grid = [calib.gamma1, calib.gamma2, calib.gamma3, calib.gamma4, calib.gamma5] ; % share of F by city
p.gamma_h = kron(gamma_grid(:),ones(p.nb*p.nz,1)) ;  % grid share of F by city


%% Set parameters firms
p.delta = 0.1180  ;           % depreciation rate
p.p_F   = 0.677317643215423 ; % relative price of fossil fuel energy    

% G&S sector
p.a       = 1 ; % Return to scale
p.alpha   = 0.308862582443010 ;  % share K in KL bundle    
p.sigma_y = 0.05 ;   % elasticity KL/E
p.epsilon_y = 1.5 ;  % elasticity F/N
p.gamma_y = 0.858736928888308 ; % share of fossil
p.omega_y = [0.094644544571692, 0.070119894012018, 0.050430141929510, 0.039232596414492,  0.022347602331943]'; % share of energy by city

% Electricity sector
p.zeta = 0.9813; % share K in N sector

% Housing supply
H_SS = [calib.H1, calib.H2, calib.H3, calib.H4, calib.H5]' ;
p_SS = [calib.p1, calib.p2, calib.p3, calib.p4, calib.p5]' ;
p.delta_F = 0.2 ; % housing supply elasticity
p.H_k = H_SS./(p_SS.^p.delta_F) ;


%% Government
p.Transfer_init = 0.08 ;  % public transfers 
p.tax_capital   = 0.0902; % effective corporate tax rate: Auray et al. (2022)
p.VAT           = 0.2234; % effective VAT rate: Auray et al. (2022)
p.public_debt   = 0;      % public debt
p.tau           = 0.08 ;  % progressivity
p.lambda        = 0.570666660895036 ;   % tax rate parameter


%% Grids

% Grids for B
p.bmin    = 0; 
p.bmax    = 40;
p.bgrid   = p.bmin + (p.bmax-p.bmin)*linspace(0,1,nb).^2.5;
p.bgrid   = p.bgrid(:);

% Tauchen grid for Z
mu_z       = 0;      % mean AR(1) process (0 chez Axelle)
sigma_z    = 0.3 ;   % variance
rho_z      = 0.97 ;  % persistence of the shock (0.939 chez Axelle)
m_z        = 1;      % Pas de la grid : Z(N) = m*sigma/sqrt(1-rho^2) + meanZ
[logZ,p.P] = f_tauchen(nz, mu_z, rho_z, sigma_z, m_z); 
p.zgrid = exp(logZ) ;
invdist_tempo = ones(1,p.nz)./p.nz;    
p.invdist = invdist_tempo*p.P^200;

% create Expectation matrix (lot of diagonal matrixes)
A = kron(p.P, eye(nb));
B = sparse(A) ;
p.Emat = kron(eye(p.nk), B) ;

% Productivity vector
% z1(:,1) = [0.25 0.85 0.8 0.9 0.8] ;
% z1(:,2) = [0.35 0.85 0.85 0.9 0.82] ;
% z1(:,3) = [1.15 1 1 1 0.92] ;
% z1(:,4) = [1.3 1.15 1 1 .95] ;
% z1(:,5) = [1.35 1 .95 .95 1.45] ;
% z1(:,1) = [0.4  0.85  0.8   0.9   0.8] ;
% z1(:,2) = [0.5  0.85  0.85  0.9   0.82] ;
% z1(:,3) = [1.15 1     1     1     0.92] ;
% z1(:,4) = [1.2  1.15  1     1     0.95] ;
% z1(:,5) = [1.3  1.2   1.2   1.2   1.35] ;
z1(:,1) = [0.4 0.85 0.8 0.9 0.8] ;
z1(:,2) = [0.5 0.85 0.85 0.9 0.82] ;
z1(:,3) = [1.15 1 1 1 0.92] ;
z1(:,4) = [1.2 1.15 1 1 .95] ;
z1(:,5) = [1.3 1 .95 .95 1.35] ;
% Rescale
z2 = z1/(p.invdist*z1*p.data.share_k') ; % scale assuming homogenous repartition
p.z_type = kron(z2(:),ones(nb,1)) ;


%% State space
% Assets move first
p.s(:,1) = repmat(p.bgrid , nz*nk,1) ;
% Z move second
p.s(:,2) = repmat(kron(p.zgrid,ones(nb,1)) , nk, 1) ;
% Types move third
p.s(:,3) = kron((1:nk)',ones(nb*nz,1)) ;


%% Mesure

% Column index
c1 = (1:p.n)' ;
p.i_col = repmat(c1, 1, nk*nz*2) ;
% Row index
k1 = (0:(nk-1))*(nb*nz) ;
k2 = repmat(k1,1,nz*2) ;
% Index line of z
z1 = (0:(nz-1))*(nb) ;
z2 = kron(z1,ones(1,nk )) ;
z3 = repmat(z2,1,2) ;
% Index line k and z
p.ligne_kz = k2+z3 ;
% Index weight of z
P2 = kron(p.P, ones(nb,1)) ;
P3 = repmat(P2,nk,1) ;
P4 = kron(P3,ones(1,nk)) ;
p.poids_z = repmat(P4,1,2) ;

% Migration cost
p.cost_matrix(1,:) = [0       0.18    0.35     0.5     1.4]; 
p.cost_matrix(2,:) = [0.19    0       0.32     0.45    1.3]; 
p.cost_matrix(3,:) = [0.12    0.06    0        0.3     1.2]; 
p.cost_matrix(4,:) = [0.06    0.01    0.035    0       1.05]; 
p.cost_matrix(5,:) = [0.05     0.05     0.05      0.1     0]; 
p.migracost = p.cost_matrix(p.s(:,3),1:p.nk) ;


%% Policy instruments

% Transfer vector
p.vecT.G = zeros(p.n,1) ; % if CTR in G
p.vecT.T = ones(p.n,1) ;  % if CTR uniformly distributed
T1 = [4 3 2 1 0] ;
T2 = T1/sum(T1) ;
T3 = T2./p.data.share_k ;
p.vecT.T_geo = kron(T3',ones(nb*nz,1)) ;  % if CTR distributed according to geography

% Guess initial density
pz = repmat(kron(p.invdist',ones(nb,1)) , nk, 1) ;
pk = kron(p.data.share_k',ones(nb*nz,1)) ;
pb = repmat( 1./(1:1:nb)' , nz*nk, 1) ;
p.vec_d = pz.*pk.*pb/sum(pz.*pk.*pb) ;

% Profit rule
A = repmat( kron(p.invdist',ones(p.nb,1)) , 5,1)  ;
B = A.*p.s(:,2).^3.5 ;
p.grid_profit = B/(sum(B) )*p.n ;


%% Steady state shocks

p.data.ratio_PLF = 60.9/183.5  ; 
tau_h_debut = 0.662536425607164 ;
tau_f_debut = tau_h_debut*p.data.ratio_PLF ;
tau_h_final = 1.208341526103828 ;
tau_f_final = 0.695583820454266;

% 1) 0-0-G
p.s_shock(1).tau_h = tau_h_debut ;
p.s_shock(1).tau_f = tau_f_debut ;
p.s_shock(1).vec_T = p.vecT.G ; 

% 2) 1-0-G 
p.s_shock(2).tau_h = tau_h_final ;
p.s_shock(2).tau_f = tau_f_debut ;
p.s_shock(2).vec_T = p.vecT.G ;

% 3) 0-1-G 
p.s_shock(3).tau_h = tau_h_debut ;
p.s_shock(3).tau_f = tau_f_final ;
p.s_shock(3).vec_T = p.vecT.G ;

% 4) 1-1-G 
test = 0.223124778317260;
p.s_shock(4).tau_h = tau_h_debut + test ;
p.s_shock(4).tau_f = tau_f_debut + test ;
p.s_shock(4).vec_T = p.vecT.G ;


end


