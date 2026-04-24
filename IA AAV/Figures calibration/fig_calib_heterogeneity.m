function fig_calib_heterogeneity(p, s)

 % Créer les quintiles
d = s.density.tot ; 
a = f_quantile_new2(p, 5, d, s) ;
f = 34 ;

%% A: DISPOSABLE INCOME BY QUINTILE

% Put a price index with the disposable income from Insee 2018
DI_Insee = [10030	15910	19730	23680	28150	33320	39260	46450	57230	102880] ; % Source Insee 2018 - Revenus et patrimoine des ménages 
QI_Insee = mean(reshape(DI_Insee,2,5)) ;
% Disposable income in model
QI_model = a.quintile.TI;
price_index =  mean(QI_Insee)/mean(QI_model);
QI_model = QI_model.*price_index;
labels = {'Q1', 'Q2', 'Q3', 'Q4', 'Q5'};

% Graph
figure ;    
subplot(221)
green = [0.4660 0.6740 0.1880];    
bar(QI_Insee/1000, 'FaceColor', green, 'EdgeColor', 'none', 'BarWidth', 0.8) ; 
hold on ; plot(QI_model/1000,'oblack','MarkerFaceColor', 'black','MarkerSize',20) ;
xtickangle(0); % Rotation des etiquettes 
xticklabels(labels); xticks(1:numel(labels));
ylabel('thousands of euros', 'interpreter', 'latex','Fontsize',f) ;
legend({'\ Data','\ Model'}, 'interpreter', 'latex', 'Box', 'off', 'Location', 'northwest', 'Fontsize',30) ; 
title('a. Disposable income', 'interpreter','latex')  ;
ax1=gca; ax1.FontSize = f ; set(gcf, 'color', 'w') ; ax1.XColor = 'black'; ax1.YColor = 'black';   
ax1.Box = 'off'; % Enleve l'encadrement noir
ax1.TickLength = [0 0]; % Enleve les tirets noirs de l'axe des abscisses
ylim([0,100]) ; yticks(0:20:100);
set(ax1, 'XTickLabel', labels, 'TickLabelInterpreter', 'latex'); 


%% B: TYPE SHARE WITHIN QUINTILE
mat1 = 100*a.cross.share./sum(a.cross.share,2) ;
mat2 = 100*p.data.mat_cross ; 

subplot(222)
hold on;
num_col = size(mat2, 2);
% Plotting I as solid lines
for i_q = 1:num_col
    % Plotting I as solid lines
    plot(mat2(:, i_q), 'LineWidth', 10);
end
    % Plotting Q as dashed lines with the same colors as I
for i_q = 1:num_col
    color_order = get(gca, 'ColorOrder');
    color_index = mod(i_q-1, size(color_order, 1)) + 1;
    color = color_order(color_index, :);
    plot(mat1(:, i_q), 'LineStyle', '--', 'LineWidth', 5, 'Color', color);    
end
hold off;
labels = {'Q1', 'Q2', 'Q3', 'Q4', 'Q5'};
xtickangle(0); % Rotation des etiquettes 
xticklabels(labels); xticks(1:numel(labels));
ylabel('\%',  'interpreter', 'latex', 'FontSize', 30, 'Color', 'black');
legend({'\ Rural', '\ Small', '\ Medium', '\ Large', '\ Paris'},  'interpreter', 'latex', 'Box', 'off','Fontsize',30);
title('b. Type share within quintiles', 'interpreter','latex')  ;
ax1 = gca; ax1.FontSize = 34;
set(ax1, 'XTickLabel', labels, 'TickLabelInterpreter', 'latex'); 


%% C/D: Transition matrix
mat1 = s.matrice_migration^5 ; 
mat2 = p.data.mat_migration ; 
sum( abs(mat1-mat2) , 'all' ) ;
f = 26 ;

% SUBPLOT MODEL
for iM = 1:2
    if iM == 1 ; M = mat1 ; else ; M = mat2 ; end
    subplot(2,2,iM+2);  
    imagesc(M.^0.2);  % Afficher la matrice avec des couleurs
    %colormap(cool);
    colormap(sky);
    
    % Ajouter les valeurs dans chaque case pour le premier subplot
    for i = 1:size(mat1, 1)
        for j = 1:size(M, 2)
            value = num2str(M(i, j), '%.2f');
            text(j, i, value, 'FontSize', f, 'HorizontalAlignment', 'center', 'Color', 'k');
        end
    end
    if iM == 1 ; title('c. Migration: model','interpreter','latex', 'FontSize', f+12); 
    else       ; title('d. Migration: data','interpreter','latex', 'FontSize', f+12); 
    end
    
    xlabel("Next region $k'$",'interpreter','latex'); 
    ylabel('Current region $k$','interpreter','latex');
    % Ajuster les ticks pour que les valeurs soient centrées
    ax = gca; % Obtenir les axes courants
    ax.XTick = 1:size(mat2, 2);
    ax.YTick = 1:size(mat2, 1);
    ax.TickLabelInterpreter = 'Latex'; % Garder les labels formatés correctement
    ax.XAxis.FontSize = 34 ;
    ax.YAxis.FontSize = 34 ;

end




end