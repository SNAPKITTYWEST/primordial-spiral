% VISUALIZATION 2-D and 3-D spiral plots.
% Requires primordial_spiral.m and spanda_model.m on path.

% 1. Expanding spiral
[theta_e, r_e, x_e, y_e] = primordial_spiral(1.0, 0.15, 0, 6*pi, 500);

figure('Name', 'Primordial Spiral - Expanding');
subplot(1,2,1);
plot(x_e, y_e, 'b-', 'LineWidth', 1.5);
axis equal; grid on;
title('Expanding Spiral r(\theta)=ae^{b\theta}');
xlabel('x'); ylabel('y');

subplot(1,2,2);
polarplot(theta_e, r_e, 'r-', 'LineWidth', 1.5);
title('Polar View');

% 2. Contracting spiral
[theta_c, r_c, x_c, y_c] = primordial_spiral(1.0, -0.15, 0, 6*pi, 500);

figure('Name', 'Primordial Spiral - Contracting');
plot(x_c, y_c, 'r-', 'LineWidth', 1.5);
axis equal; grid on;
title('Contracting Spiral');
xlabel('x'); ylabel('y');

% 3. Expansion + contraction overlay
figure('Name', 'Expansion-Contraction Overlay');
plot(x_e, y_e, 'b-', 'LineWidth', 1.2); hold on;
plot(x_c, y_c, 'r--', 'LineWidth', 1.2);
axis equal; grid on;
legend('Expanding', 'Contracting');
title('Expansion-Contraction Cycle');
xlabel('x'); ylabel('y');

% 4. Spanda-driven radial modulation
[t_sp, S_sp, dr_sp] = spanda_model(1.0, 2.0, 0, 0.1, 0, 'sine', [0,6*pi], 500);
r_mod = r_e .* (1 + 0.1*sin(2*theta_e));
x_mod = r_mod .* cos(theta_e);
y_mod = r_mod .* sin(theta_e);

figure('Name', 'Spanda-Modulated Spiral');
plot(x_e, y_e, 'b-', 'LineWidth', 0.8); hold on;
plot(x_mod, y_mod, 'm-', 'LineWidth', 1.5);
axis equal; grid on;
legend('Base', 'Spanda-modulated');
title('Spanda Oscillation on Spiral');

% 5. 3-D conch-like spiral
z_e = 0.3 * theta_e;
figure('Name', 'Conch-like 3D Spiral');
plot3(x_e, y_e, z_e, 'b-', 'LineWidth', 1.5);
grid on; axis equal;
xlabel('x'); ylabel('y'); zlabel('z');
title('Conch Spiral (3D extrusion)');
view(30, 25);

fprintf('Visualization complete.\n');
