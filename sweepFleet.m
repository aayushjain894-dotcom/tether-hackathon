function S = sweepFleet(city, P, conds)
% Sweep fleet size for each road condition, averaged over P.nReps demand days.
reqs = cell(P.nReps,1);
for r = 1:P.nReps
    reqs{r} = generateDemand(city, P, P.seed + r);
end
nF = numel(P.fleetSweep);
S.fleet = P.fleetSweep;
for c = 1:numel(conds)
    T = buildTravelTimes(city, P, conds{c});
    ot = zeros(nF,1); wt = ot; cs = ot;
    for f = 1:nF
        a = zeros(P.nReps,1); b = a; d = a;
        for r = 1:P.nReps
            R = runTetherSim(P.fleetSweep(f), T, reqs{r}, P, city.depot);
            a(r) = R.onTimeRate; b(r) = R.avgWait; d(r) = R.costPerRide;
        end
        ot(f) = mean(a); wt(f) = mean(b); cs(f) = mean(d);
    end
    S.(conds{c}).onTime = ot';
    S.(conds{c}).avgWait = wt';
    S.(conds{c}).cost = cs';
end
end
