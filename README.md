# PRIMORDIAL SPIRAL

Experimental computational reconstruction inspired by Vedic cosmological symbolism, sacred geometry, and nanoscale architectural abstraction.

## Implementation Constraint

**Dylan** is the primary systems language.
**MATLAB** is the mathematical / numerical analysis environment.

## Explicit Classifications

Throughout this repository three categories are maintained:

| Classification | Meaning |
|----------------|---------|
| TRADITIONAL / SYMBOLIC | Concepts drawn from Hindu philosophical and cosmological literature (Spanda, AUM, cyclical manifestation, Kundalini imagery, Shankha). These are interpretive sources, not experimental claims. |
| MATHEMATICAL MODEL | Explicit equations, parameters, finite-state machines, and geometry definitions. |
| PHYSICAL / EXPERIMENTAL | Only statements that would require laboratory measurement or fabrication. This repository contains **no** fabricated nanoscale devices and makes **no** claim that a software spiral recreates a physical primordial process. |

Never silently convert a religious metaphor into a scientific fact.

## Conceptual Pipeline (Computational Interpretation)

```
UNMANIFEST
    |
SPANDA / VIBRATION (oscillatory abstraction)
    |
AUM / PRIMORDIAL SOUND (three-phase state machine)
    |
MANIFESTATION
    |
SPIRAL EXPANSION r(theta) = a e^(b*theta)
    |
CYCLICAL TRANSFORMATION
    |
REABSORPTION
    |
UNMANIFEST
```

This is a computational interpretation, not a claim of experimentally verified cosmology.

## Repository Layout

```
/dylan/    Primary systems implementation (Open Dylan)
/matlab/   Independent numerical analysis and verification
/data/     Serialized coordinate / state interchange
/docs/     Architecture notes and classification tables
/results/  Numerical comparison outputs
```

## Core Equation

Logarithmic spiral (parameterized, never hard-coded visuals):

```
r(theta) = a * exp(b * theta)
x(theta) = r(theta) * cos(theta)
y(theta) = r(theta) * sin(theta)
```

Expanding and contracting branches are produced by the sign of `b` and by explicit expansion/contraction rates in the cosmology cycle.

## Dylan Modules

| Module | Purpose |
|--------|---------|
| `spanda` | Oscillatory abstraction (sine/square/triangle/saw waveforms, radial/angular coupling) |
| `aum-cycle` | A-U-M three-phase + silence state machine with radial scaling per phase |
| `primordial-spiral` | Core log spiral geometry, expanding/contracting branches, discrete curvature, CSV export |
| `cosmology` | 7-state cyclical FSM (CREATION through UNMANIFEST) |
| `geometry` | Point2, Circle, concentric circles, radial divisions, regular polygons |
| `sacred-geometry` | Mandala-like scene builder with documented traditional sources |
| `conch` | Shankha spiral with cross-section, comparison to pure log spiral |
| `kundalini` | 7-node inner spiral with dormant/active/transcendent states |
| `nano-node` | NanoNode/NanoEdge/NanoCell with explicit nm scale factor |
| `nano-topology` | k-NN edge construction, local density, mean spacing |
| `logic` | Abstract gates (NOT/NAND/NOR/XOR/MUX/DEMUX), latches, D-FF, registers |
| `circuits` | Circuit elements placed on nano-topology, abstract ALU |
| `fsm` | Generic FSM + 5-stage pipeline abstraction |
| `serialization` | Plain-text/CSV export for MATLAB interchange |
| `simulation` | Primordial meta-world orchestration (bootstrap + step) |
| `validation` | Self-consistency checks, growth-ratio invariant, reference data export |

## MATLAB Scripts

| Script | Purpose |
|--------|---------|
| `primordial_spiral.m` | Independent log spiral geometry |
| `spanda_model.m` | Independent spanda waveform generation |
| `aum_cycle.m` | Independent AUM state machine |
| `cosmology_cycle.m` | Independent 7-state cosmology FSM |
| `validation.m` | Error metrics against Dylan reference data |
| `visualization.m` | 2-D and 3-D spiral plots |
| `conch_comparison.m` | Numerical conch vs. log spiral comparison |

## Dylan <-> MATLAB Verification

1. Dylan generates coordinates and state sequences from explicit parameters.
2. Data is serialized to `/data/` (plain text / CSV / simple S-expression style).
3. MATLAB independently reconstructs the same geometry.
4. Positional, radial, angular, and curvature errors are computed against defined tolerances.

## Running

### Dylan (Open Dylan or similar)

```bash
# Compile / load modules under dylan/
# Entry points: simulation.dylan, validation.dylan
```

### MATLAB

```matlab
cd matlab
validation   % runs independent reconstruction and error metrics
visualization % 2-D / 3-D spiral, expansion-contraction views
```

## Scientific Discipline

- Sacred-geometry modules document traditional source concepts separately from the mathematics.
- Nanoscale mapping uses an explicit conversion factor (1 simulation unit = N nm) and produces abstract NanoNode graphs only.
- Circuit and FSM layers are abstract connectivity models organized by spiral topology; they are not manufacturable layouts without separate fabrication analysis.
- PRIMORDIAL META-WORLD is a deterministic simulated state space, not another physical universe.

## License

FSL-1.1 (Functional Source License). Converts to Apache 2.0 after two years. See LICENSE.
