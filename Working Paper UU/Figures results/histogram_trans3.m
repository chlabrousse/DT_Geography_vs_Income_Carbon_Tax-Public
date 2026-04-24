function histogram_trans3(density, V1, V2, V3, V00, leg)
    
    % Values to plot
    values1 = (V1-V00);  % Vector of values
    values2 = (V2-V00);  % Vector of values
    values3 = (V3-V00);  % Vector of values
    % Define the bin edges for the histogram
    bmin = -10 ; bmax = 100 ; pas = 10 ;
    binEdges = bmin:pas:bmax;
    binEdges(end+1) = 10^10 ;
    % Reshape density
    density = density/sum(density) ;

    % Compute the weighted histogram manually
    for i = 2:length(binEdges)
        b1 = binEdges(i-1) ;
        b2 = binEdges(i) ;
        % Index
        v = values1 ; I = logical(( v >= b1).*(v <= b2 ))  ;
        d1(i-1) = sum(density(I)) ;
        v = values2 ; I = logical(( v >= b1).*(v <= b2 ))  ;
        d2(i-1) = sum(density(I)) ;
        v = values3 ; I = logical(( v >= b1).*(v <= b2 ))  ;
        d3(i-1) = sum(density(I)) ;
    end


    %% Figure
    figure
    set(gcf,'units','centimeters') ; 
    set(gcf,'Position',[5 5 50 30]) ;

    set(gcf, 'color', 'w');
    bar(binEdges(1:end-1), d1,'FaceAlpha', 0.5,'FaceColor', 'b', 'EdgeColor', 'none');    
    hold on
    plot(binEdges(1:end-1), d2,'oblack', 'MarkerFaceColor','red','MarkerSize',10); 
    hold on
    plot(pas/30+binEdges(1:end-1), d3,'oblack', 'MarkerFaceColor','blue','MarkerSize',10); 
    legend(leg, 'Interpreter','latex','Box','off')
    ax2 = gca; title('Histogram of welfare gains', 'interpreter','latex')  ;
    axes


    function axes 
        xlabel('Welfare gains', 'interpreter','latex', 'FontSize', 30, 'Color', 'black');
        ylabel('Density (\%)', 'interpreter','latex', 'FontSize', 30, 'Color', 'black');
        set(ax2, 'Box', 'off', 'TickLength', [0 0], 'XColor', 'black', 'YColor', 'black', ...
        'FontSize', 40,'TickLabelInterpreter', 'latex');
    end

end 

