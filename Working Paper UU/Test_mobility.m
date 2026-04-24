%% test mobility policy function
% test: 
% plot(abs(s(1).density.tot - tr01G.density(:,1)))
x = 1:500;
y1 = 1;
y2 = 10;
k = 1;

figure
sgtitle('Changement de la décision de rester: ruraux', 'interpreter','latex', 'FontSize', 30)
subplot(121)
plot( [tr10G.V(y1).H(x,k), tr10G.V(y2).H(x,k)] - s(1).V.H(x,k), 'LineWidth',5)
title('tau_h', 'interpreter','latex', 'FontSize', 30)
xlabel('wealth', 'interpreter','latex', 'FontSize', 30, 'Color', 'black');
ylabel('changement de proba', 'interpreter','latex', 'FontSize', 30, 'Color', 'black');

subplot(122)
plot([tr01G.V(y1).H(x,k), tr01G.V(y2).H(x,k)] - s(1).V.H(x,k) , 'LineWidth',5 )
title('tau_f', 'interpreter','latex', 'FontSize', 30)
legend({'1st period', 'after 10 years'},'Interpreter','latex', 'FontSize', 30, 'Box','off')
xlabel('wealth', 'interpreter','latex', 'FontSize', 30, 'Color', 'black');
ylabel('changement de proba', 'interpreter','latex', 'FontSize', 30, 'Color', 'black');

%% test Yann deciles
d = s(1).density.tot;

mobility_ss = f_quantile_mobility(p, 10, d, s(1).V.H) ;
mobility_10 = f_quantile_mobility(p, 10, d, tr10G.V(1).H) ;
mobility_01 = f_quantile_mobility(p, 10, d, tr01G.V(1).H) ;


%% Figure
cols = [1 2 3 4 5];    

figure
set(gcf, 'color', 'w');
    set(gcf,'units','centimeters') ; 
    set(gcf,'Position',[0 5 80 30]) ;
subplot(131)
plot(100 - mobility_ss.proba_stay(:,cols).*100, 'LineWidth',5)
title('a. Initial probability to move', 'interpreter','latex', 'FontSize', 30)
xlabel('Wealth deciles', 'interpreter','latex', 'FontSize', 30, 'Color', 'black');
ylabel('Proba to move from the city (\%)', 'interpreter','latex', 'FontSize', 30, 'Color', 'black');
ax2 = gca; set(ax2, 'Box', 'off', 'TickLength', [0 0], 'XColor', 'black', 'YColor', 'black', ...
        'FontSize', 30, 'TickLabelInterpreter', 'latex');
xlim([0 10]), xticks(0:2:10)

subplot(132)
plot( (mobility_ss.proba_stay(:,cols) - mobility_10.proba_stay(:,cols)).*100, 'LineWidth',5 )
title('b. Change: $\tau^h$ only', 'interpreter','latex', 'FontSize', 30)
xlabel('Wealth deciles', 'interpreter','latex', 'FontSize', 30, 'Color', 'black');
ylabel('Change in proba to move w.r.t. SS (\%)', 'interpreter','latex', 'FontSize', 30, 'Color', 'black');
ax2 = gca; set(ax2, 'Box', 'off', 'TickLength', [0 0], 'XColor', 'black', 'YColor', 'black', ...
        'FontSize', 30, 'TickLabelInterpreter', 'latex');  ylim([-0.4 1]), xlim([0 10]), xticks(0:2:10)

subplot(133)
plot( (mobility_ss.proba_stay(:,cols) - mobility_01.proba_stay(:,cols)).*100, 'LineWidth',5 )
title('c. Change: $\tau^f$ only', 'interpreter','latex', 'FontSize', 30)
xlabel('Wealth deciles', 'interpreter','latex', 'FontSize', 30, 'Color', 'black');
ylabel('Change in proba to move w.r.t. SS (\%)', 'interpreter','latex', 'FontSize', 30, 'Color', 'black');
legend({'\ Rural','\ Small','\ Medium','\ Large','\ Paris'}, 'interpreter','latex', 'FontSize', 40, 'Box','off')
ax2 = gca; 
set(ax2, 'Box', 'off', 'TickLength', [0 0], 'XColor', 'black', 'YColor', 'black', ...
        'FontSize', 30,  'TickLabelInterpreter', 'latex');  ylim([-0.4 1]), xlim([0 10]), xticks(0:2:10)



%% test mobility policy function
% test: 
% plot(abs(s_opti(1).density.tot - tr11T_geo_10.density(:,1)))
x = 1:500;
y1 = 1;
y2 = 10;
k = 1;

figure
sgtitle('Changement de la décision de rester: ruraux', 'interpreter','latex', 'FontSize', 30)
subplot(121)
plot( [tr11T_inc_10.V(y1).H(x,k), tr11T_inc_10.V(y2).H(x,k)] - s_opti(1).V.H(x,k), 'LineWidth',5)
title('income only', 'interpreter','latex', 'FontSize', 30)
xlabel('wealth', 'interpreter','latex', 'FontSize', 30, 'Color', 'black');
ylabel('changement de proba', 'interpreter','latex', 'FontSize', 30, 'Color', 'black');
ax2 = gca; axes

subplot(122)
plot([tr11T_geo_10.V(y1).H(x,k), tr11T_geo_10.V(y2).H(x,k)] - s_opti(1).V.H(x,k) , 'LineWidth',5 )
title('income x geo', 'interpreter','latex', 'FontSize', 30)
legend({'1st period', 'after 10 years'},'Interpreter','latex', 'FontSize', 30, 'Box','off')
xlabel('wealth', 'interpreter','latex', 'FontSize', 30, 'Color', 'black');
ylabel('changement de proba', 'interpreter','latex', 'FontSize', 30, 'Color', 'black');
ax2 = gca; axes


%% test Yann deciles
d = s_opti(1).density.tot;

mobility_ss = f_quantile_mobility(p, 10, d, s_opti(1).V.H) ;
mobility_inc = f_quantile_mobility(p, 10, d, tr11T_inc_10.V(1).H) ;
mobility_inc_geo = f_quantile_mobility(p, 10, d, tr11T_geo_10.V(1).H) ;

figure
subplot(121)
plot(mobility_ss.proba_stay - mobility_inc.proba_stay, 'LineWidth',5 )
title('income', 'interpreter','latex', 'FontSize', 30)
legend({'1st period', 'after 10 years'},'Interpreter','latex', 'FontSize', 30, 'Box','off')
xlabel('wealth deciles', 'interpreter','latex', 'FontSize', 30, 'Color', 'black');
ylabel('changement de proba to move', 'interpreter','latex', 'FontSize', 30, 'Color', 'black');
legend(p.region, 'interpreter','latex', 'FontSize', 30, 'Box','off'); ylim([-0.02 0.01])

subplot(122)
plot(mobility_ss.proba_stay - mobility_inc_geo.proba_stay, 'LineWidth',5 )
title('income X geo', 'interpreter','latex', 'FontSize', 30)
legend({'1st period', 'after 10 years'},'Interpreter','latex', 'FontSize', 30, 'Box','off')
xlabel('wealth deciles', 'interpreter','latex', 'FontSize', 30, 'Color', 'black');
ylabel('changement de proba to move', 'interpreter','latex', 'FontSize', 30, 'Color', 'black');
legend(p.region, 'interpreter','latex', 'FontSize', 30, 'Box','off'); ylim([-0.02 0.01])



