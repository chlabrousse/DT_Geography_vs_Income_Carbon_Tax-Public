function m = f_quantile_type(p, n_quantile, density, s)

size_quantile     = 1/n_quantile ;
liste_quantile    = size_quantile:size_quantile:1 ;

% Variables in V.k
V = s.V ;
L = fieldnames(V.k) ;
for i = 1:length(L)
    x.(L{i}) = sum(V.k.(L{i}).*V.H,2) ; 
end
% Other variables
x.b = p.s(:,1); x.z = p.s(:,2); x.k = p.s(:,3) ; 
x.T  = s.Transfer_type;
x.NFI = (1-p.tax_capital).*s.R.*x.b + s.v_profit ;
x.NLI = s.NLI ;
x.TI  = x.NLI + x.NFI + x.T ;
x.LT = s.TaxL ;
% Creation de la liste
nom = fieldnames(x) ;  
for i = 1:length(nom) ; liste(:,i) = x.(nom{i}) ; end

% Creer quintile revenu
MM  = [density, liste] ;

for ik = 1:p.nk
    nbz = p.nb*p.nz ;
    index_ligne = ((ik-1)*nbz+1):(ik*nbz) ;
    M = MM(index_ligne,:) ; % garder seulement le type
    M(:,1) = M(:,1)/sum(M(:,1)) ; % rescale density
    %ligne_TI = find(strcmp(nom, 'TI'));
    ligne_TI = find(strcmp(nom, 'NLI'));
    M  = sortrows(M,ligne_TI+1); 
    a = cumsum(M(:,1)) <= liste_quantile ;
    indice_quintile = n_quantile - sum(a,2)+1 ;
    
    % Pour chaque variable
    for n = 1:length(nom)
        var = nom{n} ;
        % QUINTILE
        for iq = 1:n_quantile   
            I1 = (indice_quintile == iq) ;
            M1 = M(I1,n+1) ; d1 = M(I1,1) ;
            m.share(iq,ik) = sum(d1) ;
            m.(var)(iq,ik) = d1'*M1/m.share(iq,ik) ;
        end
    end
   
end


end