% CONCH_COMPARISON Compare conch-spiral model to pure log spiral.
% Numerical analysis only.

fprintf('=== Conch vs. Log Spiral Comparison ===\n');

a0 = 0.5;
growth = 0.12;
pitch = 0.3;
n_pts = 300;

theta = linspace(0, 8*pi, n_pts);

% Conch model: mild deviation from pure exponential
r_conch = a0 * exp(growth * theta) .* (1 + 0.05 * sin(3 * theta));

% Pure log spiral with same parameters
r_log = a0 * exp(growth * theta);

% Error metrics
err = abs(r_conch - r_log);
max_err = max(err);
mean_err = mean(err);
rms_err = sqrt(mean(err.^2));

fprintf('Max absolute error:  %.6e\n', max_err);
fprintf('Mean absolute error: %.6e\n', mean_err);
fprintf('RMS error:           %.6e\n', rms_err);

% Relative error
rel_err = err ./ r_log;
fprintf('Max relative error:  %.6e\n', max(rel_err));
fprintf('Mean relative error: %.6e\n', mean(rel_err));

% Cartesian
x_conch = r_conch .* cos(theta);
y_conch = r_conch .* sin(theta);
z_conch = pitch * theta;

x_log = r_log .* cos(theta);
y_log = r_log .* sin(theta);

figure('Name', 'Conch vs Log Spiral');
subplot(1,2,1);
plot(x_conch, y_conch, 'b-', 'LineWidth', 1.2); hold on;
plot(x_log, y_log, 'r--', 'LineWidth', 1.0);
axis equal; grid on;
legend('Conch model', 'Pure log spiral');
title('2D projection');
xlabel('x'); ylabel('y');

subplot(1,2,2);
plot3(x_conch, y_conch, z_conch, 'b-', 'LineWidth', 1.5);
grid on; axis equal;
title('Conch 3D');
xlabel('x'); ylabel('y'); zlabel('z');
view(30, 25);

fprintf('\n=== Comparison Complete ===\n');
