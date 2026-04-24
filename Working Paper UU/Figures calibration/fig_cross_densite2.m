%% Plot lignes cross densité

function fig_cross_densite2(p, s)

% Créer les quintiles
d = s.density.tot ; 
a = f_quantile_new2(p, 5, d, s) ;

% Définir la matrice
mat1= 100*a.cross.share./sum(a.cross.share,2) ;
mat2 = 100*p.data.mat_cross ; 

% Plot les lignes
figure
set(gcf, 'color', 'w');
set(gcf,'units','centimeters') ; 
set(gcf,'Position',[5 5 50 30]) ;

    hold on;
    num_col = size(mat1, 2);
    % Plotting I as solid lines
    for i_q = 1:num_col
        % Plotting I as solid lines
        plot(mat1(:, i_q), 'LineWidth', 10);
    end
        % Plotting Q as dashed lines with the same colors as I
    for i_q = 1:num_col
        color_order = get(gca, 'ColorOrder');
        color_index = mod(i_q-1, size(color_order, 1)) + 1;
        color = color_order(color_index, :);
        plot(mat2(:, i_q), 'LineStyle', '--', 'LineWidth', 5, 'Color', color);    
    end
    hold off;
    labels = {'Q1', 'Q2', 'Q3', 'Q4', 'Q5'};
    xtickangle(0); % Rotation des etiquettes 
    xticklabels(labels); xticks(1:numel(labels));
    ylabel('\%',  'interpreter', 'latex', 'FontSize', 30, 'Color', 'black');
    legend({'\ Rural', '\ Small', '\ Medium', '\ Large', '\ Paris'},  'interpreter', 'latex', 'Box', 'off','Fontsize',30);
    title('b. Type share within quintiles', 'interpreter','latex')  ;
    ax1 = gca; ax1.FontSize = 30;
    set(ax1, 'XTickLabel', labels, 'TickLabelInterpreter', 'latex'); 
    
end