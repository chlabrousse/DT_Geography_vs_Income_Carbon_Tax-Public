%% test Yann deciles
d = s(1).density.tot;
t = 1;
mobility_ss = f_quantile_savings(p, 10, d, sum(s(1).V.k.ap.*s(1).V.H,2) - p.s(:,1)) ;
mobility_10 = f_quantile_savings(p, 10, d, sum(tr10G.V(t).k.ap.*tr10G.V(t).H,2) - p.s(:,1)) ;
mobility_01 = f_quantile_savings(p, 10, d, sum(tr01G.V(t).k.ap.*tr01G.V(t).H,2)  - p.s(:,1)) ;



%% Figure
% cols = [1 2 3 4 5];    

figure
set(gcf, 'color', 'w');
    set(gcf,'units','centimeters') ; 
    set(gcf,'Position',[0 5 80 30]) ;
subplot(131)
plot(mobility_ss.savings, 'LineWidth',5)
title("a. Initial savings ($a_{t+1}-a_t$)", 'interpreter','latex', 'FontSize', 30)
xlabel('Wealth quantiles', 'interpreter','latex', 'FontSize', 30, 'Color', 'black');
ylabel('Savings', 'interpreter','latex', 'FontSize', 30, 'Color', 'black');
ax2 = gca; set(ax2, 'Box', 'off', 'TickLength', [0 0], 'XColor', 'black', 'YColor', 'black', ...
        'FontSize', 30, 'TickLabelInterpreter', 'latex'); xlim([0 10]), xticks(0:2:10)

subplot(132)
plot(  (mobility_10.savings-mobility_ss.savings)*100, 'LineWidth',5 )
title('b. Change: $\tau^h$ only', 'interpreter','latex', 'FontSize', 30)
xlabel('Wealth quantiles', 'interpreter','latex', 'FontSize', 30, 'Color', 'black');
ylabel('Change in savings w.r.t. SS (\%)', 'interpreter','latex', 'FontSize', 30, 'Color', 'black');
ax2 = gca; set(ax2, 'Box', 'off', 'TickLength', [0 0], 'XColor', 'black', 'YColor', 'black', ...
        'FontSize', 30, 'TickLabelInterpreter', 'latex');  ylim([-0.2 .3]); xlim([0 10]), xticks(0:2:10)

subplot(133)
plot((mobility_01.savings-mobility_ss.savings)*100 , 'LineWidth',5 )
title('c. Change: $\tau^f$ only', 'interpreter','latex', 'FontSize', 30)
xlabel('Wealth quantiles', 'interpreter','latex', 'FontSize', 30, 'Color', 'black');
ylabel('Change in savings w.r.t. SS (\%)', 'interpreter','latex', 'FontSize', 30, 'Color', 'black');
legend({'\ Rural','\ Small','\ Medium','\ Large','\ Paris'}, 'interpreter','latex', 'FontSize', 40, 'Box','off')
ax2 = gca; 
set(ax2, 'Box', 'off', 'TickLength', [0 0], 'XColor', 'black', 'YColor', 'black', ...
        'FontSize', 30,  'TickLabelInterpreter', 'latex');   ylim([-0.2 .3]); xlim([0 10]), xticks(0:2:10)

