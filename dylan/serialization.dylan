Module: serialization
Synopsis: Plain-text / CSV serialization for Dylan <-> MATLAB interchange.
         No Python, no binary formats that require external runtimes.

define function write-text-file (path :: <string>, content :: <string>) => ()
  with-open-file (s = path, direction: #"output", if-exists: #"replace")
    write(s, content);
  end;
end function write-text-file;

define function parameters-block (title :: <string>, body :: <string>)
  => (str :: <string>)
  format-to-string("# %s\n%s\n", title, body)
end function parameters-block;

// Bundle spiral parameters + points into one interchange file
define method export-spiral-bundle
    (params :: <spiral-parameters>, pts :: <simple-object-vector>,
     path :: <string>) => ()
  let header = parameters-to-string(params);
  let csv = spiral-points-to-csv(pts);
  let content = format-to-string("%s---POINTS---\n%s", header, csv);
  write-text-file(path, content);
end method export-spiral-bundle;

define method export-topology-bundle
    (topo :: <nano-topology>, path :: <string>) => ()
  let scale-line = format-to-string("nm_per_unit=%.15g\nk_nearest=%d\n",
                                    topo.scale.nm-per-unit, topo.k-nearest);
  let csv = topology-to-csv(topo);
  let content = format-to-string("%s---NODES---\n%s", scale-line, csv);
  write-text-file(path, content);
end method export-topology-bundle;

define method export-conch-bundle
    (pts :: <simple-object-vector>, path :: <string>) => ()
  write-text-file(path, conch-to-csv(pts));
end method export-conch-bundle;

define method export-kundalini-bundle
    (k :: <kundalini-spiral>, path :: <string>) => ()
  write-text-file(path, kundalini-to-csv(k));
end method export-kundalini-bundle;
