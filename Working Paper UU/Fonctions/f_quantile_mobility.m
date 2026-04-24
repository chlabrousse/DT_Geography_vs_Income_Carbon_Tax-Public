function m = f_quantile_mobility(p, n_quantile, density, H, s)

size_quantile     = 1/n_quantile ;
liste_quantile    = size_quantile:size_quantile:1 ;
quart_vec = [0.25,0.50,0.75] ;
%quart_vec = [0.,0.50,0.90] ;
%quart_vec = liste_quantile ;

% Other variables
x.b = p.s(:,1); 

% x.z = p.s(:,2); x.k = p.s(:,3) ; 
% x.T  = s.Transfer_type;
% x.NFI = (1-p.tax_capital).*s.R.*x.b ;
% x.NLI = s.NLI ;
% x.TI  = x.NLI + x.NFI + x.T ;
% x.b = x.TI; 

x.k_before = p.s(:,3);

% Creer quintile revenu
M  = [density,x.b, H,x.k_before] ;  
M  = sortrows(M,2); 
a = cumsum(M(:,1)) <= liste_quantile ;
indice_quintile = n_quantile - sum(a,2)+1 ;

% Proba de chager de ville par quintile de wealth (b) dans chaque ville (k)
    for ik = 1:p.nk   
        for iq = 1:n_quantile   
            I1 = (indice_quintile == iq) ;
            I2 = (M(:,end) == ik) ;
            I3 = logical(I1.*I2) ;
            M1 = M(I3,2+ik) ; d1 = M(I3,1) ;
            m.share(iq,ik) = sum(d1) ;
            m.proba_stay(iq,ik) = d1'*M1/m.share(iq,ik) ;
        end
    end 


end