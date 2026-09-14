Module: logic
Synopsis: Abstract digital logic elements for the nanotechnology circuit layer.
         Organized later by spiral topology. Not a manufacturable layout.

define class <logic-gate> (<object>)
  slot name :: <string>, required-init-keyword: name:;
  slot n-inputs :: <integer>, required-init-keyword: n-inputs:;
  slot n-outputs :: <integer> = 1, init-keyword: n-outputs:;
end class <logic-gate>;

define class <not-gate> (<logic-gate>)
  inherited slot name = "NOT";
  inherited slot n-inputs = 1;
end class <not-gate>;

define class <nand-gate> (<logic-gate>)
  inherited slot name = "NAND";
  inherited slot n-inputs = 2;
end class <nand-gate>;

define class <nor-gate> (<logic-gate>)
  inherited slot name = "NOR";
  inherited slot n-inputs = 2;
end class <nor-gate>;

define class <xor-gate> (<logic-gate>)
  inherited slot name = "XOR";
  inherited slot n-inputs = 2;
end class <xor-gate>;

define class <mux-gate> (<logic-gate>)
  inherited slot name = "MUX";
  inherited slot n-inputs = 3; // A, B, sel
end class <mux-gate>;

define class <demux-gate> (<logic-gate>)
  inherited slot name = "DEMUX";
  inherited slot n-inputs = 2;
  inherited slot n-outputs = 2;
end class <demux-gate>;

// Pure evaluation (0/1 integers)
define method eval-not (a :: <integer>) => (o :: <integer>)
  if (a = 0) 1 else 0 end
end method eval-not;

define method eval-nand (a :: <integer>, b :: <integer>) => (o :: <integer>)
  if (a = 1 & b = 1) 0 else 1 end
end method eval-nand;

define method eval-nor (a :: <integer>, b :: <integer>) => (o :: <integer>)
  if (a = 0 & b = 0) 1 else 0 end
end method eval-nor;

define method eval-xor (a :: <integer>, b :: <integer>) => (o :: <integer>)
  if (a ~= b) 1 else 0 end
end method eval-xor;

define method eval-mux (a :: <integer>, b :: <integer>, sel :: <integer>)
  => (o :: <integer>)
  if (sel = 0) a else b end
end method eval-mux;

define method eval-demux (data :: <integer>, sel :: <integer>)
  => (y0 :: <integer>, y1 :: <integer>)
  if (sel = 0) values(data, 0) else values(0, data) end
end method eval-demux;

// Sequential abstractions
define class <latch> (<object>)
  slot q :: <integer> = 0;
end class <latch>;

define method eval-sr-latch! (L :: <latch>, s :: <integer>, r :: <integer>)
  => (q :: <integer>)
  if (s = 1 & r = 0) L.q := 1
  elseif (s = 0 & r = 1) L.q := 0
  end if;
  // s=r=1 left as previous for determinism
  L.q
end method eval-sr-latch!;

define class <d-flip-flop> (<object>)
  slot q :: <integer> = 0;
  slot prev-clk :: <integer> = 0;
end class <d-flip-flop>;

define method eval-dff! (ff :: <d-flip-flop>, d :: <integer>, clk :: <integer>)
  => (q :: <integer>)
  if (ff.prev-clk = 0 & clk = 1)
    ff.q := d;
  end if;
  ff.prev-clk := clk;
  ff.q
end method eval-dff!;

define class <register> (<object>)
  slot width :: <integer>, required-init-keyword: width:;
  slot bits :: <simple-object-vector>;
  slot prev-clk :: <integer> = 0;
end class <register>;

define method initialize (reg :: <register>, #key width = 8) => ()
  next-method();
  reg.bits := make(<simple-object-vector>, size: width, fill: 0);
end method initialize;

define method eval-register! (reg :: <register>,
                              data :: <simple-object-vector>,
                              load :: <integer>, clk :: <integer>)
  => (out :: <simple-object-vector>)
  if (reg.prev-clk = 0 & clk = 1 & load = 1)
    for (i from 0 below reg.width)
      reg.bits[i] := data[i];
    end for;
  end if;
  reg.prev-clk := clk;
  reg.bits
end method eval-register!;
