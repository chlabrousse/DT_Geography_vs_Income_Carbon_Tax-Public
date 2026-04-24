function fig_W_change_moustache2(p, s, tr, tr2, tr3)

lines = [
    0.0000, 0.4470, 0.7410   % blue
    0.8500, 0.3250, 0.0980   % orange
    0.9290, 0.6940, 0.1250   % yellow
    0.4940, 0.1840, 0.5560   % purple
    0.4660, 0.6740, 0.1880   % green
    0.3010, 0.7450, 0.9330   % light blue
    0.6350, 0.0780, 0.1840   % dark red
];

%% Créer les quintiles
V_SS = s.V.V ;
V_trans = tr.V(1).V ;
V_trans2 = tr2.V(1).V ;
V_trans3 = tr3.V(1).V ;

% scale_Insee = 1;
scale_Insee = 15.66666;

ss.CE = f_welfare_WE_target(p, s, V_SS, V_trans)./scale_Insee ;
ss2.CE = f_welfare_WE_target(p, s, V_SS, V_trans2)./scale_Insee;
ss3.CE = f_welfare_WE_target(p, s, V_SS, V_trans3)./scale_Insee ;
d = s.density.tot ;

a = f_quantile_new4_moustache(p, 5, d, s, ss) ;
a2 = f_quantile_new4_moustache(p, 5, d, s, ss2) ;
a3 = f_quantile_new4_moustache(p, 5, d, s, ss3) ;

% Bounds
low_bound = min([a.quintile.disp.CE,a2.quintile.disp.CE,a3.quintile.disp.CE] , [], 'all') ;
top_bound = max([a.quintile.disp.CE,a2.quintile.disp.CE,a3.quintile.disp.CE] , [], 'all') ;
low_bound = floor(low_bound) ;
top_bound = ceil(top_bound) ;

%% Graph welfare quintile vs living area
figure ;
set(gcf, 'color', 'w');
set(gcf,'units','centimeters') ; 
set(gcf,'Position',[5 5 50 30]) ;

subplot(231) ; 
aa = a.quintile.disp.CE ;
plot(aa(2,:), 'o', 'MarkerFaceColor', lines(1,:), 'MarkerSize', 10, 'MarkerEdgeColor','none');
hold on ; plot([1:5; 1:5], aa([1,3],:), 'k-', 'LineWidth', 1.5); hold off
hold on ; plot([1:5; 1:5]+0.1*[-1;1], [aa(1,:);aa(1,:)], 'k-', 'LineWidth', 2);
hold on ; plot([1:5; 1:5]+0.1*[-1;1], [aa(3,:);aa(3,:)], 'k-', 'LineWidth', 2);
labels = {'Q1', 'Q2', 'Q3', 'Q4', 'Q5'};
xtickangle(0); xticks(1:numel(labels)); xticklabels(labels);    
ax2 = gca; title('a. Uniform', 'interpreter','latex')  ;
axes

subplot(232) ; 
aa = a2.quintile.disp.CE ;
plot(aa(2,:), 'o', 'MarkerFaceColor', lines(1,:), 'MarkerSize', 10, 'MarkerEdgeColor','none');
hold on ; plot([1:5; 1:5], aa([1,3],:), 'k-', 'LineWidth', 1.5); hold off
hold on ; plot([1:5; 1:5]+0.1*[-1;1], [aa(1,:);aa(1,:)], 'k-', 'LineWidth', 2);
hold on ; plot([1:5; 1:5]+0.1*[-1;1], [aa(3,:);aa(3,:)], 'k-', 'LineWidth', 2);
labels = {'Q1', 'Q2', 'Q3', 'Q4', 'Q5'};
xtickangle(0); xticks(1:numel(labels)); xticklabels(labels);    
ax2 = gca; title('b. Income only', 'interpreter','latex')  ;
axes

subplot(233) ; 
aa = a3.quintile.disp.CE ;
plot(aa(2,:), 'o', 'MarkerFaceColor', lines(1,:), 'MarkerSize', 10, 'MarkerEdgeColor','none');
hold on ; plot([1:5; 1:5], aa([1,3],:), 'k-', 'LineWidth', 1.5); hold off
hold on ; plot([1:5; 1:5]+0.1*[-1;1], [aa(1,:);aa(1,:)], 'k-', 'LineWidth', 2);
hold on ; plot([1:5; 1:5]+0.1*[-1;1], [aa(3,:);aa(3,:)], 'k-', 'LineWidth', 2);
labels = {'Q1', 'Q2', 'Q3', 'Q4', 'Q5'};
xtickangle(0); xticks(1:numel(labels)); xticklabels(labels);    
ax2 = gca; title('c. Income X geo', 'interpreter','latex')  ;
axes

%%
% Axes
function axes
    ylabel('WE (\%)', 'interpreter','latex', 'FontSize', 30, 'Color', 'black');
    % bound = [-34 -16] ; pas = 3 ;
    %ylim(bound); yticks(min(bound):pas:max(bound));
    ylim([low_bound top_bound] );
    set(ax2, 'Box', 'off', 'TickLength', [0 0], 'XColor', 'black', 'YColor', 'black', ...
    'FontSize', 30, 'XTickLabel', labels, 'TickLabelInterpreter', 'latex');
end

end

    
