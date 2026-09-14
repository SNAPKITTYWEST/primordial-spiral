function [t, S, dr, dtheta] = spanda_model(amplitude, frequency, phase, ...
    radial_coupling, angular_coupling, waveform, t_span, n_samples)
% SPANDA_MODEL Oscillatory abstraction S(t).
% TRADITIONAL/SYMBOLIC inspiration + MATHEMATICAL MODEL.
% Supports sine, square, triangle, saw waveforms.

if nargin < 1, amplitude = 1.0; end
if nargin < 2, frequency = 1.0; end
if nargin < 3, phase = 0.0; end
if nargin < 4, radial_coupling = 0.0; end
if nargin < 5, angular_coupling = 0.0; end
if nargin < 6, waveform = 'sine'; end
if nargin < 7, t_span = [0, 4*pi]; end
if nargin < 8, n_samples = 256; end

t = linspace(t_span(1), t_span(2), n_samples);
arg = frequency * t + phase;

switch lower(waveform)
    case 'sine'
        S = amplitude * sin(arg);
    case 'square'
        S = amplitude * sign(sin(arg));
        S(S == 0) = amplitude; % avoid exact zero ambiguity
    case 'triangle'
        S = (2*amplitude/pi) * asin(sin(arg));
    case 'saw'
        frac = mod(arg/(2*pi), 1);
        S = amplitude * (2*frac - 1);
    otherwise
        S = amplitude * sin(arg);
end

dr = radial_coupling * S;
dtheta = angular_coupling * S;
end
