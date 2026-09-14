Module: geometry
Synopsis: Basic geometric primitives for sacred-geometry layer.
         MATHEMATICAL MODEL. Source tradition documented separately.

define class <point2> (<object>)
  slot x :: <float>, required-init-keyword: x:;
  slot y :: <float>, required-init-keyword: y:;
end class <point2>;

define class <circle> (<object>)
  slot center :: <point2>, required-init-keyword: center:;
  slot radius :: <float>, required-init-keyword: radius:;
  slot n-samples :: <integer> = 64, init-keyword: n-samples:;
end class <circle>;

define method sample-circle (c :: <circle>) => (pts :: <simple-object-vector>)
  let n = c.n-samples;
  let pts = make(<simple-object-vector>, size: n);
  for (i from 0 below n)
    let theta = 2.0d0 * $double-pi * as(<float>, i) / as(<float>, n);
    pts[i] := make(<point2>,
                   x: c.center.x + c.radius * cos(theta),
                   y: c.center.y + c.radius * sin(theta));
  end for;
  pts
end method sample-circle;

define method concentric-circles (center :: <point2>,
                                  radii :: <simple-object-vector>,
                                  #key n-samples = 64)
  => (circles :: <simple-object-vector>)
  let out = make(<simple-object-vector>, size: size(radii));
  for (i from 0 below size(radii))
    out[i] := make(<circle>, center: center, radius: radii[i],
                   n-samples: n-samples);
  end for;
  out
end method concentric-circles;

define method radial-divisions (center :: <point2>,
                                radius :: <float>,
                                n-rays :: <integer>)
  => (segments :: <simple-object-vector>)
  // Each segment is a pair of points: center -> periphery
  let segs = make(<simple-object-vector>, size: n-rays);
  for (i from 0 below n-rays)
    let theta = 2.0d0 * $double-pi * as(<float>, i) / as(<float>, n-rays);
    let outer = make(<point2>,
                     x: center.x + radius * cos(theta),
                     y: center.y + radius * sin(theta));
    segs[i] := vector(center, outer);
  end for;
  segs
end method radial-divisions;

define method regular-polygon (center :: <point2>,
                               radius :: <float>,
                               n-sides :: <integer>)
  => (pts :: <simple-object-vector>)
  let pts = make(<simple-object-vector>, size: n-sides);
  for (i from 0 below n-sides)
    let theta = 2.0d0 * $double-pi * as(<float>, i) / as(<float>, n-sides)
                - $double-pi / 2.0d0; // point-up orientation for triangle
    pts[i] := make(<point2>,
                   x: center.x + radius * cos(theta),
                   y: center.y + radius * sin(theta));
  end for;
  pts
end method regular-polygon;

define method triangular-structure (center :: <point2>, radius :: <float>)
  => (pts :: <simple-object-vector>)
  regular-polygon(center, radius, 3)
end method triangular-structure;

// Nested polygons (simple mandala-like radial symmetry generator)
define method nested-polygons (center :: <point2>,
                               base-radius :: <float>,
                               n-sides :: <integer>,
                               n-levels :: <integer>,
                               scale-factor :: <float>)
  => (levels :: <simple-object-vector>)
  let levels = make(<simple-object-vector>, size: n-levels);
  let r = base-radius;
  for (i from 0 below n-levels)
    levels[i] := regular-polygon(center, r, n-sides);
    r := r * scale-factor;
  end for;
  levels
end method nested-polygons;
