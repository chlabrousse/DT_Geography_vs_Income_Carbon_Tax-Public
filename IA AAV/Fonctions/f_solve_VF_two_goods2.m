function v = f_solve_VF_two_goods2(p, V_Vec, s)

% Prices
pC = (1+p.VAT) ; pE = (s.pe_h).*pC ; pH = s.pH_h ;
% (1-sigma)*epsilon_i
sig = (1-p.sigma) ;
sC = sig*p.epsilon_C ; sE = sig*p.epsilon_E ; sH = sig*p.epsilon_H ; 
% Lambda*p_i^(1-sigma)
lC = p.Lambda_C*pC^sig ; lE = p.Lambda_E*pE.^sig ; lH = p.Lambda_H*pH.^sig ;


%% Bellman

% Algo
Umin = 1e-5*ones(p.n,1) ; 
tol = sqrt(eps) ;
alpha1 = (3-sqrt(5))/2;
alpha2 = 1-alpha1;
z_futur = p.s(:,2) ;

% Bellman for each k
Ve_coeff = reshape(V_Vec, p.dim);
for k = 1:p.nk
    V{k} = griddedInterpolant({p.bgrid,p.zgrid},Ve_coeff(:,:,k),'spline');
end


%% Guess initial
d  = [1,1,1,1,1].*(p.Umax - Umin);
x1 = [1,1,1,1,1].*(Umin + alpha1*d);
x2 = [1,1,1,1,1].*(Umin + alpha2*d);
q  = ones(size(x1));
% Lower and upper bounds
[f1,~,~] = calcul(x1) ;
[f2,~,~] = calcul(x2) ;

%% Golden
d = alpha1*alpha2*d;
while any(d>tol)
    i = f2>f1;
    x1(i) = x2(i);
    f1(i) = f2(i);
    d = d*alpha2;
    x2 = x1 + q.*(i-(~i)).*d;
    q = sign(x2-x1);
    % Function
    [f2,E,ap] = calcul(x2); 
end
% Return the larger of the two
i = f2>f1; x1(i) = x2(i);  f1(i) = f2(i);
% Save
v.k.U = x1 ;
v.k.V = f1 ;
Exp = E ; 
v.k.ap = ap ; 


%% Compute optimal policies

% Policies for each choice
v.k.c  = p.Lambda_C*(pC./Exp).^(-p.sigma).*v.k.U.^sC ;
v.k.eh = p.Lambda_E*(pE./Exp).^(-p.sigma).*v.k.U.^sE + p.ebar ;
v.k.H  = p.Lambda_H*(pH./Exp).^(-p.sigma).*v.k.U.^sH ;
v.k.Exp = Exp + pE.*p.ebar ;

% Probability of choosing knext
x = v.k.V/p.gumb ;
for knext = 1:p.nk
    v.H(:,knext) = 1./sum( exp( x-x(:,knext) ) , 2) ;
end 

% New Bellman
v.V = p.gumb*( x(:,1) + log( sum( exp( x-x(:,1) ),2 ) ) ) ;
v.Ve = p.Emat*v.V;

% Other values
v.k.Nh = v.k.eh.*(p.m2).^(-p.eh./(p.eh-1) ) ;
v.k.Fh = p.m1.*v.k.Nh ;
v.k.u  = log(v.k.U)  ;
v.NLI = s.NLI ; v.taxL = s.TaxL ;
% v.test_Comin =  p.Lambda_C.^(1/p.sigma).*( v.k.c./(v.k.U.^p.epsilon_c ) ).^((p.sigma-1)/p.sigma) ...
%     + p.Lambda_E.^(1/p.sigma).*( (v.k.eh-p.ebar)./(v.k.U.^p.epsilon_e) ).^((p.sigma-1)/p.sigma)  ...
%     + p.Lambda_H.^(1/p.sigma).*( (v.k.H)./(v.k.U.^p.epsilon_h) ).^((p.sigma-1)/p.sigma) ; 

    function [f,E,fap] = calcul(x)
        U = x ;
        E = ( lC.*U.^sC + lE.*U.^sE + lH.*U.^sH ).^( 1/sig )  ; 
        fap  = s.RHS - E ;
        EV  = [V{1}(fap(:,1),z_futur),V{2}(fap(:,2),z_futur), V{3}(fap(:,3),z_futur) , V{4}(fap(:,4),z_futur) , V{5}(fap(:,5),z_futur) ] ;
        f    = log(U)  + p.beta*EV; 
    end

end
