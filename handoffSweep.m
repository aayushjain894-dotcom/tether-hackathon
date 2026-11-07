function out = handoffSweep(city, P, cond, dwellList, targetRate)
% How many vehicles are needed to hit targetRate on-time as the Trust
% Circle handoff gets slower?
T = buildTravelTimes(city, P, cond);
reqs = cell(P.nReps,1);
for r = 1:P.nReps
    reqs{r} = generateDemand(city, P, P.seed + r);
end
needed = nan(size(dwellList));
for d = 1:numel(dwellList)
    P2 = P; P2.dwell = dwellList(d);
    for f = 1:numel(P.fleetSweep)
        ot = zeros(P.nReps,1);
        for r = 1:P.nReps
            R = runTetherSim(P.fleetSweep(f), T, reqs{r}, P2, city.depot);
            ot(r) = R.onTimeRate;
        end
        if mean(ot) >= targetRate
            needed(d) = P.fleetSweep(f);
            break
        end
    end
end
out.dwell = dwellList;
out.fleetNeeded = needed;
end
