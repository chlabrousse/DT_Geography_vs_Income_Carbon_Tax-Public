function fig_W_moustache_new(p, s, tr)

% Créer le WE 
V_SS = s.V.V ;
V_trans = tr.V(1).V ;
WE = f_welfare_WE_target(p, s, V_SS, V_trans) ;
d = s.density.tot ; 
% Calculer les quantiles par region
WE_reshape = reshape(WE,p.nb*p.nz,p.nk) ;
d_reshape = reshape(d,p.nb*p.nz,p.nk) ;
d_reshape = d_reshape./s.density.k ;
for ik=1:p.nk
    % Sort the WE of the region
    X = sortrows([WE_reshape(:,ik),d_reshape(:,ik)],1) ; 
    % Find the index of quintile and the value of WE for this index
    iM = find(cumsum(X(:,2))>=0.25,1) ; 
    type.q25(1,ik) = X(iM,1) ;
    iM = find(cumsum(X(:,2))>=0.50,1) ; 
    type.q50(1,ik) = X(iM,1) ;
    iM = find(cumsum(X(:,2))>=0.75,1) ; 
    type.q75(1,ik) = X(iM,1) ;
end
% Calculer les quantiles par Income
TI = s.NLI + (1-p.tax_capital).*s.R.*p.s(:,1) + s.Transfer_type ;
X = [WE,d,TI] ;
X = sortrows(X,3) ; 
a = cumsum(X(:,2)) <= [0.2,0.4,0.6,0.8,1] ;
indice_quintile = 5 - sum(a,2)+1 ;
for iq=1:5
    % Restrict to the quantile and rescale density
    Xq = X(indice_quintile==iq,:) ;
    Xq(:,2) = Xq(:,2)/sum(Xq(:,2)) ;
    % Sort the WE of the quintile
    Xq = sortrows(Xq,1) ; 
    iM = find(cumsum(Xq(:,2))>=0.25,1) ; 
    quant.q25(1,iq) = Xq(iM,1) ;
    iM = find(cumsum(Xq(:,2))>=0.50,1) ; 
    quant.q50(1,iq) = Xq(iM,1) ;
    iM = find(cumsum(Xq(:,2))>=0.75,1) ; 
    quant.q75(1,iq) = Xq(iM,1) ;
end
disp(num2str(quant.q50,3))

% Bounds
A = quant ; B1 = [A.q25;A.q50;A.q75] ;
A = type  ; B2 = [A.q25;A.q50;A.q75] ;
low_bound = min([B1,B2] , [], 'all') ;
top_bound = max([B1,B2] , [], 'all') ;
low_bound = floor(low_bound) ;
top_bound = ceil(top_bound) ;


%%

figure ;
set(gcf, 'color', 'w');
set(gcf,'units','centimeters') ; 
set(gcf,'Position',[5 5 50 30]) ;

subplot(121) ; 
A = type ; B = [A.q25;A.q50;A.q75] ;
plot(B(2,:), 'ko', 'MarkerFaceColor', 'r', 'MarkerSize', 8);
hold on ; plot([1:5; 1:5], B([1,3],:), 'k-', 'LineWidth', 1.5); hold off
hold on ; plot([1:5; 1:5]+0.1*[-1;1], [B(1,:);B(1,:)], 'k-', 'LineWidth', 2);
hold on ; plot([1:5; 1:5]+0.1*[-1;1], [B(3,:);B(3,:)], 'k-', 'LineWidth', 2);
%legend('Quartile 1','Median','Quartile 3', 'interpreter','latex')
labels = p.region ;
xtickangle(45); xticks(1:numel(labels)); xticklabels(labels);    
ax2 = gca; title('a. By geographical location', 'interpreter','latex')  ;
axes

subplot(122) ; 
A = quant ; B = [A.q25;A.q50;A.q75] ;
plot(B(2,:), 'ko', 'MarkerFaceColor', 'r', 'MarkerSize', 8);
hold on ; plot([1:5; 1:5], B([1,3],:), 'k-', 'LineWidth', 1.5); hold off
hold on ; plot([1:5; 1:5]+0.1*[-1;1], [B(1,:);B(1,:)], 'k-', 'LineWidth', 2);
hold on ; plot([1:5; 1:5]+0.1*[-1;1], [B(3,:);B(3,:)], 'k-', 'LineWidth', 2);
labels = {'Q1', 'Q2', 'Q3', 'Q4', 'Q5'};
xtickangle(0); xticks(1:numel(labels)); xticklabels(labels);    
ax2 = gca; title('b. By disposable income', 'interpreter','latex')  ;
axes

% Axes
function axes
    ylabel('WE (\%)', 'interpreter','latex', 'FontSize', 30, 'Color', 'black');
    %bound = [-34 -16] ; pas = 3 ;
    %ylim(bound); yticks(min(bound):pas:max(bound));
    ylim([low_bound top_bound] );
    set(ax2, 'Box', 'off', 'TickLength', [0 0], 'XColor', 'black', 'YColor', 'black', ...
    'FontSize', 30, 'XTickLabel', labels, 'TickLabelInterpreter', 'latex');
end

end

    
