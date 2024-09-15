# FP_FIBER3

## Differences from fp_fiber2:
- Utilizes OpenMP directives.
- Changes the timing of wall particle position updates (see Labnote vol.2 p193).

## Target Simulations:
- Poiseuille flow
- Couette flow (both walls move)
- Includes fiber interaction

## Features:
- 2D and 3D simulations
- Cell list implementation
- Non-dimensionalized equations
- Viscous term: explicit (mps: main.c), implicit (mps_i: main_i.c)
- Pressure: implicit (using PETSc, single node)

|                  | Poiseuille | Couette  |
|:----------------:|:----------:|:--------:|
| **Gravity**      |  > 0.0     |  = 0.0   |
| **Wall Speed**   |  = 0.0     |  > 0.0   |

- Fiber particles are treated as fluid particles with bond constraints.
- The acceleration[] of wall particles is calculated as \(\rho \cdot \frac{Du}{Dt}\), which involves stress calculation.

## Input Files:
1. **input.txt**
2. **Initial arrangement file**
3. **Output directory**

### Example Input File:

```
DIM 2
Rho_s 1.0
Nu_f 1.0
Nu_s 1.0
strain_rate 0.01
Gravity 0.0
DT 0.1
FINISH_TIME 100.0
OUTPUT_INTERVAL 10
output_dir .
Init_place ./../../couette_1760.dat
ks 1.0
kd 1.0
VTU_flag 1 or 0
```

- `ParticleDistance = 1.0`
- `Rho_f = 1.0` (s --> solid, f --> fluid)
- Time scaling:
  \( t = t^* \left(\frac{ParticleDistance^2}{Nu_f}\right) = Nu_f \cdot t^* \)
  where \( t \) is dimensionless, and \( t^* \) is dimensional.
- Gravity constant \( g = 1.0 \).

## Important Notes:
- Ensure that the output directory path in the input file is correct, as an incorrect path will cause an error.

## Output Files:
1. **input_parameters.txt**
2. **output_*.dat**: records vx and y.
3. **output_analysis.txt**

## Execution:
```bash
  path/to/mps input.txt
```

## Change log
