function fig_compare_horizon2(p, Q)
    %% values no migration
    tau_h_geo_no_mig = [-42 -35 -28 -22 -15]; 
    tau_h_inc_no_mig = [-38 -33 -30 -25 -21];
    tau_f_geo_no_mig = [-19 -15 -12 -9 -5]; 
    tau_f_inc_no_mig = [-13 -14 -13 -12 -9.5];

    %%
    % Horizons
    h1 = 5 ; h2 = 20 ; h3 = p.T-1;
    a_scale = "quintile";
    scale_Insee = 15.6666;

    figure; 
    set(gcf, 'color', 'w');
    set(gcf,'units','centimeters') ; 
    set(gcf,'Position',[0 5 100 30]) ;

    subplot(221) ; 
    a = "type" ; b = "WE10" ;
    hold on
    bar(Q(h3).(a).(b)/scale_Insee,'EdgeColor','none') ; 
    Plot ; 
    % scale_no_mig = mean(Q(h3).(a_scale).(b))./mean(tau_h_inc_no_mig);
    scale_no_mig = 1;
    plot(tau_h_geo_no_mig.*scale_no_mig/scale_Insee,'linewidth',4,'LineStyle','--','Marker', 'o', ...
                'Color',  'black' ,'MarkerFaceColor', 'black', 'MarkerEdgeColor', 'none', ...
                'MarkerSize', 15);
    hold off
    labels = p.region ; xtickangle(45);  yticks(-3:1:0); ylim([-3 0]) ;
    ax2 = gca; title('a. $\tau^h$ by location', 'interpreter','latex')  ;
    axes ; 
    
    subplot(222) ; 
    a = "quintile" ; b = "WE10" ; 
    hold on
    bar(Q(h3).(a).(b)/scale_Insee,'EdgeColor','none') ; 
    Plot ; 
    %scale_no_mig = mean(Q(h3).(a_scale).(b))./mean(tau_h_inc_no_mig);
    scale_no_mig = 1;
    plot(tau_h_inc_no_mig.*scale_no_mig/scale_Insee,'linewidth',4,'LineStyle','--','Marker', 'o', ...
                'Color',  'black' ,'MarkerFaceColor', 'black', 'MarkerEdgeColor', 'none', ...
                'MarkerSize', 15);
    hold off
    labels = {'Q1', 'Q2', 'Q3', 'Q4', 'Q5'};  yticks(-3:1:0); ylim([-3 0]) ;
    ax2 = gca; title('b. $\tau^h$ by income', 'interpreter','latex')  ;
    axes ; 
    
    subplot(223) ; 
    a = "type" ; b = "WE01" ; 
    hold on
    bar(Q(h3).(a).(b)/scale_Insee,'EdgeColor','none') ; 
    Plot ; 
    %scale_no_mig = mean(Q(h3).(a_scale).(b))./mean(tau_f_inc_no_mig); 
    scale_no_mig  = 1;
    plot(tau_f_geo_no_mig.*scale_no_mig/scale_Insee,'linewidth',4,'LineStyle','--','Marker', 'o', ...
                'Color',  'black' ,'MarkerFaceColor', 'black', 'MarkerEdgeColor', 'none', ...
                'MarkerSize', 15);
    hold off
    labels = p.region ; xtickangle(45);  yticks(-3:.5:0); ylim([-1.5 0]) ;
    ax2 = gca; title('c. $\tau^f$ by location', 'interpreter','latex')  ;
    axes
    
    subplot(224) ; 
    a = "quintile" ; b = "WE01" ; 
    hold on
    bar(Q(h3).(a).(b)/scale_Insee,'EdgeColor','none') ;  
    Plot ; 
    %scale_no_mig = mean(Q(h3).(a_scale).(b))./mean(tau_f_inc_no_mig);
    scale_no_mig = 1;
    plot(tau_f_inc_no_mig.*scale_no_mig/scale_Insee,'linewidth',4,'LineStyle','--','Marker', 'o', ...
                'Color',  'black' ,'MarkerFaceColor', 'black', 'MarkerEdgeColor', 'none', ...
                'MarkerSize', 15);
    hold off
    labels = {'Q1', 'Q2', 'Q3', 'Q4', 'Q5'}; xtickangle(0);  yticks(-3:.5:0); ylim([-1.5 0]) ;
    ax2 = gca; title('d. $\tau^f$ by income', 'interpreter','latex')  ;
    axes

    legend({'\ Benchmark \, ','\ $T=5$ \, ','\ $T=20$ \, ','\ Without migration \, '}, ...
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
        a_scale = "quintile";
        scale = mean(Q(h3).(a_scale).(b))./mean([Q(h1).(a_scale).(b) ; Q(h2).(a_scale).(b)]');

        cols = lines(3);  % Or however many horizons you want to compare
        Y = [Q(h1).(a).(b) ; Q(h2).(a).(b)]' .* scale /scale_Insee;
    
        for i = 1:size(Y,2)
            plot(Y(:,i), 'LineWidth', 4, ...
                'Marker', 'o', ...
                'Color', cols(i+1,:), ...
                'MarkerFaceColor', cols(i+1,:), ...
                'MarkerEdgeColor', 'none', ...
                'MarkerSize', 15)
        end
       % plot([Q(h1).(a).(b) ; Q(h2).(a).(b)]'.*scale,'linewidth',4, 'Marker','o', ...
        %    'MarkerFaceColor','auto','MarkerSize',10) ;
    end

end

