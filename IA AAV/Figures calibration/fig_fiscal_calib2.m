function fig_fiscal_calib2(p, s)

% Créer les quintiles
d = s.density.tot ; 
a = f_quantile_new2(p, 5, d, s) ;
q = a.quintile ;
labels = {'Q1', 'Q2', 'Q3', 'Q4', 'Q5'};  
grey = [64, 64, 64]/255;


%% A. Income composition

figure; 
set(gcf,'units','centimeters') ; 
set(gcf,'Position',[5 5 50 30]) ;

    subplot(221)
    revenu_model = [q.NLI ; q.NFI ; q.T] ;
    share_revenu = revenu_model./sum(revenu_model) ;
    LI_data = [45;54;63;65;62]/100 ;
    T_data  = [47;33;22;16;5]/100 ;
    FI_data = 1 - LI_data - T_data  ;
    area(share_revenu') ; 
    hold on ; plot(LI_data,'--black', 'linewidth', 6) ; hold off
    hold on ; plot(LI_data+FI_data,'--', 'color', grey, 'linewidth', 6) ; hold off
    title('a. Income composition','FontSize',30 , 'Interpreter', 'latex'); 
    legend({'\ Net labor income', '\ Net financial income','\ Transfers','\ Data'},'FontSize',25, 'Interpreter', 'latex', 'Location','southeast');
    xticklabels(labels); xticks(1:5);
    ylim([0,1]) ; yticks(0:.2:1);
    ax2 = gca; ax2.FontSize = 30; ax2.XColor = 'black'; ax2.YColor = 'black';
    set(ax2, 'XTickLabel', labels, 'TickLabelInterpreter', 'latex'); 
    ax2.Box = 'off'; % Enleve l'encadrement noir
    
    
%% b. Taxes by income
subplot(222)
    pib_par_habitant = 35000 ;
    ratio = pib_par_habitant/s.y/1000 ;
    orange = [0.9290 0.6940 0.1250] ;
    red = [0.8500 0.3250 0.0980];
    blue =  [0 0.4470 0.7410];    
    VAT = p.VAT*(q.c + s.p_N*q.Nh + s.p_F*q.Fh) ;
    FIT = p.tax_capital.*s.R.*q.ap ;
    LIT = q.LT ;
    data = [5.225 , 7.265 , 9.835, 13.295 , 32.385 ] ; % DATA INSEE 2018
    ba = bar( ratio*[VAT ; LIT ; FIT  ]','stacked' ,'EdgeColor', 'none', 'BarWidth', 0.8, 'FaceColor','flat') ;
    ba(1).CData = orange ; ba(2).CData = blue ; ba(3).CData = red ; 
    hold on ; plot(data,'oblack','MarkerFaceColor', 'black','MarkerSize',16) ; hold off
    title('b. Taxes by income','FontSize',30 , 'Interpreter', 'latex'); 
    legend({'\ Consumption tax', '\ Labor income tax','\ Capital income tax','\ Data'},'FontSize',25, 'Interpreter', 'latex', 'Location','southeast', 'Box', 'off');
    xticklabels(labels); set(gcf, 'color', 'w')  
    ylabel('Thousands of Euros', 'interpreter','latex', 'FontSize', 30, 'Color', 'black');
    set(gcf, 'color', 'w'); 
    ax2 = gca; ax2.FontSize = 30; ax2.XColor = 'black'; ax2.YColor = 'black';
    set(ax2, 'XTickLabel', labels, 'TickLabelInterpreter', 'latex'); 
    ax2.Box = 'off'; % Enleve l'encadrement noir


end