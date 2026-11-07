function P = TetherParams()
% All assumptions live here. Change numbers here, nowhere else.
% Anything marked ASSUMPTION must be replaced with a sourced number or
% labelled as an assumption on your slides.

P.seed = 1;

% ---- City (synthetic suburban street grid) ----
P.gridN    = 14;          % 14 x 14 intersections
P.blockLen = 800;         % metres between intersections
P.speedLimit = 50/3.6;    % m/s (50 km/h)

% ---- Winter / physics model ----
P.muDry = 0.7;            % tyre-road friction, dry
P.muWet = 0.4;            % wet
P.muIce = 0.2;            % ice / packed snow
P.sightDist = 30;         % m, distance vehicle must be able to stop within (ASSUMPTION)
P.reactTime = 1.0;        % s, system reaction time (ASSUMPTION)

% ---- Demand (one weekday) ----
P.nRiders = 60;                   % scheduled riders per day (each = 2 trips)
P.errandLambda = 8;               % Poisson mean of extra pharmacy/grocery riders
P.clusterCenters = [7.0 9.0 11.0 13.5]*60;  % appointment peaks (min after midnight)
P.clusterSD = 20;                 % minutes
P.dialysisShare = 0.30;
P.dialysisDur = 240;              % minutes at clinic
P.otherDur = 60;

% ---- Service rules ----
P.dwell = 4;              % min: Trust Circle handoff at each end (door confirmed)
P.buffer = 10;            % min: planned arrival buffer before appointment
P.maxWaitReturn = 15;     % min: acceptable wait on return trips

% ---- Sweeps ----
P.fleetSweep = 2:2:24;
P.nReps = 10;             % random demand days averaged per point

% ---- Cost model (ASSUMPTIONS) ----
P.fixedCostPerVehDay = 120;   % $ per vehicle per day (depreciation, insurance, remote ops)
P.opCostPerHour = 12;         % $ per vehicle-hour in service (energy, maintenance)

% ---- Paratransit baseline (ASSUMPTIONS: replace with real, cited data) ----
P.para.bookingDays = 5;       % from your story: 5 days notice
P.para.costPerRide = 35;      % $ per trip, ASSUMPTION
P.para.onTimeRate  = 0.85;    % ASSUMPTION
P.tetherBookingDays = 1;      % booked via clinic/caregiver, ASSUMPTION
end
