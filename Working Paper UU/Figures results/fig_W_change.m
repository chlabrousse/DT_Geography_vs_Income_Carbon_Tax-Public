function fig_W_change(p, s, tr)

% Créer les quintiles
V_SS = s.V.V ;
V_trans = tr.V(1).V ;
ss.CE = f_welfare_WE_target(p, s, V_SS, V_trans) ;
d = s.density.tot ; 
a = f_quantile_new2(p, 5, d, s, ss) ;
CE_type   = a.type.CE ;
CE_income = a.quintile.CE ;


%% Graphe welfare quintile vs living area
green = [0.4660 0.6740 0.1880];

figure ;
set(gcf, 'color', 'w');
set(gcf,'units','centimeters') ; 
set(gcf,'Position',[5 5 50 20]) ;

subplot(121) ; 
bar(CE_type,'FaceColor', green, 'EdgeColor', 'none', 'BarWidth', 0.8);  
labels = p.region ;
xtickangle(45); xticks(1:numel(labels)); xticklabels(labels);    
ax2 = gca; title('a. By geographical location', 'interpreter','latex')  ;
axes

subplot(122) ; 
bar(CE_income,'FaceColor', green, 'EdgeColor', 'none', 'BarWidth', 0.8);  
labels = {'Q1', 'Q2', 'Q3', 'Q4', 'Q5'};
xtickangle(0); xticks(1:numel(labels)); xticklabels(labels);    
ax2 = gca; title('b. By disposable income', 'interpreter','latex')  ;
axes


% Axes
function axes
    ylabel('WE (\%)', 'interpreter','latex', 'FontSize', 30, 'Color', 'black');
    %ylim([-4 -1]);  yticks(-4:1:-1);
    set(ax2, 'Box', 'off', 'TickLength', [0 0], 'XColor', 'black', 'YColor', 'black', ...
    'FontSize', 30, 'XTickLabel', labels, 'TickLabelInterpreter', 'latex');
end

end

    
