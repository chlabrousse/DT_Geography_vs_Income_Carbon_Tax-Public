%% Plot matrice transition modele et data

function fig_mat_migration(p, s)
figure
% Définir la matrice
mat1 = s.matrice_migration^5 ; 
mat2 = p.data.mat_migration ; 
sum( abs(mat1-mat2) , 'all' ) ;
f = 27 ;

% SUBPLOT MODEL
for iM = 1:2
    if iM == 1 ; M = mat1 ; else ; M = mat2 ; end
    subplot(1,2,iM);  
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
    if iM == 1 ; title('Model','interpreter','latex', 'FontSize', f+12); 
    else       ; title('Data','interpreter','latex', 'FontSize', f+12); 
    end
    
    xlabel("Next region $k'$",'interpreter','latex'); 
    ylabel('Current region $k$','interpreter','latex');
    % Ajuster les ticks pour que les valeurs soient centrées
    ax = gca; % Obtenir les axes courants
    ax.XTick = 1:size(mat2, 2);
    ax.YTick = 1:size(mat2, 1);
    ax.TickLabelInterpreter = 'Latex'; % Garder les labels formatés correctement
    ax.XAxis.FontSize = f+8 ;
    ax.YAxis.FontSize = f+8 ;

end

end