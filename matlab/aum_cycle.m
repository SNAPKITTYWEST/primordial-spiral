function [phase_seq, radial_rates, times] = aum_cycle(phase_duration, n_cycles, dt, ...
    expansion_A, transition_U, contraction_M, reset_silence)
% AUM_CYCLE Three-component + silence state machine.
% Symbolic phases A -> U -> M -> silence -> A mapped to radial rates.
% Not a claim about physical acoustics of the syllable.

if nargin < 1, phase_duration = 1.0; end
if nargin < 2, n_cycles = 2; end
if nargin < 3, dt = 0.05; end
if nargin < 4, expansion_A = 1.0; end
if nargin < 5, transition_U = 0.0; end
if nargin < 6, contraction_M = -1.0; end
if nargin < 7, reset_silence = 0.0; end

phases = {'A', 'U', 'M', 'silence'};
rates = [expansion_A, transition_U, contraction_M, reset_silence];

total_time = n_cycles * 4 * phase_duration;
n_steps = ceil(total_time / dt);

phase_seq = cell(1, n_steps);
radial_rates = zeros(1, n_steps);
times = zeros(1, n_steps);

phase_idx = 1;
elapsed = 0.0;
cycle_count = 0;

for i = 1:n_steps
    times(i) = (i - 1) * dt;
    phase_seq{i} = phases{phase_idx};
    radial_rates(i) = rates(phase_idx);

    elapsed = elapsed + dt;
    if elapsed >= phase_duration
        elapsed = elapsed - phase_duration;
        phase_idx = mod(phase_idx, 4) + 1;
        if phase_idx == 1
            cycle_count = cycle_count + 1;
        end
    end
end
end
