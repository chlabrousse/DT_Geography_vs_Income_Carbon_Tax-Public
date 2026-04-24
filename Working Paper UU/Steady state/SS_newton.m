function s = SS_newton(p, s)

% If we already have a matrix in memory, no run
if isfield(p, 'jacinv')
    s.jacinv = p.jacinv ; 
else
% If we don't have a matrix, we run
    choc = 0.0001 ; 
    parfor i_var = 1:length(p.list_var)
        var = p.list_var(i_var) ;
        m{i_var} = run_newton(var, p, s, choc) ;
    end
    mat_jaco = [] ;
    for i_var = 1:length(p.list_var) ; mat_jaco = [mat_jaco , m{i_var}] ; end
    s.jacinv = inv(mat_jaco) ;
end

end

