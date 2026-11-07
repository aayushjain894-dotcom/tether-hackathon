function plotWinterModel(P)
mu = [P.muDry P.muWet P.muIce];
names = {'Dry','Wet','Ice'};
g = 9.81; v = 0:0.5:20;
figure('Name','Winter model','Color','w');
subplot(1,2,1); hold on
for i = 1:3
    plot(v*3.6, v.^2./(2*mu(i)*g), 'LineWidth', 1.5);
end
grid on; legend(names,'Location','northwest');
xlabel('Speed (km/h)'); ylabel('Braking distance (m)');
title('Why Tether slows down in winter');

subplot(1,2,2);
vs = min(safeSpeed(mu,P), P.speedLimit)*3.6;
bar(vs); set(gca,'XTickLabel',names); grid on
ylabel('Max safe speed (km/h)');
title(sprintf('Safe speed (stop within %d m)', P.sightDist));
for i = 1:3
    text(i, vs(i)+1, sprintf('%.0f', vs(i)), 'HorizontalAlignment','center');
end
end
