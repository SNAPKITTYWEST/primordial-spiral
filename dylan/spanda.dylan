Module: spanda
Synopsis: SPANDA oscillatory / state-transition abstraction.
         Classification: TRADITIONAL/SYMBOLIC inspiration + MATHEMATICAL MODEL.
         Not a claim of experimental physics of consciousness.

define class <spanda-oscillator> (<object>)
  slot amplitude :: <float> = 1.0d0,
    init-keyword: amplitude:;
  slot frequency :: <float> = 1.0d0, // angular frequency ω
    init-keyword: frequency:;
  slot phase :: <float> = 0.0d0,
    init-keyword: phase:;
  slot radial-coupling :: <float> = 0.0d0,
    init-keyword: radial-coupling:;
  slot angular-coupling :: <float> = 0.0d0,
    init-keyword: angular-coupling:;
  slot waveform :: <symbol> = #"sine", // #"sine" | #"square" | #"triangle" | #"saw"
    init-keyword: waveform:;
  slot time-index :: <float> = 0.0d0;
end class <spanda-oscillator>;

// Period derived from frequency
define method period (s :: <spanda-oscillator>) => (p :: <float>)
  if (s.frequency = 0.0d0)
    0.0d0
  else
    2.0d0 * $double-pi / abs(s.frequency)
  end if
end method period;

// Core evaluation: S(t) according to selected waveform
define method evaluate-spanda (s :: <spanda-oscillator>, t :: <float>)
  => (value :: <float>)
  let arg = s.frequency * t + s.phase;
  select (s.waveform)
    #"sine" =>
      s.amplitude * sin(arg);
    #"square" =>
      if (sin(arg) >= 0.0d0) s.amplitude else -s.amplitude end;
    #"triangle" =>
      // triangle via asin of sine, normalized
      (2.0d0 * s.amplitude / $double-pi) * asin(sin(arg));
    #"saw" =>
      // sawtooth in [-A, A]
      let frac = (arg / (2.0d0 * $double-pi)) - floor(arg / (2.0d0 * $double-pi));
      s.amplitude * (2.0d0 * frac - 1.0d0);
    otherwise =>
      s.amplitude * sin(arg);
  end select
end method evaluate-spanda;

// Advance internal time index
define method advance! (s :: <spanda-oscillator>, dt :: <float>) => ()
  s.time-index := s.time-index + dt;
end method advance!;

// Coupling into radial and angular increments for spiral driving
define method radial-drive (s :: <spanda-oscillator>, t :: <float>)
  => (dr :: <float>)
  s.radial-coupling * evaluate-spanda(s, t)
end method radial-drive;

define method angular-drive (s :: <spanda-oscillator>, t :: <float>)
  => (dtheta :: <float>)
  s.angular-coupling * evaluate-spanda(s, t)
end method angular-drive;

// Serialization of parameters (plain text for MATLAB interchange)
define method spanda-to-string (s :: <spanda-oscillator>) => (str :: <string>)
  format-to-string(
    "amplitude=%.10g\nfrequency=%.10g\nphase=%.10g\n"
    "radial_coupling=%.10g\nangular_coupling=%.10g\n"
    "waveform=%s\ntime_index=%.10g\n",
    s.amplitude, s.frequency, s.phase,
    s.radial-coupling, s.angular-coupling,
    as(<string>, s.waveform), s.time-index)
end method spanda-to-string;

// Factory with explicit parameters (no hidden defaults for geometry)
define function make-spanda
    (#key amplitude = 1.0d0,
          frequency = 1.0d0,
          phase = 0.0d0,
          radial-coupling = 0.0d0,
          angular-coupling = 0.0d0,
          waveform = #"sine")
  => (s :: <spanda-oscillator>)
  make(<spanda-oscillator>,
       amplitude: amplitude,
       frequency: frequency,
       phase: phase,
       radial-coupling: radial-coupling,
       angular-coupling: angular-coupling,
       waveform: waveform)
end function make-spanda;
