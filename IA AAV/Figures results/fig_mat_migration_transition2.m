%% Plot matrice transition modele et data

function fig_mat_migration_transition2(mat1, mat2)
figure
set(gcf, 'color', 'w');

f = 27 ;

% Define the custom colormap with lighter reds and darker blues
num_colors = 256; % Number of colors in the colormap
blue_part = [linspace(1, 0, num_colors)', linspace(1, 0.5, num_colors)', ones(num_colors, 1)];
% red_part = [linspace(0.5, 1, num_colors)', linspace(0.2, 1, num_colors)', linspace(0.2, 1, num_colors)'];
red_part = [ones(num_colors, 1), linspace(0.2, 1, num_colors)', linspace(0.1, 1, num_colors)'];
custom_colormap = [red_part; blue_part]; % Combine red (lighter) and blue (darker) parts

x_labels = {'Rural', 'Small', 'Medium', 'Large', 'Paris'};
y_labels = x_labels;



% SUBPLOT MODEL
for iM = 1:2
    if iM == 1 ; M = mat1 ; else;  M = mat2 ; end
    subplot(1,2,iM);  
    imagesc(M);
    colormap(custom_colormap); % Apply the custom colormap
   %colormap(cool);
    % colormap(sky);
    
    % Ajouter les valeurs dans chaque case pour le premier subplot
    for i = 1:size(mat1, 1)
        for j = 1:size(M, 2)
            value = num2str(M(i, j), '%.2f');
            text(j, i, value, 'FontSize', f, 'HorizontalAlignment', 'center', 'Color', 'k');
        end
    end
     if iM == 1
        title('a. $\tau_h$', 'interpreter', 'latex', 'FontSize', f + 12);
    else
        title('b. $\tau_f$', 'interpreter', 'latex', 'FontSize', f + 12);
     end

    xlabel("Next region $k'$",'interpreter','latex'); 
    ylabel("Current region $k$",'interpreter','latex');
    % Ajuster les ticks pour que les valeurs soient centrées
    ax = gca; % Obtenir les axes courants
    ax.XTick = 1:size(mat2, 2);
    ax.YTick = 1:size(mat2, 1);
    ax.TickLabelInterpreter = 'Latex'; % Garder les labels formatés correctement
    ax.XAxis.FontSize = f+8 ;
    ax.YAxis.FontSize = f+8 ;

    xtickangle(45); % Rotate labels
    xticklabels(x_labels);
    xticks(1:numel(x_labels));
    yticklabels(y_labels);
    yticks(1:numel(y_labels));

        % Remove tick marks
    ax.TickLength = [0 0];

     % Adjust color limits
    caxis([-0.1 0.1]);

end

end