function fig_energy_mix3(p, s)

% Créer les quintiles
d = s.density.tot ; 
a = f_quantile_new2(p, 5, d, s) ;

% colors    
green = [0.4660 0.6740 0.1880];    
red = [0.8500 0.3250 0.0980];

figure;
set(gcf,'units','centimeters') ; 
set(gcf,'Position',[5 5 50 30]) ;
subplot(121)
ba = bar([a.type.expF;a.type.expN]','stacked', 'EdgeColor', 'none', 'BarWidth', 0.8,  'FaceColor', 'flat'); 
ba(1).CData = red; ba(2).CData = green;
hold on ; dataPlot = plot([p.data.share_E;p.data.share_F]','oblack', 'MarkerFaceColor','black','MarkerSize',10) ;
labels = p.region ;
xtickangle(45); % Rotation des etiquettes 
title('a. By geographical location', 'interpreter','latex')  ;
axes

subplot(122)
ba = bar([a.quintile.expF;a.quintile.expN]','stacked', 'EdgeColor', 'none', 'BarWidth', 0.8,  'FaceColor', 'flat');
ba(1).CData = red; ba(2).CData = green;
hold on ; dataPlot = plot([p.data.share_E_quintile;p.data.share_F_quintile]','oblack', 'MarkerFaceColor','black','MarkerSize',10) ;
labels = {'Q1', 'Q2', 'Q3', 'Q4', 'Q5'};
xtickangle(0); % Rotation des etiquettes 
title('b. By income quintile', 'interpreter','latex')  ;
axes

% Axes
function axes
    xticks(1:numel(labels));
    xticklabels(labels);  
    f=30;
    ax1 = gca; ax1.FontSize = f; ax1.XColor = 'black'; ax1.YColor = 'black';
    ax1.TickLength = [0 0]; % Enleve les tirets noirs de l'axe des abscisses
    ax1.Box = 'off'; % Enleve l'encadrement noir
    legend([ba(1), ba(2), dataPlot(1)], {'Fossil (model)', 'Electricity (model)', 'Data'}, 'Interpreter', 'latex', 'Box', 'off', 'FontSize', f);
    ylabel('\%', 'interpreter', 'latex', 'FontSize', f, 'Color', 'black');
    ylim([0,14]) ; yticks(0:2:14);
    set(gcf, 'color', 'w'); 
    set(ax1, 'XTickLabel', labels, 'TickLabelInterpreter', 'latex'); 
end


end
