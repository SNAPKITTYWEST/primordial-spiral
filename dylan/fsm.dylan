Module: fsm
Synopsis: Generic deterministic finite-state machine used by cosmology and meta-world.

define class <fsm-transition> (<object>)
  slot from-state :: <symbol>, required-init-keyword: from-state:;
  slot input-symbol :: <symbol>, required-init-keyword: input-symbol:;
  slot to-state :: <symbol>, required-init-keyword: to-state:;
  slot output-symbol :: <symbol> = #"none",
    init-keyword: output-symbol:;
end class <fsm-transition>;

define class <fsm> (<object>)
  slot name :: <string> = "fsm", init-keyword: name:;
  slot states :: <list>, required-init-keyword: states:;
  slot initial :: <symbol>, required-init-keyword: initial:;
  slot alphabet :: <list>, required-init-keyword: alphabet:;
  slot transitions :: <list> = #(), init-keyword: transitions:;
  slot current :: <symbol>;
  slot history :: <list> = #();
end class <fsm>;

define method initialize (f :: <fsm>, #rest args) => ()
  next-method();
  f.current := f.initial;
end method initialize;

define method reset-fsm! (f :: <fsm>) => ()
  f.current := f.initial;
  f.history := #();
end method reset-fsm!;

define method step-fsm! (f :: <fsm>, input :: <symbol>)
  => (output :: <symbol>)
  let found = #f;
  let out = #"none";
  let next = f.current;
  for (tr in f.transitions, until: found)
    if (tr.from-state == f.current & tr.input-symbol == input)
      next := tr.to-state;
      out := tr.output-symbol;
      found := #t;
    end if;
  end for;
  unless (found)
    error("FSM %s: no transition from %s on %s", f.name, f.current, input);
  end unless;
  f.history := pair(vector(f.current, input, next, out), f.history);
  f.current := next;
  out
end method step-fsm!;

// Pipeline stage abstraction
define class <pipeline-stage> (<object>)
  slot stage-name :: <string>, required-init-keyword: stage-name:;
  slot valid? :: <boolean> = #f;
  slot data :: <object> = #f;
  slot stall? :: <boolean> = #f;
end class <pipeline-stage>;

define class <simple-pipeline> (<object>)
  slot stages :: <simple-object-vector>;
  slot cycle :: <integer> = 0;
end class <simple-pipeline>;

define function make-five-stage-pipeline () => (p :: <simple-pipeline>)
  let names = #["IF", "ID", "EX", "MEM", "WB"];
  let st = make(<simple-object-vector>, size: 5);
  for (i from 0 below 5)
    st[i] := make(<pipeline-stage>, stage-name: names[i]);
  end for;
  make(<simple-pipeline>, stages: st)
end function make-five-stage-pipeline;
