Module: nano-topology
Synopsis: Build NanoTopology from spiral points; compute density, curvature, connectivity.
         Abstract graph only.

define class <nano-topology> (<object>)
  slot nodes :: <simple-object-vector> = #[];
  slot edges :: <simple-object-vector> = #[];
  slot layers :: <simple-object-vector> = #[];
  slot scale :: <nano-scale>,
    init-keyword: scale:;
  slot k-nearest :: <integer> = 3,
    init-keyword: k-nearest:;
end class <nano-topology>;

define method spiral-to-nano-nodes
    (spiral-pts :: <simple-object-vector>, scale :: <nano-scale>,
     #key layer = 0)
  => (nodes :: <simple-object-vector>)
  let n = size(spiral-pts);
  let nodes = make(<simple-object-vector>, size: n);
  for (i from 0 below n)
    let pt = spiral-pts[i];
    let nd = make(<nano-node>,
                  id: i, x: pt.x, y: pt.y, z: 0.0d0,
                  radius: pt.r, angle: pt.theta, layer: layer,
                  state: #"idle");
    apply-scale!(nd, scale);
    nodes[i] := nd;
  end for;
  nodes
end method spiral-to-nano-nodes;

define method build-knn-edges
    (nodes :: <simple-object-vector>, k :: <integer>, scale :: <nano-scale>)
  => (edges :: <simple-object-vector>)
  let n = size(nodes);
  let edge-list = #();
  for (i from 0 below n)
    // Collect distances to all others
    let dists = make(<simple-object-vector>, size: n);
    for (j from 0 below n)
      if (i = j)
        dists[j] := 1.0d30;
      else
        dists[j] := node-spacing(nodes[i], nodes[j]);
      end if;
    end for;
    // Select k smallest
    for (sel from 0 below k)
      let best = 0;
      let best-d = dists[0];
      for (j from 1 below n)
        if (dists[j] < best-d)
          best := j; best-d := dists[j];
        end if;
      end for;
      if (best-d < 1.0d29)
        let e = make(<nano-edge>,
                     from-id: i, to-id: best, length: best-d,
                     length-nm: best-d * scale.nm-per-unit);
        edge-list := pair(e, edge-list);
        // mark neighbor
        nodes[i].neighbors := pair(best, nodes[i].neighbors);
        dists[best] := 1.0d30; // remove for next selection
      end if;
    end for;
  end for;
  as(<simple-object-vector>, reverse(edge-list))
end method build-knn-edges;

define method local-density (topo :: <nano-topology>, node-id :: <integer>,
                             radius :: <float>)
  => (count :: <integer>)
  let n = size(topo.nodes);
  let c = 0;
  let center = topo.nodes[node-id];
  for (i from 0 below n)
    if (i ~= node-id & node-spacing(center, topo.nodes[i]) <= radius)
      c := c + 1;
    end if;
  end for;
  c
end method local-density;

define method mean-node-spacing (topo :: <nano-topology>) => (m :: <float>)
  let edges = topo.edges;
  if (size(edges) = 0) 0.0d0
  else
    let s = 0.0d0;
    for (e in edges) s := s + e.length end;
    s / as(<float>, size(edges))
  end if
end method mean-node-spacing;

define method build-topology-from-spiral
    (spiral-pts :: <simple-object-vector>,
     #key nm-per-unit = 10.0d0, k-nearest = 3, layer = 0)
  => (topo :: <nano-topology>)
  let scale = make(<nano-scale>, nm-per-unit: nm-per-unit);
  let nodes = spiral-to-nano-nodes(spiral-pts, scale, layer: layer);
  let edges = build-knn-edges(nodes, k-nearest, scale);
  let layer-obj = make(<nano-layer>, layer-index: layer, nodes: nodes);
  make(<nano-topology>,
       nodes: nodes, edges: edges,
       layers: vector(layer-obj),
       scale: scale, k-nearest: k-nearest)
end method build-topology-from-spiral;

define method topology-to-csv (topo :: <nano-topology>) => (str :: <string>)
  let stream = make(<string-stream>, direction: #"output");
  format(stream, "id,x,y,z,radius,angle,layer,state,x_nm,y_nm,z_nm\n");
  for (nd in topo.nodes)
    format(stream, "%d,%.15g,%.15g,%.15g,%.15g,%.15g,%d,%s,%.15g,%.15g,%.15g\n",
           nd.id, nd.x, nd.y, nd.z, nd.radius, nd.angle, nd.layer,
           as(<string>, nd.state), nd.x-nm, nd.y-nm, nd.z-nm);
  end for;
  stream-contents(stream)
end method topology-to-csv;
