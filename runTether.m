%% TETHER - main script. Run this file (press Run, or type runTether).
clear; clc; close all;
P = TetherParams();
city = buildCity(P);
fprintf('Tether: %d intersections, %d road segments\n', numnodes(city.G), numedges(city.G));

%% 1. Winter physics model
plotWinterModel(P);

%% 2. Street network coloured by winter risk
figure('Name','City','Color','w');
h = plot(city.G, 'XData', city.X, 'YData', city.Y, 'EdgeCData', city.G.Edges.Risk, ...
    'LineWidth', 2, 'NodeColor','k', 'MarkerSize', 2, 'NodeLabel', {});
highlight(h, city.clinics, 'NodeColor','r', 'MarkerSize', 9);
colormap(flipud(hot)); colorbar; axis equal off
title('Street network: winter risk per road (red nodes = clinics)');

%% 3. One day of scheduled demand
req = generateDemand(city, P, P.seed);
figure('Name','Demand','Color','w');
histogram(req.appt(req.type==1)/60, 0:0.5:18);
grid on; xlabel('Appointment time (hour of day)'); ylabel('Rides');
title(sprintf('Appointment demand: %d riders, %d trips', numel(req.origin)/2, numel(req.origin)));

%% 4. HERO GRAPH: on-time rate vs fleet size, dry vs winter
S = sweepFleet(city, P, {'dry','ice'});
figure('Name','HERO: on-time vs fleet','Color','w'); hold on
plot(S.fleet, 100*S.dry.onTime, '-o', 'LineWidth', 2);
plot(S.fleet, 100*S.ice.onTime, '-s', 'LineWidth', 2);
plot([S.fleet(1) S.fleet(end)], [90 90], 'k--');
grid on; ylim([0 105]);
xlabel('Fleet size (vehicles)'); ylabel('On-time arrival (%)');
legend('Dry','Winter (ice)','90% target','Location','southeast');
title('Tether: the winter penalty and how many vehicles fix it');

iDry = find(S.dry.onTime >= 0.9, 1);
iIce = find(S.ice.onTime >= 0.9, 1);
if isempty(iDry), iDry = numel(S.fleet); end
if isempty(iIce), iIce = numel(S.fleet); end
fprintf('\nVehicles for 90%% on-time:  dry = %d,  winter = %d  (+%d for winter)\n', ...
    S.fleet(iDry), S.fleet(iIce), S.fleet(iIce)-S.fleet(iDry));

%% 5. Cost and wait vs fleet size (winter)
figure('Name','Cost vs wait','Color','w');
yyaxis left;  plot(S.fleet, S.ice.avgWait, '-o','LineWidth',1.5); ylabel('Avg pickup delay (min)');
yyaxis right; plot(S.fleet, S.ice.cost, '-s','LineWidth',1.5);    ylabel('Cost per ride ($)');
grid on; xlabel('Fleet size'); title('Winter: delay vs cost per ride');

%% 6. Trust Circle handoff: how slow handoffs eat fleet capacity
H = handoffSweep(city, P, 'ice', 0:2:12, 0.9);
figure('Name','Handoff','Color','w');
plot(H.dwell, H.fleetNeeded, '-o','LineWidth',2); grid on
xlabel('Handoff time at each end (min)'); ylabel('Vehicles for 90% on-time (winter)');
title('Cost of the confirmed handoff');
trustCircleDemo(P);

%% 7. Fleet as community sensor (one week)
sensorWeek(city, P, 7);

%% 8. Tether vs paratransit (ASSUMPTION-based baseline; see TetherParams)
tetherCost = S.ice.cost(iIce);
tetherOnTime = 100*S.ice.onTime(iIce);
figure('Name','vs Paratransit','Color','w');
subplot(1,3,1); bar([P.para.bookingDays P.tetherBookingDays]);
set(gca,'XTickLabel',{'Paratransit','Tether'}); ylabel('Days notice to book'); title('Booking lead time'); grid on
subplot(1,3,2); bar([P.para.costPerRide tetherCost]);
set(gca,'XTickLabel',{'Paratransit','Tether'}); ylabel('$ per ride'); title('Cost per ride'); grid on
subplot(1,3,3); bar([100*P.para.onTimeRate tetherOnTime]);
set(gca,'XTickLabel',{'Paratransit','Tether'}); ylabel('On-time (%)'); title('On-time rate (winter)'); ylim([0 105]); grid on

fprintf('\n=== SUMMARY (winter, %d vehicles) ===\n', S.fleet(iIce));
fprintf('On-time: %.1f%% | Cost/ride: $%.2f | Avg pickup delay: %.1f min\n', ...
    tetherOnTime, tetherCost, S.ice.avgWait(iIce));
fprintf('Paratransit baseline numbers are ASSUMPTIONS - replace with cited data.\n');
