
%% Obtain expected utility during transition

if 1 == 0
    % Compute transition without any shock
    tr00G = TRANS1_triple(p, tr_shock(1), s(1), s(1), 1) ;
    % For each transition (00, 10, 01), compute expected utility
    parfor k = 1:p.n ; U00(k,:) = f_test_V_trans(k, tr00G, p, p.T-1) ; end
    parfor k = 1:p.n ; U10(k,:) = f_test_V_trans(k, tr10G, p, p.T-1) ; end
    parfor k = 1:p.n ; U01(k,:) = f_test_V_trans(k, tr01G, p, p.T-1) ; end
    UU.U00 = U00 ; UU.U10 = U10 ; UU.U01 = U01 ;
    save('Save/UU', 'UU'); 
end


%% Obtain the discounted sum of expected utility

load("UU")
B = p.beta.^( 0:(p.T-2) ) ;
V00 = cumsum(B.*UU.U00,2) ;
V10 = cumsum(B.*UU.U10,2) ;
V01 = cumsum(B.*UU.U01,2) ;


%% Compute consumption equivalent at different horizons

ss = s(1) ; d = ss.density.tot ;
horizon = [5 20 99] ;
for h = horizon
    % Sum discounted expected utility at this horizon 
    V_SS      = V00(:,h) ;
    V_trans10 = V10(:,h) ;
    V_trans01 = V01(:,h) ;
    % WE at this horizon
    WE10(:,h) = f_welfare_WE_target(p, ss, V_SS, V_trans10 ) ;
    WE01(:,h) = f_welfare_WE_target(p, ss, V_SS, V_trans01 ) ;
    % Distribution of WE
    x.WE10 = WE10(:,h) ;
    x.WE01 = WE01(:,h) ;
    Q(h) = f_quantile_new4_moustache(p, 5, d, ss, x) ;
end


% Plot mean WE at horizon h
if 1 == 0
    figure; h = 99 ; 
    subplot(221) ; bar(Q(h).type.WE10) ; title('tauH geo') ;
    subplot(222) ; bar(Q(h).quintile.WE10) ; title('tauH income') ;
    subplot(223) ; bar(Q(h).type.WE01) ; title('tauF geo') ;
    subplot(224) ; bar(Q(h).quintile.WE01) ; title('tauF income') ;
end
% Plot moustache box at horizon h
if 1 == 0
    figure; h = 5 ; 
    subplot(221) ; plot(Q(h).type.disp.WE10') ; title('tauH geo') ;
    subplot(222) ; plot(Q(h).quintile.disp.WE10') ; title('tauH income') ;
    subplot(223) ; plot(Q(h).type.disp.WE01') ; title('tauF geo') ;
    subplot(224) ; plot(Q(h).quintile.disp.WE01') ; title('tauF income') ;
end
% Plot for Region x Quintile
if 1 == 0
    figure; h = 99 ; 
    subplot(211) ; plot(Q(h).cross.WE10,'linewidth',4) ; title('tauH ') ; legend(p.region) ; 
    labels = {'Q1', 'Q2', 'Q3', 'Q4', 'Q5'};
    xtickangle(0); xticks(1:numel(labels)); xticklabels(labels);    
    subplot(212) ; plot(Q(h).cross.WE01,'linewidth',4) ; title('tauF ') ; legend(p.region) ;
    xtickangle(0); xticks(1:numel(labels)); xticklabels(labels); 
end
% Comparison different horizons
if 1 == 1
    fig_compare_horizon(p, Q)
end

%%
fig_compare_horizon2(p, Q)


%%
clear Q








