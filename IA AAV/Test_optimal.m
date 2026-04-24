%% data
ss = s_opti(1);
d = ss.density.tot;

HtM = sum(ss.density.tot(p.s(:,1) <.001)).*100;

%%
for t=1:p.T-1
    HtM_G(t) = sum(tr11G_10.density(p.s(:,1) <.001,t)).*100;
    HtM_uni(t) = sum(tr11T_uni_10.density(p.s(:,1) <.001,t)).*100;
    HtM_inc(t) = sum(tr11T_inc_10.density(p.s(:,1) <.001,t)).*100;
    HtM_geo(t) = sum(tr11T_geo_10.density(p.s(:,1) <.001,t)).*100;
end 

%%
figure
set(gcf, 'color', 'w');
plot([HtM_G;HtM_uni;HtM_inc;HtM_geo]', 'LineWidth',5)
title('Share of HtM', 'interpreter','latex', 'FontSize', 30)
xlabel('Years ', 'interpreter','latex', 'FontSize', 30, 'Color', 'black');
ylabel('Share (\%)', 'interpreter','latex', 'FontSize', 30, 'Color', 'black');
ax2 = gca; set(ax2, 'Box', 'off', 'TickLength', [0 0], 'XColor', 'black', 'YColor', 'black', ...
        'FontSize', 30, 'TickLabelInterpreter', 'latex');
legend({'\ G','\ Uniform','\ Income only','\ Income X Geo'}, 'interpreter','latex', 'FontSize', 40, 'Box','off')



%%
V_SS      = ss.V.V ;
V_trans_G = tr11G_10.V(1).V ;
V_trans_inc = tr11T_inc_10.V(1).V ;
V_trans_geo = tr11T_geo_10.V(1).V ;

% WE 
WE_G = f_welfare_WE_target(p, ss, V_SS, V_trans_G ) ;
WE_inc = f_welfare_WE_target(p, ss, V_SS, V_trans_inc ) ;
WE_geo = f_welfare_WE_target(p, ss, V_SS, V_trans_geo ) ;

% variances
var_G = sum(d .* (WE_G - d'*WE_G).^2)/(d'*WE_G).^2;
var_inc = sum(d .* (WE_inc - d'*WE_inc).^2)/(d'*WE_inc).^2;
var_geo = sum(d .* (WE_geo - d'*WE_geo).^2)/(d'*WE_geo).^2;

% variance for k
for k=1:p.nk
    area = (500*(k-1)+1):500*k;
    var_G_k(k) = sum(d(area) .* (WE_G(area) - d(area)'*WE_G(area)).^2)/(d(area)'*WE_G(area)).^2;
    var_inc_k(k) = sum(d(area) .* (WE_inc(area) - d(area)'*WE_inc(area)).^2)/(d(area)'*WE_inc(area)).^2;
    var_geo_k(k) = sum(d(area) .* (WE_geo(area) - d(area)'*WE_geo(area)).^2)/(d(area)'*WE_geo(area)).^2;
end

