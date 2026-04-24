function fig_W_cross_double(p, ss, tr1, tr2)

% Welfare
V_SS      = ss.V.V ;
V_trans10 = tr1.V(1).V ;
V_trans01 = tr2.V(1).V ;
% WE 
WE10 = f_welfare_WE_target(p, ss, V_SS, V_trans10 ) ;
WE01 = f_welfare_WE_target(p, ss, V_SS, V_trans01 ) ;

% Distribution of WE
x.WE10 = WE10 ;
x.WE01 = WE01 ;
QQ = f_quantile_new4_moustache(p, 5, ss.density.tot, ss, x) ;

figure
set(gcf, 'color', 'w');
set(gcf,'units','centimeters') ; 
set(gcf,'Position',[0 20 100 20]) ;
scale = 15.6667;
% scale = 1;
subplot(121) ; plot(QQ.cross.WE10./scale,'linewidth',4) ; 
ax2 = gca; title('a. Income only', 'interpreter','latex')  ;
axes;  ylim([-10 180]); yticks(0:20:200) ;
subplot(122) ; plot(QQ.cross.WE01./scale,'linewidth',4) ; 
ax2 = gca; title('b. Income X geo', 'interpreter','latex')  ;
ylim([-10 180]); yticks(0:20:200) ;
% ylim([-15 -6]); yticks(-14:2:0) ;
axes


    function axes
        labels = {'Q1', 'Q2', 'Q3', 'Q4', 'Q5'};
        regions = {'\ Rural', '\ Small', '\ Medium', '\ Large', '\ Paris' } ;
        ylabel('WE (\%)', 'interpreter','latex', 'FontSize', 35, 'Color', 'black');
        set(ax2, 'Box', 'off', 'TickLength', [0 0], 'XColor', 'black', 'YColor', 'black', ...
        'FontSize', 35, 'XTickLabel', labels, 'TickLabelInterpreter', 'latex');
        legend(regions, 'interpreter','latex','Box','off','Location','southeast') ; 
        xticks(1:numel(labels)); xticklabels(labels); 
    end

end