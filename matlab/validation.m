% VALIDATION Independent MATLAB reconstruction and error comparison.
% Loads Dylan-exported reference data and computes error metrics.

fprintf('=== Primordial Spiral Validation ===\n\n');

% 1. Spiral geometry comparison
[theta, r, x, y] = primordial_spiral(1.0, 0.15, 0, 4*pi, 200, 0, 1.0);
fprintf('Spiral: %d points, r range [%.4f, %.4f]\n', length(theta), min(r), max(r));

% Growth ratio invariant: r(theta+delta)/r(theta) = exp(b*delta)
b = 0.15;
delta = 0.5;
expected_ratio = exp(b * delta);
ratios = r(2:end) ./ r(1:end-1);
dtheta_actual = diff(theta);
expected_local = exp(b * dtheta_actual);
ratio_err = abs(ratios - expected_local) ./ expected_local;
fprintf('Growth-ratio max relative error: %.3e\n', max(ratio_err));
fprintf('Growth-ratio mean relative error: %.3e\n', mean(ratio_err));

% 2. Spanda waveform verification
[t_s, S_sine] = spanda_model(1.0, 1.0, 0, 0, 0, 'sine');
[~, S_sq] = spanda_model(1.0, 1.0, 0, 0, 0, 'square');
[~, S_tri] = spanda_model(1.0, 1.0, 0, 0, 0, 'triangle');
[~, S_saw] = spanda_model(1.0, 1.0, 0, 0, 0, 'saw');
fprintf('Spanda sine range: [%.4f, %.4f]\n', min(S_sine), max(S_sine));
fprintf('Spanda square range: [%.4f, %.4f]\n', min(S_sq), max(S_sq));
fprintf('Spanda triangle range: [%.4f, %.4f]\n', min(S_tri), max(S_tri));
fprintf('Spanda saw range: [%.4f, %.4f]\n', min(S_saw), max(S_saw));

% 3. AUM cycle verification
[phase_seq, rates, times_aum] = aum_cycle(1.0, 2, 0.05);
unique_phases = unique(phase_seq);
fprintf('AUM phases encountered: %s\n', strjoin(unique_phases, ', '));

% 4. Cosmology cycle
[state_seq, g_scale, times_cosmo] = cosmology_cycle(500, 0.05);
unique_states = unique(state_seq);
fprintf('Cosmology states: %s\n', strjoin(unique_states, ', '));
fprintf('Global scale range: [%.6f, %.6f]\n', min(g_scale), max(g_scale));

% 5. Discrete curvature
dx = diff(x); dy = diff(y);
cross_vals = dx(1:end-1).*dy(2:end) - dy(1:end-1).*dx(2:end);
len1 = sqrt(dx(1:end-1).^2 + dy(1:end-1).^2);
len2 = sqrt(dx(2:end).^2 + dy(2:end).^2);
kappa = 2*cross_vals ./ (len1.*len2.*(len1+len2) + 1e-15);
fprintf('Curvature range: [%.6f, %.6f]\n', min(kappa), max(kappa));

fprintf('\n=== Validation Complete ===\n');
