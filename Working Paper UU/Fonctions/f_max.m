%% Trouver le max d'une matrice

function [M,i_lin,i_col] = f_max(V)
    % Maximum line index vector 
    [M1, v_lin] = max(V) ;
    % Maximum column index
    [M, i_col] = max(M1) ;
    % Maximum line index
    i_lin = v_lin(i_col) ;
end
