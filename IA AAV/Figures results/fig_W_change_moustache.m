function fig_W_change_moustache(p, s, tr)

% Créer les quintiles
V_SS = s.V.V ;
V_trans = tr.V(1).V ;
ss.CE = f_welfare_WE_target(p, s, V_SS, V_trans) ;
d = s.density.tot ; 
a = f_quantile_new4_moustache(p, 5, d, s, ss) ;
% Bounds
low_bound = min([a.quintile.disp.CE,a.type.disp.CE] , [], 'all') ;
top_bound = max([a.quintile.disp.CE,a.type.disp.CE] , [], 'all') ;
low_bound = floor(low_bound) ;
top_bound = ceil(top_bound) ;

%% Graphe welfare quintile vs living area

figure ;
set(gcf, 'color', 'w');
set(gcf,'units','centimeters') ; 
set(gcf,'Position',[5 5 50 30]) ;

subplot(121) ; 
aa = a.type.disp.CE ;
plot(aa(2,:), 'ko', 'MarkerFaceColor', 'r', 'MarkerSize', 8);
hold on ; plot([1:5; 1:5], aa([1,3],:), 'k-', 'LineWidth', 1.5); hold off
hold on ; plot([1:5; 1:5]+0.1*[-1;1], [aa(1,:);aa(1,:)], 'k-', 'LineWidth', 2);
hold on ; plot([1:5; 1:5]+0.1*[-1;1], [aa(3,:);aa(3,:)], 'k-', 'LineWidth', 2);
%legend('Quartile 1','Median','Quartile 3', 'interpreter','latex')
labels = p.region ;
xtickangle(45); xticks(1:numel(labels)); xticklabels(labels);    
ax2 = gca; title('a. By geographical location', 'interpreter','latex')  ;
axes

subplot(122) ; 
aa = a.quintile.disp.CE ;
plot(aa(2,:), 'ko', 'MarkerFaceColor', 'r', 'MarkerSize', 8);
hold on ; plot([1:5; 1:5], aa([1,3],:), 'k-', 'LineWidth', 1.5); hold off
hold on ; plot([1:5; 1:5]+0.1*[-1;1], [aa(1,:);aa(1,:)], 'k-', 'LineWidth', 2);
hold on ; plot([1:5; 1:5]+0.1*[-1;1], [aa(3,:);aa(3,:)], 'k-', 'LineWidth', 2);
labels = {'Q1', 'Q2', 'Q3', 'Q4', 'Q5'};
xtickangle(0); xticks(1:numel(labels)); xticklabels(labels);    
ax2 = gca; title('b. By disposable income', 'interpreter','latex')  ;
axes

% Axes
function axes
    ylabel('WE (\%)', 'interpreter','latex', 'FontSize', 30, 'Color', 'black');
    bound = [-34 -16] ; pas = 3 ;
    %ylim(bound); yticks(min(bound):pas:max(bound));
    ylim([low_bound top_bound] );
    set(ax2, 'Box', 'off', 'TickLength', [0 0], 'XColor', 'black', 'YColor', 'black', ...
    'FontSize', 30, 'XTickLabel', labels, 'TickLabelInterpreter', 'latex');
end

end

    
