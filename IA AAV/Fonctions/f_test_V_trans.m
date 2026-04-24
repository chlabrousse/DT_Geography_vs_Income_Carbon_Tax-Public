function U_k = f_test_V_trans(k, tr, p, h)

% Start at point k on the grid
P_k = zeros(p.n,p.T-1) ; P_k(k,1) = 1 ;
% Utility first period
U_k(1) = P_k(:,1)'*sum(tr.V(1).k.u.*tr.V(1).H,2) ;
% Expected utility on the following periods
for t=2:h
    P_k(:,t) = tr.mat(t-1).mat*P_k(:,t-1) ;
    U_k(t) = P_k(:,t)'*sum(tr.V(t).k.u.*tr.V(t).H,2) ;
end

end