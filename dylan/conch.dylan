Module: conch
Synopsis: Shankha / conch-inspired spiral geometry.
         Separate model from the ideal logarithmic spiral.
         Numerical comparison only; no assumption that every natural
         conch is an exact log spiral or encodes Fibonacci.

define class <conch-parameters> (<object>)
  slot a0 :: <float> = 0.5d0, // base radius
    init-keyword: a0:;
  slot growth :: <float> = 0.12d0, // approximate radial growth
    init-keyword: growth:;
  slot pitch :: <float> = 0.3d0, // axial advance per radian
    init-keyword: pitch:;
  slot cross-section-scale :: <float> = 0.15d0,
    init-keyword: cross-section-scale:;
  slot theta-min :: <float> = 0.0d0,
    init-keyword: theta-min:;
  slot theta-max :: <float> = 8.0d0 * $double-pi,
    init-keyword: theta-max:;
  slot resolution :: <integer> = 300,
    init-keyword: resolution:;
  slot section-samples :: <integer> = 16, // cross-section polygon
    init-keyword: section-samples:;
end class <conch-parameters>;

define class <conch-point> (<object>)
  slot theta :: <float>, required-init-keyword: theta:;
  slot r :: <float>, required-init-keyword: r:;
  slot x :: <float>, required-init-keyword: x:;
  slot y :: <float>, required-init-keyword: y:;
  slot z :: <float>, required-init-keyword: z:; // extrusion / pitch
  slot section-radius :: <float> = 0.0d0,
    init-keyword: section-radius:;
end class <conch-point>;

// Centerline of the conch spiral (not forced to pure log form)
define method conch-radius (p :: <conch-parameters>, theta :: <float>)
  => (r :: <float>)
  // Mild deviation from pure exponential to allow later comparison
  p.a0 * exp(p.growth * theta) * (1.0d0 + 0.05d0 * sin(3.0d0 * theta))
end method conch-radius;

define method generate-conch-centerline (p :: <conch-parameters>)
  => (pts :: <simple-object-vector>)
  let n = p.resolution;
  let pts = make(<simple-object-vector>, size: n);
  let dtheta = if (n <= 1) 0.0d0
               else (p.theta-max - p.theta-min) / as(<float>, n - 1)
               end;
  for (i from 0 below n)
    let theta = p.theta-min + as(<float>, i) * dtheta;
    let r = conch-radius(p, theta);
    let x = r * cos(theta);
    let y = r * sin(theta);
    let z = p.pitch * theta;
    let sec-r = p.cross-section-scale * r;
    pts[i] := make(<conch-point>,
                   theta: theta, r: r, x: x, y: y, z: z,
                   section-radius: sec-r);
  end for;
  pts
end method generate-conch-centerline;

// Compare conch centerline radii to pure log spiral with same a, b~growth
define method compare-to-log-spiral
    (conch-pts :: <simple-object-vector>,
     a :: <float>, b :: <float>)
  => (max-err :: <float>, mean-err :: <float>, rms-err :: <float>)
  let n = size(conch-pts);
  let sum-abs = 0.0d0;
  let sum-sq = 0.0d0;
  let max-e = 0.0d0;
  for (i from 0 below n)
    let pt = conch-pts[i];
    let r-ideal = a * exp(b * pt.theta);
    let e = abs(pt.r - r-ideal);
    sum-abs := sum-abs + e;
    sum-sq := sum-sq + e * e;
    if (e > max-e) max-e := e end;
  end for;
  let mean-e = sum-abs / as(<float>, n);
  let rms-e = sqrt(sum-sq / as(<float>, n));
  values(max-e, mean-e, rms-e)
end method compare-to-log-spiral;

define method conch-to-csv (pts :: <simple-object-vector>) => (str :: <string>)
  let stream = make(<string-stream>, direction: #"output");
  format(stream, "theta,r,x,y,z,section_radius\n");
  for (pt in pts)
    format(stream, "%.15g,%.15g,%.15g,%.15g,%.15g,%.15g\n",
           pt.theta, pt.r, pt.x, pt.y, pt.z, pt.section-radius);
  end for;
  stream-contents(stream)
end method conch-to-csv;
