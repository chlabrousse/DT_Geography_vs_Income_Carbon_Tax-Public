function inv_mat_jaco = TRANS0_Fake_News(p, SS)

% On fait une période en plus sur la backward, car les
% chocs en t influencent t+1 via R_next
% Init
T = p.T ; chocX = 0.001 ; tic 
Erreur_init = 0 ;
d_trans(:,1)   = SS.density.tot  ;
tr_init.B_h(1) = SS.B_h ;  
tr_init.Ve(:,T+1) = SS.V.Ve ;  
for var = p.list_var
    tr_init.(var)(1:T) = SS.(var) ;
end
% Carbon taxes and transfer rule
tr_init.tau_h(1:T) = SS.tau_h ;
tr_init.tau_f(1:T) = SS.tau_f ;
tr_init.vec_T = SS.vec_T ;


%% Jacobian of the last period
for i_var = 1:length(p.list_var)
    var = p.list_var(i_var) ;
    m{i_var} = f_run(tr_init, var, p, chocX, SS, d_trans) ;
end


%% Creation of the complete matrix
mat_jaco = [] ;
for i_var = 1:length(p.list_var) ; mat_jaco = [mat_jaco , m{i_var}] ; end

tic
inv_mat_jaco = inv(mat_jaco) ;
disp(['Calcul de la Jacobienne : ' num2str(toc,2) ' secondes']) 
toc

if 1 == 0
    var = p.list_var(1) ; ss = T/2 ; nvar = length(p.list_var) ;
    A = reshape(mat_derivees.(var)(:,ss),T-1,nvar) ;
    % plot(A(:,1:12))
    list_title = ["A","N","L1","L2","L3","L4"] ;
    figure ; sgtitle(["Choc sur" ; var],'FontSize',20)
    for x = 1:6
        subplot(3,2,x) ; plot(A(:,x), 'linewidth',3) ; 
        title(list_title(x),'FontSize',20) ; yline(0) ;
    end
end

end
