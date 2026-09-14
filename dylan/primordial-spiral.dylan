Module: primordial-spiral
Synopsis: Core logarithmic spiral geometry.
         MATHEMATICAL MODEL only. Never hard-coded visuals.
         r(theta) = a * exp(b * theta)

define class <spiral-parameters> (<object>)
  slot a :: <float> = 1.0d0, // scale factor
    init-keyword: a:;
  slot b :: <float> = 0.15d0, // growth rate (sign selects expand/contract)
    init-keyword: b:;
  slot theta-min :: <float> = 0.0d0,
    init-keyword: theta-min:;
  slot theta-max :: <float> = 6.0d0 * $double-pi,
    init-keyword: theta-max:;
  slot resolution :: <integer> = 256, // number of sample points
    init-keyword: resolution:;
  slot phase-offset :: <float> = 0.0d0,
    init-keyword: phase-offset:;
  slot scale :: <float> = 1.0d0, // global multiplier
    init-keyword: scale:;
  slot expansion-rate :: <float> = 1.0d0,
    init-keyword: expansion-rate:;
  slot contraction-rate :: <float> = 1.0d0,
    init-keyword: contraction-rate:;
end class <spiral-parameters>;

define class <spiral-point> (<object>)
  slot theta :: <float>,
    required-init-keyword: theta:;
  slot r :: <float>,
    required-init-keyword: r:;
  slot x :: <float>,
    required-init-keyword: x:;
  slot y :: <float>,
    required-init-keyword: y:;
  slot index :: <integer> = 0,
    init-keyword: index:;
end class <spiral-point>;

// Primary evaluation -- every geometry originates from explicit parameters
define method radius-at (p :: <spiral-parameters>, theta :: <float>)
  => (r :: <float>)
  let th = theta + p.phase-offset;
  p.scale * p.a * exp(p.b * th)
end method radius-at;

define method cartesian-at (p :: <spiral-parameters>, theta :: <float>)
  => (x :: <float>, y :: <float>, r :: <float>)
  let r = radius-at(p, theta);
  let th = theta + p.phase-offset;
  values(r * cos(th), r * sin(th), r)
end method cartesian-at;

// Generate full discrete spiral from parameters
define method generate-spiral (p :: <spiral-parameters>)
  => (points :: <simple-object-vector>)
  let n = p.resolution;
  let pts = make(<simple-object-vector>, size: n);
  let dtheta = if (n <= 1) 0.0d0
               else (p.theta-max - p.theta-min) / as(<float>, n - 1)
               end;
  for (i from 0 below n)
    let theta = p.theta-min + as(<float>, i) * dtheta;
    let (x, y, r) = cartesian-at(p, theta);
    pts[i] := make(<spiral-point>,
                   theta: theta, r: r, x: x, y: y, index: i);
  end for;
  pts
end method generate-spiral;

// Expanding branch: b > 0 (or force positive growth)
define method make-expanding-spiral
    (#key a = 1.0d0, b = 0.15d0, theta-min = 0.0d0,
          theta-max = 6.0d0 * $double-pi, resolution = 256,
          phase-offset = 0.0d0, scale = 1.0d0)
  => (p :: <spiral-parameters>)
  make(<spiral-parameters>,
       a: a, b: abs(b), theta-min: theta-min, theta-max: theta-max,
       resolution: resolution, phase-offset: phase-offset, scale: scale,
       expansion-rate: 1.0d0, contraction-rate: 0.0d0)
end method make-expanding-spiral;

// Contracting branch: b < 0
define method make-contracting-spiral
    (#key a = 1.0d0, b = 0.15d0, theta-min = 0.0d0,
          theta-max = 6.0d0 * $double-pi, resolution = 256,
          phase-offset = 0.0d0, scale = 1.0d0)
  => (p :: <spiral-parameters>)
  make(<spiral-parameters>,
       a: a, b: -abs(b), theta-min: theta-min, theta-max: theta-max,
       resolution: resolution, phase-offset: phase-offset, scale: scale,
       expansion-rate: 0.0d0, contraction-rate: 1.0d0)
end method make-contracting-spiral;

// Curvature proxy for planar parametric curve (numerical)
define method discrete-curvature (pts :: <simple-object-vector>)
  => (kappas :: <simple-object-vector>)
  let n = size(pts);
  let k = make(<simple-object-vector>, size: n);
  for (i from 0 below n)
    if (i = 0 | i = n - 1)
      k[i] := 0.0d0;
    else
      let p0 = pts[i - 1];
      let p1 = pts[i];
      let p2 = pts[i + 1];
      let dx1 = p1.x - p0.x; let dy1 = p1.y - p0.y;
      let dx2 = p2.x - p1.x; let dy2 = p2.y - p1.y;
      let cross = dx1 * dy2 - dy1 * dx2;
      let len1 = sqrt(dx1 * dx1 + dy1 * dy1);
      let len2 = sqrt(dx2 * dx2 + dy2 * dy2);
      let denom = len1 * len2 * (len1 + len2) + 1.0d-15;
      k[i] := 2.0d0 * cross / denom;
    end if;
  end for;
  k
end method discrete-curvature;

// Serialize points for MATLAB interchange (CSV-like)
define method spiral-points-to-csv (pts :: <simple-object-vector>)
  => (str :: <string>)
  let stream = make(<string-stream>, direction: #"output");
  format(stream, "index,theta,r,x,y\n");
  for (pt in pts)
    format(stream, "%d,%.15g,%.15g,%.15g,%.15g\n",
           pt.index, pt.theta, pt.r, pt.x, pt.y);
  end for;
  stream-contents(stream)
end method spiral-points-to-csv;

define method parameters-to-string (p :: <spiral-parameters>) => (str :: <string>)
  format-to-string(
    "a=%.15g\nb=%.15g\ntheta_min=%.15g\ntheta_max=%.15g\n"
    "resolution=%d\nphase_offset=%.15g\nscale=%.15g\n"
    "expansion_rate=%.15g\ncontraction_rate=%.15g\n",
    p.a, p.b, p.theta-min, p.theta-max, p.resolution,
    p.phase-offset, p.scale, p.expansion-rate, p.contraction-rate)
end method parameters-to-string;
