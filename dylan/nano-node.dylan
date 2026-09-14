Module: nano-node
Synopsis: Nanoscale coordinate mapping of the mathematical spiral.
         1 simulation unit = N nanometers (explicit parameter).
         Abstract NanoNode / NanoEdge only -- not a fabricated device.

define class <nano-node> (<object>)
  slot id :: <integer>, required-init-keyword: id:;
  slot x :: <float>, required-init-keyword: x:; // simulation units
  slot y :: <float>, required-init-keyword: y:;
  slot z :: <float> = 0.0d0, init-keyword: z:;
  slot radius :: <float> = 0.0d0, init-keyword: radius:;
  slot angle :: <float> = 0.0d0, init-keyword: angle:;
  slot layer :: <integer> = 0, init-keyword: layer:;
  slot state :: <symbol> = #"idle", init-keyword: state:;
  slot neighbors :: <list> = #(), init-keyword: neighbors:;
  // Physical mapping
  slot x-nm :: <float> = 0.0d0, init-keyword: x-nm:;
  slot y-nm :: <float> = 0.0d0, init-keyword: y-nm:;
  slot z-nm :: <float> = 0.0d0, init-keyword: z-nm:;
end class <nano-node>;

define class <nano-edge> (<object>)
  slot from-id :: <integer>, required-init-keyword: from-id:;
  slot to-id :: <integer>, required-init-keyword: to-id:;
  slot length :: <float> = 0.0d0, init-keyword: length:;
  slot length-nm :: <float> = 0.0d0, init-keyword: length-nm:;
end class <nano-edge>;

define class <nano-cell> (<object>)
  slot id :: <integer>, required-init-keyword: id:;
  slot node-ids :: <list> = #(), init-keyword: node-ids:;
  slot cell-type :: <symbol> = #"generic", init-keyword: cell-type:;
end class <nano-cell>;

define class <nano-layer> (<object>)
  slot layer-index :: <integer>, required-init-keyword: layer-index:;
  slot nodes :: <simple-object-vector> = #[],
    init-keyword: nodes:;
end class <nano-layer>;

define class <nano-scale> (<object>)
  slot nm-per-unit :: <float> = 1.0d0, // 1 sim unit = this many nm
    init-keyword: nm-per-unit:;
end class <nano-scale>;

define method apply-scale! (node :: <nano-node>, scale :: <nano-scale>) => ()
  node.x-nm := node.x * scale.nm-per-unit;
  node.y-nm := node.y * scale.nm-per-unit;
  node.z-nm := node.z * scale.nm-per-unit;
end method apply-scale!;

define method node-spacing (a :: <nano-node>, b :: <nano-node>)
  => (d :: <float>)
  let dx = a.x - b.x; let dy = a.y - b.y; let dz = a.z - b.z;
  sqrt(dx * dx + dy * dy + dz * dz)
end method node-spacing;

define method angular-distance (a :: <nano-node>, b :: <nano-node>)
  => (dtheta :: <float>)
  let d = abs(a.angle - b.angle);
  min(d, 2.0d0 * $double-pi - d)
end method angular-distance;

define method radial-distance (a :: <nano-node>, b :: <nano-node>)
  => (dr :: <float>)
  abs(a.radius - b.radius)
end method radial-distance;
