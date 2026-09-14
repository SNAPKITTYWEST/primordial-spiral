Module: validation
Synopsis: Dylan-side validation and export of reference data for MATLAB comparison.
         Defines tolerances for positional / radial / angular / curvature error.

define constant $tol-position = 1.0d-9;
define constant $tol-radius = 1.0d-9;
define constant $tol-angle = 1.0d-9;
define constant $tol-curvature = 1.0d-6;
define constant $tol-scale = 1.0d-9;

define method validate-spiral-self-consistency (p :: <spiral-parameters>)
  => (ok? :: <boolean>, max-r-err :: <float>)
  let pts = generate-spiral(p);
  let max-e = 0.0d0;
  for (pt in pts)
    let r-expected = radius-at(p, pt.theta);
    let e = abs(pt.r - r-expected);
    if (e > max-e) max-e := e end;
  end for;
  values(max-e < $tol-radius, max-e)
end method validate-spiral-self-consistency;

// Growth ratio invariant candidate: r(theta+delta) / r(theta) ~ exp(b*delta)
define method growth-ratio-invariant (p :: <spiral-parameters>, delta :: <float>)
  => (max-rel-err :: <float>)
  let pts = generate-spiral(p);
  let n = size(pts);
  let max-rel = 0.0d0;
  let expected = exp(p.b * delta);
  for (i from 0 below n - 1)
    let th0 = pts[i].theta;
    let th1 = th0 + delta;
    if (th1 <= p.theta-max)
      let r0 = radius-at(p, th0);
      let r1 = radius-at(p, th1);
      let ratio = if (r0 > 1.0d-15) r1 / r0 else 0.0d0 end;
      let rel = abs(ratio - expected) / max(abs(expected), 1.0d-15);
      if (rel > max-rel) max-rel := rel end;
    end if;
  end for;
  max-rel
end method growth-ratio-invariant;

define method export-reference-data (base-path :: <string>) => ()
  // Canonical parameter set
  let p = make-expanding-spiral(a: 1.0d0, b: 0.15d0,
                                theta-min: 0.0d0,
                                theta-max: 4.0d0 * $double-pi,
                                resolution: 200);
  let pts = generate-spiral(p);
  export-spiral-bundle(p, pts, concatenate(base-path, "/spiral_reference.txt"));

  let topo = build-topology-from-spiral(pts, nm-per-unit: 10.0d0, k-nearest: 3);
  export-topology-bundle(topo, concatenate(base-path, "/topology_reference.txt"));

  let conch-p = make(<conch-parameters>, a0: 0.5d0, growth: 0.12d0,
                     pitch: 0.25d0, resolution: 200);
  let conch-pts = generate-conch-centerline(conch-p);
  export-conch-bundle(conch-pts, concatenate(base-path, "/conch_reference.txt"));

  let k = make-kundalini(n-nodes: 7, base-radius: 0.4d0, height: 2.5d0, turns: 2.5d0);
  export-kundalini-bundle(k, concatenate(base-path, "/kundalini_reference.txt"));

  // Spanda + AUM + cosmology snapshots
  let sp = make-spanda(amplitude: 1.0d0, frequency: 1.5d0, phase: 0.0d0,
                       radial-coupling: 0.2d0, waveform: #"sine");
  write-text-file(concatenate(base-path, "/spanda_params.txt"),
                  spanda-to-string(sp));
  let aum = make-aum-cycle();
  write-text-file(concatenate(base-path, "/aum_params.txt"),
                  aum-to-string(aum));
  let cosmo = make-default-cosmology();
  write-text-file(concatenate(base-path, "/cosmology_params.txt"),
                  cosmology-to-string(cosmo));
end method export-reference-data;

// Entry-point style function for a full validation pass
define function run-dylan-validation (data-dir :: <string>) => ()
  let p = make-expanding-spiral(a: 1.0d0, b: 0.15d0, resolution: 128);
  let (ok?, max-e) = validate-spiral-self-consistency(p);
  format-out("Spiral self-consistency: ok=%s max_r_err=%.3e\n", ok?, max-e);
  let gr = growth-ratio-invariant(p, 0.5d0);
  format-out("Growth-ratio relative error (delta_theta=0.5): %.3e\n", gr);
  export-reference-data(data-dir);
  format-out("Reference data exported to %s\n", data-dir);
end function run-dylan-validation;
