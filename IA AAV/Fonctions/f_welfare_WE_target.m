function W_CE = f_welfare_WE_target(p, s, V_SS, V_trans)

% Create initial value function
V_coeff = reshape(V_SS, p.dim);
for k=1:5
    V{k} = griddedInterpolant({p.bgrid,p.zgrid},V_coeff(:,:,k),'spline');
end

% Value function for transition 
V_target = reshape(V_trans, 500,5) ;
A        = reshape(p.s(:,1) , 500,5);
Z        = reshape(p.s(:,2) , 500,5);

% WE : V_initial + WE = V_transition
for k=1:5
    eq = @(x) V{k}(A(:,k)+x,Z(:,k)) - V_target(:,k) ;
    options = optimset('Display','off');
    [X(:,k),diff(:,k)] = fsolve(eq,0*A(:,k),options) ;
end
disp(max(abs(diff))) % plot(diff)


%% Rescale

% by Expenditures
%scale = 100./sum(s.V.k.Exp.*s.V.H,2) ; 
% in euros
%scale = 1/s.GDP*30000 ;    
% sans scale
%scale = 1 ;                
% by NLI
%scale = 100./s.V.NLI ;  
% by TI
NFI = (1-p.tax_capital).*s.R.*p.s(:,1) + s.v_profit ;
scale = 100./(s.NLI + NFI + s.Transfer_type) ; 
% Rescale
W_CE = X(:).*scale ;



end

