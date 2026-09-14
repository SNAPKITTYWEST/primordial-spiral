function [state_seq, global_scale, times] = cosmology_cycle(n_steps, dt)
% COSMOLOGY_CYCLE Seven-state cyclical cosmology FSM.
% TRADITIONAL/SYMBOLIC -> MATHEMATICAL MODEL.
% States: CREATION -> EXPANSION -> MANIFESTATION -> MAXIMUM_SCALE
%         -> CONTRACTION -> DISSOLUTION -> UNMANIFEST -> CREATION

if nargin < 1, n_steps = 500; end
if nargin < 2, dt = 0.05; end

states = {'CREATION', 'EXPANSION', 'MANIFESTATION', 'MAXIMUM_SCALE', ...
          'CONTRACTION', 'DISSOLUTION', 'UNMANIFEST'};
radial_scalings = [0.2, 1.0, 0.5, 0.0, -0.8, -0.5, 0.0];
dwell_times = [1.0, 2.0, 2.0, 1.0, 2.0, 1.5, 1.0];
next_indices = [2, 3, 4, 5, 6, 7, 1];

state_seq = cell(1, n_steps);
global_scale = zeros(1, n_steps);
times = zeros(1, n_steps);

current_idx = 1;
elapsed = 0.0;
g_scale = 1.0;

for i = 1:n_steps
    times(i) = (i - 1) * dt;
    state_seq{i} = states{current_idx};
    global_scale(i) = g_scale;

    g_scale = g_scale * (1.0 + radial_scalings(current_idx) * dt * 0.01);
    elapsed = elapsed + dt;

    if elapsed >= dwell_times(current_idx)
        elapsed = 0.0;
        next_idx = next_indices(current_idx);
        if next_idx == 1 && current_idx == 7
            g_scale = 1.0;
        end
        current_idx = next_idx;
    end
end
end
