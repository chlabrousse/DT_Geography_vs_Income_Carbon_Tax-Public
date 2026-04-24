

%% 1) Welfare (WE) income x geography
QQ = fig_W_cross_double(p, s(1), tr10G, tr01G);
%QQ2 = fig_W_cross_double(p, s_opti(1), tr10G, tr11G_10);

fig_W_cross_double2(p, s_opti(1),tr11T_uni_10,tr11T_geo_10)

fig_W_change_moustache2(p, s_opti(1),tr11T_uni_10,tr11T_inc_10,tr11T_geo_10)


%% 2) Boxplot Welfare of a transition
i = 3 ; if i == 2 ; TR = tr10G ; elseif i == 3 ; TR = tr01G ; end
fig_W_change_moustache(p, s(1), TR)


%% 3) Density change between two SS, income x geo
fig_density_change(p,s(1),s(2), s(3))


%% 4) Decomposition of tauH/tauF
% Infinite horizon
fig_decompo_double2(p, s(1), tr10G, tr01G)
% Finite horizon
fig_decompo_double_horizon(p, s(1), tr00G, tr10G , tr01G)


%% Compare recycling scenarios
% Compute Welfare (WE)
ss = s_opti(1) ; V_SS = ss.V.V ;
x.WE_G   = f_welfare_WE_target(p, ss, V_SS, tr11G.V(1).V) ;
x.WE_uni = f_welfare_WE_target(p, ss, V_SS, tr11T_uni_10.V(1).V) ;
%x.WE_inc = f_welfare_WE_target(p, ss, V_SS, tr11T_inc_10.V(1).V) ;
x.WE_geo = f_welfare_WE_target(p, ss, V_SS, tr11T_geo_10.V(1).V) ;
d = ss.density.tot ; 
a = f_quantile_new4_moustache(p, 5, d, ss, x) ;
Mean = (d'*[x.WE_G,x.WE_uni,x.WE_geo])' ;
% plot([x.WE_uni,x.WE_inc,x.WE_geo],'linewidth',3)

% Table
for i=1:5
    % Average welfare
    A = a.quintile ; B = a.type ; 
    Q(:,i) = [A.WE_G(i);A.WE_uni(i);A.WE_inc(i);A.WE_geo(i)] ;
    K(:,i) = [B.WE_G(i);B.WE_uni(i);B.WE_inc(i);B.WE_geo(i)] ;
end
Q1 = Q(:,1); Q2 = Q(:,2); Q3 = Q(:,3); Q4 = Q(:,4); Q5 = Q(:,5); 
Rural = K(:,1); Small = K(:,2); Medium = K(:,3); Large = K(:,4); Paris = K(:,5); 
Scenario = ["G";"T uniform";"T income";"T geo"];
Quintile = table(Scenario,Q1,Q2,Q3,Q4,Q5,Mean) ; 
Type = table(Scenario,Rural,Small,Medium,Large,Paris,Mean) ;
disp(' ') ; 
disp('Average welfare by quintile:') ; disp(Quintile) ; disp(' ') ; 
disp('Average welfare by region:') ; disp(Type) ; disp(' ') ; 

% Histograms
k=1:1000;
leg = {'\ Income $\times$ Geography','\ Income','\ Uniform' } ;
histogram_trans3(d(k), x.WE_geo(k), x.WE_inc(k),x.WE_uni(k), 0, leg)


% Share of loser and median welfare
for iS = 1:4
    % Share of losers
    if     iS==1 ; WE = x.WE_G   ; elseif iS==2 ; WE = x.WE_uni ;
    elseif iS==3 ; WE = x.WE_inc ; elseif iS==4 ; WE = x.WE_geo ; end
    losers(iS,:) = 100*sum(reshape(d.*(WE<=0),500,5))./ss.density.k ;
    % Median welfare, total
    X = sortrows([WE,d],1) ; 
    iM = find(cumsum(X(:,2))>=0.5,1) ; 
    med(iS,1) = X(iM,1) ;
    % Median welfare by city, alternative
    dR1 = reshape(d,500,5) ; dR2 = dR1./ss.density.k ;
    WER = reshape(WE,500,5) ;
    for ik=1:5
        X = sortrows([WER(:,ik),dR2(:,ik)],1) ; 
        iM = find(cumsum(X(:,2))>=0.5,1) ; 
        med_k(iS,ik) = X(iM,1) ;
    end
    % Share losers by quintile
    TI  = ss.NLI + (1-p.tax_capital).*ss.R.*p.s(:,1) + ss.Transfer_type ;
    X = sortrows([TI,d,WE],1) ; d2 = cumsum(X(:,2)) ;
    lQ = [0 0.2 0.4 0.6 0.8 1] ;
    for iq = 1:5
        inq_Q = ( d2>=lQ(iq) & d2<=lQ(iq+1) ) ; 
        losers_Q(iS,iq) = 100*d(inq_Q)'*( X(inq_Q,3)<0 )/sum(d(inq_Q)) ;
    end
end
disp('Median welfare, total population:') ; disp(med) ; disp(' ') ; 
disp('Median welfare by city (Rural/Small/Medium/Large/Paris):') ; disp(med_k) ; disp(' ') ;  
disp('Share losers by city (Rural/Small/Medium/Large/Paris):') ; disp(losers) ; disp(' ') ; 
disp('Share losers by quintile (Q1/Q2/Q3/Q4/Q5):') ; disp(losers_Q) ; disp(' ') ; 


%% Graph Cédric
fig_density_change_transition(p, s(1), tr10G)
fig_density_change_transition(p, s(1), tr01G)

fig_density_change_transition2(p, s(1), tr10G, tr01G)
fig_density_change_transition3(p, s(1), tr10G, tr01G)


fig_density_change_transition(p, s(1), tr11T_uni_10)
fig_density_change_transition(p, s(1), tr11T_geo_10)
fig_density_change_transition2(p, s(1), tr11T_uni_10, tr11T_geo_10)
fig_density_change_transition3(p, s(1), tr11T_uni_10, tr11T_geo_10)
