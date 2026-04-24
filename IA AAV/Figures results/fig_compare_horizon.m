function fig_compare_horizon(p, Q)

    % Horizons
    h1 = 5 ; h2 = 20 ; h3 = p.T-1;

    figure; 
    set(gcf, 'color', 'w');
    set(gcf,'units','centimeters') ; 
    set(gcf,'Position',[0 5 100 30]) ;

    subplot(221) ; 
    a = "type" ; b = "WE10" ; Plot
    labels = p.region ; xtickangle(45); yticks(-40:10:-10); ylim([-35 -8]) ; 
    ax2 = gca; title('a. $\tau^h$ by location', 'interpreter','latex')  ;
    axes ; 
    
    subplot(222) ; 
    a = "quintile" ; b = "WE10" ; Plot
    labels = {'Q1', 'Q2', 'Q3', 'Q4', 'Q5'};  yticks(-40:10:-10); ylim([-35 -8]) ; 
    ax2 = gca; title('b. $\tau^h$ by income', 'interpreter','latex')  ;
    axes ; 
    
    subplot(223) ; 
    a = "type" ; b = "WE01" ; Plot
    labels = p.region ; xtickangle(45); ylim([-13 -2]) ; yticks(-12:3:-2);
    ax2 = gca; title('c. $\tau^f$ by location', 'interpreter','latex')  ;
    axes
    
    subplot(224) ; 
    a = "quintile" ; b = "WE01" ; Plot
    labels = {'Q1', 'Q2', 'Q3', 'Q4', 'Q5'}; xtickangle(0); ylim([-13 -2]) ; yticks(-12:3:-2);
    ax2 = gca; title('d. $\tau^f$ by income', 'interpreter','latex')  ;
    axes

    legend({'\ $T=5${               }','\ $T=20${               }','\ $T=\infty$'}, ...
'interpreter','latex', 'Box', 'off','FontSize', 40,'location','southoutside',...
'Orientation','horizontal') ; 
   L = legend; L.ItemTokenSize(1) = 40;


    function axes
        xticks(1:numel(labels)); xticklabels(labels);  
                ylabel('WE (\%)', 'interpreter','latex', 'FontSize', 30, 'Color', 'black');
        set(ax2, 'Box', 'off', 'TickLength', [0 0], 'XColor', 'black', 'YColor', 'black', ...
        'FontSize', 30, 'XTickLabel', labels, 'TickLabelInterpreter', 'latex');

    end
    function Plot
        plot([Q(h1).(a).(b) ; Q(h2).(a).(b) ; Q(h3).(a).(b)]','linewidth',4) ;
    end

end

