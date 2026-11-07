function [T, Gt, v] = buildTravelTimes(city, P, cond)
% Travel-time matrix T (minutes) between all nodes for a road condition.
% cond: 'dry' | 'wet' | 'ice'
E = city.G.Edges;
len = E.Weight; risk = E.Risk;
switch cond
    case 'dry', mu0 = P.muDry; rf = 0;
    case 'wet', mu0 = P.muWet; rf = 0.2;
    case 'ice', mu0 = P.muIce; rf = 0.5;
    otherwise,  error('Unknown condition: %s', cond);
end
mu = max(mu0*(1 - rf*risk), 0.08);       % risky edges are slipperier
v  = min(safeSpeed(mu, P), P.speedLimit);
w  = (len ./ v) / 60;                    % minutes per edge
if strcmp(cond,'ice')
    bad = risk > 0.85;                   % routing avoids steep/unplowed edges
    w(bad) = 3*w(bad);
end
Gt = graph(E.EndNodes(:,1), E.EndNodes(:,2), w);
T  = distances(Gt);
end
