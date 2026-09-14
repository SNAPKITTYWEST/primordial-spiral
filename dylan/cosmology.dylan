Module: cosmology
Synopsis: Cyclical cosmology as a deterministic finite-state system.
         TRADITIONAL/SYMBOLIC cycle imagery -> MATHEMATICAL FSM.
         States: CREATION -> EXPANSION -> MANIFESTATION -> MAXIMUM_SCALE
                 -> CONTRACTION -> DISSOLUTION -> UNMANIFEST -> CREATION

define constant $cosmo-states =
  #[#"CREATION", #"EXPANSION", #"MANIFESTATION", #"MAXIMUM_SCALE",
    #"CONTRACTION", #"DISSOLUTION", #"UNMANIFEST"];

define class <cosmo-state-descriptor> (<object>)
  slot state-id :: <symbol>,
    required-init-keyword: state-id:;
  slot radial-scaling :: <float> = 1.0d0,
    init-keyword: radial-scaling:;
  slot angular-scaling :: <float> = 1.0d0,
    init-keyword: angular-scaling:;
  slot oscillation-amplitude :: <float> = 0.0d0,
    init-keyword: oscillation-amplitude:;
  slot oscillation-frequency :: <float> = 0.0d0,
    init-keyword: oscillation-frequency:;
  slot dwell-time :: <float> = 1.0d0,
    init-keyword: dwell-time:;
  slot next-state :: <symbol>,
    required-init-keyword: next-state:;
end class <cosmo-state-descriptor>;

define class <cosmology-cycle> (<object>)
  slot states :: <simple-object-vector>,
    required-init-keyword: states:;
  slot current-index :: <integer> = 0;
  slot elapsed :: <float> = 0.0d0;
  slot global-scale :: <float> = 1.0d0;
  slot cycle-count :: <integer> = 0;
end class <cosmology-cycle>;

define method current-state (c :: <cosmology-cycle>)
  => (d :: <cosmo-state-descriptor>)
  c.states[c.current-index]
end method current-state;

define method advance-cosmology! (c :: <cosmology-cycle>, dt :: <float>)
  => (transitioned? :: <boolean>)
  let d = current-state(c);
  c.elapsed := c.elapsed + dt;
  // Apply radial scaling contribution to global scale
  c.global-scale := c.global-scale * (1.0d0 + d.radial-scaling * dt * 0.01d0);
  if (c.elapsed >= d.dwell-time)
    c.elapsed := 0.0d0;
    let next-id = d.next-state;
    let found = #f;
    for (i from 0 below size(c.states), until: found)
      if (c.states[i].state-id == next-id)
        c.current-index := i;
        found := #t;
      end if;
    end for;
    if (next-id == #"CREATION" & d.state-id == #"UNMANIFEST")
      c.cycle-count := c.cycle-count + 1;
      c.global-scale := 1.0d0; // reset scale on full cycle
    end if;
    #t
  else
    #f
  end if
end method advance-cosmology!;

define function make-default-cosmology () => (c :: <cosmology-cycle>)
  let descriptors = vector(
    make(<cosmo-state-descriptor>,
         state-id: #"CREATION",
         radial-scaling: 0.2d0, angular-scaling: 1.0d0,
         oscillation-amplitude: 0.1d0, oscillation-frequency: 1.0d0,
         dwell-time: 1.0d0, next-state: #"EXPANSION"),
    make(<cosmo-state-descriptor>,
         state-id: #"EXPANSION",
         radial-scaling: 1.0d0, angular-scaling: 1.2d0,
         oscillation-amplitude: 0.3d0, oscillation-frequency: 2.0d0,
         dwell-time: 2.0d0, next-state: #"MANIFESTATION"),
    make(<cosmo-state-descriptor>,
         state-id: #"MANIFESTATION",
         radial-scaling: 0.5d0, angular-scaling: 1.0d0,
         oscillation-amplitude: 0.5d0, oscillation-frequency: 1.5d0,
         dwell-time: 2.0d0, next-state: #"MAXIMUM_SCALE"),
    make(<cosmo-state-descriptor>,
         state-id: #"MAXIMUM_SCALE",
         radial-scaling: 0.0d0, angular-scaling: 1.0d0,
         oscillation-amplitude: 0.2d0, oscillation-frequency: 0.5d0,
         dwell-time: 1.0d0, next-state: #"CONTRACTION"),
    make(<cosmo-state-descriptor>,
         state-id: #"CONTRACTION",
         radial-scaling: -0.8d0, angular-scaling: 0.9d0,
         oscillation-amplitude: 0.3d0, oscillation-frequency: 2.0d0,
         dwell-time: 2.0d0, next-state: #"DISSOLUTION"),
    make(<cosmo-state-descriptor>,
         state-id: #"DISSOLUTION",
         radial-scaling: -0.5d0, angular-scaling: 0.7d0,
         oscillation-amplitude: 0.1d0, oscillation-frequency: 1.0d0,
         dwell-time: 1.5d0, next-state: #"UNMANIFEST"),
    make(<cosmo-state-descriptor>,
         state-id: #"UNMANIFEST",
         radial-scaling: 0.0d0, angular-scaling: 0.0d0,
         oscillation-amplitude: 0.0d0, oscillation-frequency: 0.0d0,
         dwell-time: 1.0d0, next-state: #"CREATION")
  );
  make(<cosmology-cycle>, states: descriptors)
end function make-default-cosmology;

define method cosmology-to-string (c :: <cosmology-cycle>) => (str :: <string>)
  let d = current-state(c);
  format-to-string(
    "state=%s\nindex=%d\nelapsed=%.10g\nglobal_scale=%.10g\ncycle_count=%d\n"
    "radial_scaling=%.10g\nangular_scaling=%.10g\n"
    "osc_amp=%.10g\nosc_freq=%.10g\ndwell=%.10g\nnext=%s\n",
    as(<string>, d.state-id), c.current-index, c.elapsed,
    c.global-scale, c.cycle-count,
    d.radial-scaling, d.angular-scaling,
    d.oscillation-amplitude, d.oscillation-frequency,
    d.dwell-time, as(<string>, d.next-state))
end method cosmology-to-string;
