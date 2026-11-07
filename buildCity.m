function city = buildCity(P)
% Synthetic street grid with elevation, slope and winter-risk per edge.
rng(P.seed);
n = P.gridN;
[X, Y] = meshgrid((0:n-1)*P.blockLen);
X = X(:); Y = Y(:);
id = reshape(1:n^2, n, n);

s = [reshape(id(:,1:end-1),[],1); reshape(id(1:end-1,:),[],1)];
t = [reshape(id(:,2:end),[],1);   reshape(id(2:end,:),[],1)];

% Rolling hills
Z = 60*sin(X/2500) + 50*cos(Y/2000) + 30*sin((X+Y)/1800);

len   = hypot(X(s)-X(t), Y(s)-Y(t));
slope = abs(Z(s)-Z(t)) ./ len;
riskBase = min(1, slope/0.04);
risk = min(1, 0.6*riskBase + 0.4*rand(size(len)));
unplowed = rand(size(len)) < 0.08;      % random unplowed segments
risk(unplowed) = 1;

E = table([s t], len, slope, risk, 'VariableNames', ...
    {'EndNodes','Weight','Slope','Risk'});
city.G = graph(E);
city.X = X; city.Y = Y; city.Z = Z; city.n = n;

c0 = round(n/2);
city.depot   = id(c0,c0);
city.clinics = [id(c0,c0); id(c0-2,c0+2); id(c0+2,c0-2)];
[r, c] = ind2sub([n n], (1:n^2)');
city.homeNodes = find(max(abs(r-c0), abs(c-c0)) >= 4);   % outer suburbs
end
