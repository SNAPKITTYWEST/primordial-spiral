function [theta, r, x, y] = primordial_spiral(a, b, theta_min, theta_max, resolution, phase_offset, scale)
% PRIMORDIAL_SPIRAL Logarithmic spiral geometry (MATLAB independent implementation).
% Classification: MATHEMATICAL MODEL
%
% r(theta) = scale * a * exp(b * (theta + phase_offset))
% x = r * cos(theta + phase_offset)
% y = r * sin(theta + phase_offset)
%
% All parameters are explicit; no hard-coded visual spiral.

if nargin < 1, a = 1.0; end
if nargin < 2, b = 0.15; end
if nargin < 3, theta_min = 0.0; end
if nargin < 4, theta_max = 4*pi; end
if nargin < 5, resolution = 200; end
if nargin < 6, phase_offset = 0.0; end
if nargin < 7, scale = 1.0; end

theta = linspace(theta_min, theta_max, resolution);
th = theta + phase_offset;
r = scale * a * exp(b * th);
x = r .* cos(th);
y = r .* sin(th);
end
