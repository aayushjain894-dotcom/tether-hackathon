function v = safeSpeed(mu, P)
% Max speed (m/s) such that reaction distance + braking distance <= sight distance.
% Solves  v*tr + v^2/(2*mu*g) = ds  for v.
g  = 9.81;
a  = mu*g;
tr = P.reactTime;
ds = P.sightDist;
v  = a .* (-tr + sqrt(tr^2 + 2*ds./a));
end
