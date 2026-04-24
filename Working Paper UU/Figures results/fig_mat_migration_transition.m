%% Plot matrice transition modele et data

function fig_mat_migration_transition(s, s2, s3, s4, b)
figure
set(gcf, 'color', 'w');
% Définir la matrice
mat1 = s.matrice_migration^5 - b.matrice_migration^5; 
mat2 = s2.matrice_migration^5 - b.matrice_migration^5; 
mat3 = s3.matrice_migration^5 - b.matrice_migration^5; 
mat4 = s4.matrice_migration^5 - b.matrice_migration^5; 
sum( abs(mat1-mat2) , 'all' ) ;
f = 27 ;

% Define the custom colormap with lighter reds and darker blues
num_colors = 256; % Number of colors in the colormap
blue_part = [linspace(1, 0, num_colors)', linspace(1, 0.5, num_colors)', ones(num_colors, 1)];
% red_part = [linspace(0.5, 1, num_colors)', linspace(0.2, 1, num_colors)', linspace(0.2, 1, num_colors)'];
red_part = [ones(num_colors, 1), linspace(0.2, 1, num_colors)', linspace(0.1, 1, num_colors)'];
custom_colormap = [red_part; blue_part]; % Combine red (lighter) and blue (darker) parts


% SUBPLOT MODEL
for iM = 1:4
    if iM == 1 ; M = mat1 ; elseif iM == 2 ; M = mat2 ; 
    elseif iM == 3 ; M = mat3 ; else ; M = mat4 ;end
    M = M*100;
    subplot(2,2,iM);  
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
    if iM == 1 ; title('After 1 year','interpreter','latex', 'FontSize', f+12); 
    elseif iM == 2 ; title('After 3 years','interpreter','latex', 'FontSize', f+12); 
    elseif iM == 3 ; title('After 5 years','interpreter','latex', 'FontSize', f+12); 
    else       ; title('After 10 years','interpreter','latex', 'FontSize', f+12); 
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

        % Remove tick marks
    ax.TickLength = [0 0];

     % Adjust color limits
    caxis([-0.5 0.5]);

end

end