function m = f_quantile_new2(p, n_quantile, density, s, varargin)

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
x.RHS = sum(s.RHS.*V.H,2) ; 
x.Profit = s.v_profit ;
x.NFI = (1-p.tax_capital).*s.R.*x.b + s.v_profit ;
x.NLI = s.NLI ;
x.TI  = x.NLI + x.NFI + x.T ;
x.LT = s.TaxL ;
if ~isempty(varargin) % S'il y a d'autres variables
    L = fieldnames(varargin{1}) ;
    for i = 1:length(L) ; x.(L{i}) = varargin{1}.(L{i}) ; end
end

% Creation de la liste
nom = fieldnames(x) ;  
for i = 1:length(nom) ; liste(:,i) = x.(nom{i}) ; end

% Creer quintile revenu
M  = [density, liste] ; 
ligne_TI = find(strcmp(nom, 'TI'));
%ligne_TI = find(strcmp(nom, 'NLI'));
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
        m.quintile.share(iq) = sum(d1) ;
        m.quintile.(var)(iq) = d1'*M1/m.quintile.share(iq) ;
    end
    % TYPE
    ligne_k = find(strcmp(nom, 'k'));
    for ik = 1:p.nk   
        I1 = (M(:,1+ligne_k) == ik) ;
        M1 = M(I1,n+1) ; d1 = M(I1,1) ;
        m.type.share(ik) = sum(d1) ;
        m.type.(var)(ik) = d1'*M1/m.type.share(ik) ;
    end
    % TYPE * QUINTILE
    for ik = 1:p.nk   
        for iq = 1:n_quantile   
            I1 = (indice_quintile == iq) ;
            I2 = (M(:,1+ligne_k) == ik) ;
            I3 = logical(I1.*I2) ;
            M1 = M(I3,n+1) ; d1 = M(I3,1) ;
            m.cross.share(iq,ik) = sum(d1) ;
            m.cross.(var)(iq,ik) = d1'*M1/m.cross.share(iq,ik) ;
        end
    end 
end


end