function req = generateDemand(city, P, seed)
% One weekday of scheduled trips. Each rider has an outbound trip (home ->
% clinic, must arrive by appointment) and a return trip (clinic -> home).
rng(seed);
nExtra = poissSample(P.errandLambda);
nR = P.nRiders + nExtra;

isDial = [rand(P.nRiders,1) < P.dialysisShare; false(nExtra,1)];
home   = city.homeNodes(randi(numel(city.homeNodes), nR, 1));
clinic = city.clinics(randi(numel(city.clinics), nR, 1));

center = P.clusterCenters(randi(numel(P.clusterCenters), nR, 1));
appt = center(:) + P.clusterSD*randn(nR,1);
shifts = [7*60; 12*60];
dialAppt = shifts(randi(2, nR, 1)) + 10*randn(nR,1);
appt(isDial) = dialAppt(isDial);
appt(P.nRiders+1:end) = 540 + 420*rand(nExtra,1);     % errands 9:00-16:00
appt = round(max(appt, 120));

dur = P.otherDur*ones(nR,1);
dur(isDial) = P.dialysisDur;
dur(P.nRiders+1:end) = 45;

req.origin = [home; clinic];
req.dest   = [clinic; home];
req.type   = [ones(nR,1); 2*ones(nR,1)];     % 1 outbound, 2 return
req.ready  = [appt-90; appt+dur];            % earliest pickup (min)
req.appt   = [appt; nan(nR,1)];
req.isDialysis = [isDial; isDial];
end

function n = poissSample(lambda)
% Knuth Poisson sampler (so no Statistics Toolbox is needed)
L = exp(-lambda); k = 0; p = 1;
while p > L
    k = k + 1; p = p*rand;
end
n = k - 1;
end
