function fig_density_change3(p, s, s_tau_h, s_tau_f)

a00 = f_quantile_new2(p, 5, s.density.tot, s);
a_tau_f = f_quantile_new2(p, 5, s_tau_f.density.tot, s_tau_f);
a_tau_h = f_quantile_new2(p, 5, s_tau_h.density.tot, s_tau_h);
y_labels = {'Q1', 'Q2', 'Q3', 'Q4', 'Q5'};
x_labels = {'Rural', 'Small', 'Medium', 'Large', 'Paris'};

mat1 = (a_tau_h.cross.share - a00.cross.share )*100 ;
mat2 = (a_tau_f.cross.share - a00.cross.share )*100 ;
sum( abs(mat1-mat2) , 'all' ) ;
f = 25;

% Define the custom colormap with lighter reds and darker blues
num_colors = 256; % Number of colors in the colormap
blue_part = [linspace(1, 0, num_colors)', linspace(1, 0.5, num_colors)', ones(num_colors, 1)];
% red_part = [linspace(0.5, 1, num_colors)', linspace(0.2, 1, num_colors)', linspace(0.2, 1, num_colors)'];
red_part = [ones(num_colors, 1), linspace(0.2, 1, num_colors)', linspace(0.1, 1, num_colors)'];
custom_colormap = [red_part; blue_part]; % Combine red (lighter) and blue (darker) parts

% Apply the custom colormap
figure;
set(gcf, 'color', 'w');
for iM = 1:2
    if iM == 1
        M = mat1;
    else
        M = mat2;
    end
    subplot(1, 2, iM)
    imagesc(M);
    colormap(custom_colormap); % Apply the custom colormap
    % Removed the colorbar
    
    % Add the values in each cell
    for i = 1:size(M, 1)
        for j = 1:size(M, 2)
            value = num2str(M(i, j), '%.2f');
            text(j, i, value, 'FontSize', f, 'HorizontalAlignment', 'center', 'Color', 'k', 'Interpreter', 'latex');
        end
    end
    if iM == 1
        title('a. $\tau_h$', 'interpreter', 'latex', 'FontSize', f + 12);
    else
        title('b. $\tau_f$', 'interpreter', 'latex', 'FontSize', f + 12);
    end
    xtickangle(45); % Rotate labels
    xticklabels(x_labels);
    xticks(1:numel(x_labels));
    yticklabels(y_labels);
    yticks(1:numel(y_labels));
    ax = gca; % Get current axes
    ax.XTick = 1:size(M, 2);
    ax.YTick = 1:size(M, 1);
    ax.TickLabelInterpreter = 'Latex'; % Format labels correctly
    ax.XAxis.FontSize = f + 8;
    ax.YAxis.FontSize = f + 8;
    
    % Remove tick marks
    ax.TickLength = [0 0];
    
    % Adjust color limits
    caxis([-0.1 0.1]);
end
end
