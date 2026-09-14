Module: aum-cycle
Synopsis: A-U-M computational signal as a three-component + silence state machine.
         Classification: TRADITIONAL/SYMBOLIC phases mapped onto MATHEMATICAL state machine.
         Not a claim about the physical acoustic spectrum of the syllable AUM.

define constant $aum-phases = #[#"A", #"U", #"M", #"silence"];

define class <aum-cycle> (<object>)
  slot phase-index :: <integer> = 0;
  slot phase-duration :: <float> = 1.0d0, // time units per phase
    init-keyword: phase-duration:;
  slot elapsed-in-phase :: <float> = 0.0d0;
  slot cycle-count :: <integer> = 0;
  // Mapping of phase to radial / angular behaviour
  slot expansion-rate-A :: <float> = 1.0d0,
    init-keyword: expansion-rate-A:;
  slot transition-rate-U :: <float> = 0.0d0,
    init-keyword: transition-rate-U:;
  slot contraction-rate-M :: <float> = -1.0d0,
    init-keyword: contraction-rate-M:;
  slot reset-rate-silence :: <float> = 0.0d0,
    init-keyword: reset-rate-silence:;
end class <aum-cycle>;

define method current-phase (c :: <aum-cycle>) => (p :: <symbol>)
  $aum-phases[c.phase-index]
end method current-phase;

define method radial-scale-for-phase (c :: <aum-cycle>) => (rate :: <float>)
  select (current-phase(c))
    #"A" => c.expansion-rate-A;
    #"U" => c.transition-rate-U;
    #"M" => c.contraction-rate-M;
    #"silence" => c.reset-rate-silence;
    otherwise => 0.0d0;
  end select
end method radial-scale-for-phase;

define method angular-scale-for-phase (c :: <aum-cycle>) => (rate :: <float>)
  // Angular advance is continuous; phase mainly modulates radial behaviour
  1.0d0
end method angular-scale-for-phase;

define method advance-aum! (c :: <aum-cycle>, dt :: <float>) => (phase-changed? :: <boolean>)
  c.elapsed-in-phase := c.elapsed-in-phase + dt;
  if (c.elapsed-in-phase >= c.phase-duration)
    c.elapsed-in-phase := c.elapsed-in-phase - c.phase-duration;
    c.phase-index := modulo(c.phase-index + 1, size($aum-phases));
    if (c.phase-index = 0)
      c.cycle-count := c.cycle-count + 1;
    end if;
    #t
  else
    #f
  end if
end method advance-aum!;

define method aum-to-string (c :: <aum-cycle>) => (str :: <string>)
  format-to-string(
    "phase=%s\nphase_index=%d\nphase_duration=%.10g\n"
    "elapsed=%.10g\ncycle_count=%d\n"
    "expansion_A=%.10g\ntransition_U=%.10g\n"
    "contraction_M=%.10g\nreset_silence=%.10g\n",
    as(<string>, current-phase(c)),
    c.phase-index, c.phase-duration, c.elapsed-in-phase, c.cycle-count,
    c.expansion-rate-A, c.transition-rate-U,
    c.contraction-rate-M, c.reset-rate-silence)
end method aum-to-string;

define function make-aum-cycle
    (#key phase-duration = 1.0d0,
          expansion-rate-A = 1.0d0,
          transition-rate-U = 0.0d0,
          contraction-rate-M = -1.0d0,
          reset-rate-silence = 0.0d0)
  => (c :: <aum-cycle>)
  make(<aum-cycle>,
       phase-duration: phase-duration,
       expansion-rate-A: expansion-rate-A,
       transition-rate-U: transition-rate-U,
       contraction-rate-M: contraction-rate-M,
       reset-rate-silence: reset-rate-silence)
end function make-aum-cycle;
