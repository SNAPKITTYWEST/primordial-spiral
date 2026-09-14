Module: kundalini
Synopsis: Symbolic inner-spiral model inspired by traditional Kundalini imagery.
         COMPUTATIONAL GEOMETRY / STATE MODEL only.
         Not a biological or medical model.

/*
  TRADITIONAL / SYMBOLIC:
  Classical descriptions speak of a coiled energy at the base of the spine
  rising through successive centers. This module represents that imagery
  as an ordered sequence of nodes on an inner spiral plus a central axis.
  No physiological claim is made.
*/

define class <kundalini-node> (<object>)
  slot level :: <integer>, required-init-keyword: level:;
  slot theta :: <float>, required-init-keyword: theta:;
  slot r :: <float>, required-init-keyword: r:;
  slot x :: <float>, required-init-keyword: x:;
  slot y :: <float>, required-init-keyword: y:;
  slot z :: <float>, required-init-keyword: z:; // height along axis
  slot state :: <symbol> = #"dormant",
    init-keyword: state:; // #"dormant" | #"active" | #"transcendent"
end class <kundalini-node>;

define class <kundalini-spiral> (<object>)
  slot n-nodes :: <integer> = 7,
    init-keyword: n-nodes:;
  slot base-radius :: <float> = 0.5d0,
    init-keyword: base-radius:;
  slot height :: <float> = 3.0d0,
    init-keyword: height:;
  slot turns :: <float> = 3.0d0,
    init-keyword: turns:;
  slot nodes :: <simple-object-vector> = #[];
  slot axis-x :: <float> = 0.0d0;
  slot axis-y :: <float> = 0.0d0;
  slot terminal-reached? :: <boolean> = #f;
end class <kundalini-spiral>;

define method generate-kundalini! (k :: <kundalini-spiral>) => ()
  let n = k.n-nodes;
  let nodes = make(<simple-object-vector>, size: n);
  for (i from 0 below n)
    let frac = as(<float>, i) / as(<float>, max(n - 1, 1));
    let theta = k.turns * 2.0d0 * $double-pi * frac;
    // Radius decreases toward the axis as one ascends (coiled -> rising)
    let r = k.base-radius * (1.0d0 - 0.7d0 * frac);
    let z = k.height * frac;
    let x = k.axis-x + r * cos(theta);
    let y = k.axis-y + r * sin(theta);
    let st = if (i = 0) #"dormant"
             elseif (i = n - 1) #"transcendent"
             else #"active"
             end;
    nodes[i] := make(<kundalini-node>,
                     level: i, theta: theta, r: r, x: x, y: y, z: z,
                     state: st);
  end for;
  k.nodes := nodes;
  k.terminal-reached? := #t;
end method generate-kundalini!;

define method kundalini-to-csv (k :: <kundalini-spiral>) => (str :: <string>)
  let stream = make(<string-stream>, direction: #"output");
  format(stream, "level,theta,r,x,y,z,state\n");
  for (nd in k.nodes)
    format(stream, "%d,%.15g,%.15g,%.15g,%.15g,%.15g,%s\n",
           nd.level, nd.theta, nd.r, nd.x, nd.y, nd.z,
           as(<string>, nd.state));
  end for;
  stream-contents(stream)
end method kundalini-to-csv;

define function make-kundalini
    (#key n-nodes = 7, base-radius = 0.5d0, height = 3.0d0, turns = 3.0d0)
  => (k :: <kundalini-spiral>)
  let k = make(<kundalini-spiral>,
               n-nodes: n-nodes, base-radius: base-radius,
               height: height, turns: turns);
  generate-kundalini!(k);
  k
end function make-kundalini;
