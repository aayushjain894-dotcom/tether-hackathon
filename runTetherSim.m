function R = runTetherSim(nVeh, T, req, P, depot)
% Scheduled dispatch with greedy insertion: process trips in order of
% target pickup time, give each to the vehicle that can start it earliest
% (least delay). Handoff dwell (Trust Circle) is applied at both ends.
N = numel(req.origin);
direct = zeros(N,1);
for i = 1:N
    direct(i) = T(req.origin(i), req.dest(i));
end

isOut = req.type == 1;
target   = req.ready;
deadline = zeros(N,1);
target(isOut)   = max(req.ready(isOut), req.appt(isOut) - direct(isOut) - P.buffer - P.dwell);
deadline(isOut) = req.appt(isOut);                       % must arrive by appointment
deadline(~isOut) = req.ready(~isOut) + P.maxWaitReturn + P.dwell + direct(~isOut);

[~, order] = sort(target);
vehNode = depot*ones(nVeh,1);
vehFree = zeros(nVeh,1);
busy    = zeros(nVeh,1);
pick = zeros(N,1); arrive = zeros(N,1);

for k = 1:N
    i = order(k);
    dead  = T(vehNode, req.origin(i));          % deadhead time per vehicle
    start = max(vehFree + dead, target(i));
    [~, v] = min(start + 1e-3*dead);
    pick(i)   = start(v);
    arrive(i) = pick(i) + P.dwell + direct(i);
    busy(v)   = busy(v) + dead(v) + 2*P.dwell + direct(i);
    vehFree(v) = arrive(i) + P.dwell;           % waits for handoff confirmation
    vehNode(v) = req.dest(i);
end

wait   = max(0, pick - target);
onTime = arrive <= deadline + 1e-9;
ws = sort(wait);

R.onTimeRate = mean(onTime);
R.avgWait    = mean(wait);
R.p90Wait    = ws(ceil(0.9*N));
R.costPerRide = (nVeh*P.fixedCostPerVehDay + sum(busy)/60*P.opCostPerHour) / N;
end
