Module: sacred-geometry
Synopsis: Geometry module with explicit documentation of traditional sources.
         MATHEMATICAL generators. Traditional labels are documentary only.

/*
  TRADITIONAL / SYMBOLIC NOTES (not mathematical claims):

  - Mandala / yantra traditions use concentric circles, radial divisions,
    and polygonal symmetry as contemplative diagrams.
  - This module provides the same geometric primitives so that a
    computational model can be compared with those diagrams.
  - No automatic labelling of an arbitrary coordinate set as "Hindu
    sacred geometry" is performed. Source concepts are recorded here
    and in docs/classifications.md.
*/

define class <sacred-geometry-scene> (<object>)
  slot circles :: <simple-object-vector> = #[],
    init-keyword: circles:;
  slot rays :: <simple-object-vector> = #[],
    init-keyword: rays:;
  slot polygons :: <simple-object-vector> = #[],
    init-keyword: polygons:;
  slot nested :: <simple-object-vector> = #[],
    init-keyword: nested:;
  slot spiral-points :: <simple-object-vector> = #[],
    init-keyword: spiral-points:;
  slot source-note :: <string> = "Computational geometry; traditional labels documentary only",
    init-keyword: source-note:;
end class <sacred-geometry-scene>;

define function build-radial-mandala-like
    (center-x :: <float>, center-y :: <float>,
     #key n-circles = 5, n-rays = 12, n-sides = 6, n-nested = 3,
          outer-radius = 2.0d0)
  => (scene :: <sacred-geometry-scene>)
  let center = make(<point2>, x: center-x, y: center-y);
  let radii = make(<simple-object-vector>, size: n-circles);
  for (i from 0 below n-circles)
    radii[i] := outer-radius * as(<float>, i + 1) / as(<float>, n-circles);
  end for;
  let circs = concentric-circles(center, radii);
  let ray-segs = radial-divisions(center, outer-radius, n-rays);
  let poly = regular-polygon(center, outer-radius * 0.8d0, n-sides);
  let nested = nested-polygons(center, outer-radius, n-sides, n-nested, 0.7d0);
  make(<sacred-geometry-scene>,
       circles: circs,
       rays: ray-segs,
       polygons: vector(poly),
       nested: nested,
       source-note: "Inspired by radial mandala / yantra diagram structure; mathematics only")
end function build-radial-mandala-like;

define method scene-summary (s :: <sacred-geometry-scene>) => (str :: <string>)
  format-to-string(
    "n_circles=%d\nn_rays=%d\nn_polygons=%d\nn_nested_levels=%d\nnote=%s\n",
    size(s.circles), size(s.rays), size(s.polygons), size(s.nested),
    s.source-note)
end method scene-summary;
