function fig_transfers_CE(p, ss, tr1, tr2, tr3)

    % Mise en quantile
    V_SS  = ss.V.V ;
    V_uni = tr1.V(1).V ;
    V_inc = tr2.V(1).V ;
    V_geo = tr3.V(1).V ;
    x.WE_uni = f_welfare_WE_target(p, ss, V_SS, V_uni) ;
    x.WE_inc = f_welfare_WE_target(p, ss, V_SS, V_inc) ;
    x.WE_geo = f_welfare_WE_target(p, ss, V_SS, V_geo) ;
    d = ss.density.tot ; 
    a = f_quantile_new2(p, 5, d, ss, x) ;


    %% Graphs welfare tauxh vs tauF, quintile vs living area
    green = [0.4660 0.6740 0.1880];
    yellow = [0.9290 0.6940 0.1250];
    red = [0.8500 0.3250 0.0980];
    blue =  [0 0.4470 0.7410];
    purple = [0.4940 0.1840 0.5560];
   
    marker_size = 500;
    markers = {'o', 's', '^', 'v'}; % Define markers for each line    
    marker_colors = {blue, yellow, green};

    

    %% Comparison by living area
    figure ; set(gcf, 'color', 'w');

    subplot(221) ; 
    A = a.type ;
    bar(A.WE_uni,'FaceColor', red, 'EdgeColor', 'none', 'BarWidth', 0.8);  
    labels = {'Rural', 'Small', 'Medium', 'Large', 'Paris'};
    xtickangle(45); xticks(1:numel(labels)); xticklabels(labels);    
    ax = gca; title('a. Welfare change by living area', 'interpreter','latex')  ;
    hold on;
    scatter(1:5, A.WE_inc, marker_size, 'Marker', markers{1}, 'MarkerFaceColor', marker_colors{1}, 'MarkerEdgeColor', marker_colors{1});
    scatter(1:5, A.WE_geo, marker_size, 'Marker', markers{3}, 'MarkerFaceColor', marker_colors{2}, 'MarkerEdgeColor', marker_colors{2});
    ylabel('WE (\%)', 'interpreter','latex', 'FontSize', 30, 'Color', 'black'); % ylim([-2.5 -1]); yticks(-3:.5:0);
    F_axes
     

    %% Comparison by quintile
    subplot(222) ; 
    A = a.quintile ; 
    bar(A.WE_uni,'FaceColor', red, 'EdgeColor', 'none', 'BarWidth', 0.8);  
    labels = {'Q1', 'Q2', 'Q3', 'Q4', 'Q5'};
    xtickangle(0); xticks(1:numel(labels)); xticklabels(labels);    
    ax = gca; title('b. Welfare change by disposable income', 'interpreter','latex')  ;
    hold on;
    scatter(1:5, A.WE_inc, marker_size, 'Marker', markers{1}, 'MarkerFaceColor', marker_colors{1}, 'MarkerEdgeColor', marker_colors{1});
    scatter(1:5, A.WE_geo, marker_size, 'Marker', markers{3}, 'MarkerFaceColor', marker_colors{2}, 'MarkerEdgeColor', marker_colors{2});
    ylabel('WE (\%)', 'interpreter','latex', 'FontSize', 30, 'Color', 'black'); %ylim([-2.5 -1]); yticks(-3:.5:0);
    
    [~, objh] = legend({'\ Uniform', '\ Rural', '\ Poor', '\ Poor x Rural'}, 'Box', 'off', 'FontSize', 30, 'Interpreter', 'latex', 'Location', 'northeast');
    
    % Increase the size of the legend symbols (manually adjust MarkerSize)
    objhl = findobj(objh, 'type', 'patch');
    set(objhl, 'Markersize', 30);    
    F_axes


    function F_axes
       set(ax,'FontSize', 30,'XColor', 'black', 'YColor','black', 'TickLabelInterpreter', 'latex', 'Box', 'off', 'TickLength', [0 0]); 
    end
 

end