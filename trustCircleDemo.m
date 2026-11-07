function trustCircleDemo(P)
% Handoff state machine: Arrived -> Waiting -> Confirmed -> Released.
% The vehicle is only released once a trusted person confirms the handoff.
states = {'Arrived','Waiting','Confirmed','Released'};
msgs   = {'Vehicle at door; Trust Circle notified', ...
          'Waiting for caregiver / clinic confirmation', ...
          '"Mom is at the clinic door" confirmed', ...
          'Vehicle free for next ride'};
times = [0 0.5 P.dwell P.dwell+0.25];
fprintf('\n--- Trust Circle handoff ---\n');
for i = 1:4
    fprintf('t=%5.2f min | %-9s | %s\n', times(i), states{i}, msgs{i});
end
end
