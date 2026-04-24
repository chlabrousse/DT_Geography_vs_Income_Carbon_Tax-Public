function fig_decompo_double_horizon(p, ss, tr0, tr1 , tr2)

T = p.T; tic

%% 0) Total transitions
% Compute expected utility, horizon 5
h = 5 ;
for k = 1:p.n ; U00(k,:) = f_test_V_trans(k, tr0, p, h) ; end
for k = 1:p.n ; U10(k,:) = f_test_V_trans(k, tr1, p, h) ; end
for k = 1:p.n ; U01(k,:) = f_test_V_trans(k, tr2, p, h) ; end

% Obtain the discounted sum of expected utility
B = p.beta.^( 0:(h-1) ) ;
V00 = cumsum(B.*U00,2) ;
V10 = cumsum(B.*U10,2) ;
V01 = cumsum(B.*U01,2) ;

% Compute consumption equivalent at horizon h
d = ss.density.tot ;
V_SS      = V00(:,h) ;
V_trans10 = V10(:,h) ;
V_trans01 = V01(:,h) ;
% WE at this horizon
x.WE1 = f_welfare_WE_target(p, ss, V_SS, V_trans10 ) ;
x.WE2 = f_welfare_WE_target(p, ss, V_SS, V_trans01 ) ;
Q_tot = f_quantile_new4_moustache(p, 5, d, ss, x) ;


%% 1) Partial transitions
list_var = ["w" , "tau_h", "p_N","R" , "p"] ;


% Transition avec une variable en moins
for i_var = 1:length(list_var)
    var = list_var(i_var) ;
    % TR1
    tr = tr1 ; V_trans = calcul(tr) ;
    WE1{i_var} = f_welfare_WE_target(p, ss, V_SS, V_trans ) ;

    % % TR2
    tr = tr2 ; V_trans = calcul(tr) ;
    WE2{i_var} = f_welfare_WE_target(p, ss, V_SS, V_trans ) ;
end

% Quintile
toc
for i_var = 1:length(list_var)
    var = list_var(i_var) ;
    a = "WE1_no_"+var ;
    x.(a) = WE1{i_var} ;
    a = "WE2_no_"+var ;
    x.(a) = WE2{i_var} ;
end
a = f_quantile_new2(p, 5, d, ss, x) ;
% Decompo par quintile
b = a.quintile ; 
A_q1 = b.WE1 - [b.WE1_no_w ; b.WE1_no_tau_h ; b.WE1_no_p_N ; b.WE1_no_R; b.WE1_no_p ] ;
A_q2 = b.WE2 - [b.WE2_no_w ; b.WE2_no_tau_h ; b.WE2_no_p_N ; b.WE2_no_R; b.WE2_no_p ] ;
ecart_q1 = sum(A_q1) - b.WE1 ;
ecart_q2 = sum(A_q2) - b.WE2 ;
% Decompo par type
b = a.type ; 
A_k1 = b.WE1 - [b.WE1_no_w ; b.WE1_no_tau_h ; b.WE1_no_p_N ; b.WE1_no_R; b.WE1_no_p ] ;
A_k2 = b.WE2 - [b.WE2_no_w ; b.WE2_no_tau_h ; b.WE2_no_p_N ; b.WE2_no_R; b.WE2_no_p ] ;
ecart_k1 = sum(A_k1) - b.WE1 ;
ecart_k2 = sum(A_k2) - b.WE2 ;


%% Graphe welfare quintile vs living area

figure ;
set(gcf, 'color', 'w');
set(gcf,'units','centimeters') ; 
set(gcf,'Position',[5 5 50 30]) ;

subplot(221)
bar(A_k1', 'stacked', 'EdgeColor', 'none', 'BarWidth', 0.8); 
hold on ; plot(a.type.WE1,'oblack','MarkerFaceColor', 'black','MarkerSize',16) ;hold off
legend('$w$','$\tau^H$','$p^N$','$R$','$p^H$','Total', 'interpreter','latex') ;  
labels = p.region ;
xtickangle(45); xticks(1:numel(labels)); xticklabels(labels);    
ax2 = gca; title('a. $\tau^h$, by geographical location', 'interpreter','latex')  ;
axes


subplot(222) ; 
bar(A_q1', 'stacked', 'EdgeColor', 'none', 'BarWidth', 0.8); 
hold on ; plot(a.quintile.WE1,'oblack','MarkerFaceColor', 'black','MarkerSize',16) ;hold off
legend('$w$','$\tau^H$','$p^N$','$R$','$p^H$','Total', 'interpreter','latex') ;  
labels = {'Q1', 'Q2', 'Q3', 'Q4', 'Q5'};
xtickangle(0); xticks(1:numel(labels)); xticklabels(labels);    
ax2 = gca; title('b. $\tau^h$, by disposable income', 'interpreter','latex')  ;
axes

subplot(223)
bar(A_k2', 'stacked', 'EdgeColor', 'none', 'BarWidth', 0.8); 
hold on ; plot(a.type.WE2,'oblack','MarkerFaceColor', 'black','MarkerSize',16) ;hold off
legend('$w$','$\tau^H$','$p^N$','$R$','$p^H$','Total', 'interpreter','latex') ;  
labels = p.region ;
xtickangle(45); xticks(1:numel(labels)); xticklabels(labels);    
ax2 = gca; title('c. $\tau^f$, by geographical location', 'interpreter','latex')  ;
axes


subplot(224) ; 
bar(A_q2', 'stacked', 'EdgeColor', 'none', 'BarWidth', 0.8); 
hold on ; plot(a.quintile.WE2,'oblack','MarkerFaceColor', 'black','MarkerSize',16) ;hold off
legend('$w$','$\tau^H$','$p^N$','$R$','$p^H$','Total', 'interpreter','latex') ;  
labels = {'Q1', 'Q2', 'Q3', 'Q4', 'Q5'};
xtickangle(0); xticks(1:numel(labels)); xticklabels(labels);    
ax2 = gca; title('d. $\tau^f$, by disposable income', 'interpreter','latex')  ;
axes


%% Axes
function axes
    ylabel('WE (\%)', 'interpreter','latex', 'FontSize', 30, 'Color', 'black');
    %ylim([-20 5]); % yticks(-4:1:-1);
    set(ax2, 'Box', 'off', 'TickLength', [0 0], 'XColor', 'black', 'YColor', 'black', ...
    'FontSize', 30, 'XTickLabel', labels, 'TickLabelInterpreter', 'latex');
end

function V_trans = calcul(tr)
    tr.(var) = ss.(var).*ones(1, T) ;
    for t=T-1:-1:1 ;  tr = TRANS_backward(p, t, tr)  ;  end
    for k = 1:p.n ; U(k,:) = f_test_V_trans(k, tr, p, h) ; end
    V = cumsum(B.*U,2) ;
    V_trans = V(:,h) ;
end


end

    
