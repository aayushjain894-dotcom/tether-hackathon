function out = sensorWeek(city, P, nDays)
% Fleet-as-community-sensor: random road hazards, detected when a vehicle
% drives over that road segment. Shows weekly coverage as a heatmap.
[~, Gt] = buildTravelTimes(city, P, 'ice');
E = city.G.Edges; nE = height(E);
rng(P.seed + 100);
hazard = randperm(nE, 25)';
counts = zeros(nE,1);
detDay = zeros(1,nDays);
for d = 1:nDays
    req = generateDemand(city, P, P.seed + 200 + d);
    for i = 1:numel(req.origin)
        p = shortestpath(Gt, req.origin(i), req.dest(i));
        idx = findedge(city.G, p(1:end-1), p(2:end));
        counts(idx) = counts(idx) + 1;
    end
    detDay(d) = mean(counts(hazard) > 0);
end
figure('Name','Fleet as community sensor','Color','w');
subplot(1,2,1);
plot(city.G, 'XData', city.X, 'YData', city.Y, 'EdgeCData', counts, ...
    'LineWidth', 2, 'NodeColor','k', 'MarkerSize', 2, 'NodeLabel', {});
hold on
hx = [city.X(E.EndNodes(hazard,1)) city.X(E.EndNodes(hazard,2))]';
hy = [city.Y(E.EndNodes(hazard,1)) city.Y(E.EndNodes(hazard,2))]';
plot(hx, hy, 'r-', 'LineWidth', 4);   % hazards drawn on top in red
colormap(parula); colorbar; axis equal off
title('Weekly vehicle passes per road (red = hazards)');
subplot(1,2,2);
plot(1:nDays, 100*detDay, '-o','LineWidth',1.5); grid on; ylim([0 100]);
xlabel('Day'); ylabel('% hazards detected');
title('Cumulative hazard detection');
out.detectedPct = 100*detDay;
end
