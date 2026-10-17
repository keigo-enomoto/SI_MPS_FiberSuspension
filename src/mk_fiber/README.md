# mk_fiber

Generates initial particle configurations for 2D fiber suspensions.
Fibers are placed with random positions and orientations (without overlapping each other or the walls),
and the remaining space is filled with fluid particles.

The procedure is described in Section 2.6 of my graduate thesis.

## Build

PETSc is required (the makefile reads compiler flags from PETSc's `pkg-config` file).

```sh
make    # builds `2d` and `read`
```

## Usage

Normally run through `output/mk_fiber/mk_particle.sh` (see the top-level [README](../../README.md)).

### `2d`

```sh
./2d input.txt
```

`input.txt`:

```txt
DIM 2
nx 20             # number of particles in x
ny 20             # number of particles in y (including walls)
aspect_ratio 10   # number of particles per fiber
n_fiber 3         # number of fibers
seed 4            # random seed
```

Constraints: `aspect_ratio <= ny - 6` and `aspect_ratio * n_fiber <= nx * (ny - 6)`.

Output: `<seed>f<n_fiber>-<aspect_ratio>_<n_particles>_<nx>-<ny>_2d.dat`

### `read`

Converts a `.dat` file to VTU for visualization in ParaView.

```sh
./read file.dat   # writes particle_2D.vtu
```

## Output Format (`.dat`)

```txt
<number of particles>
<number of fluid particles>
<number of fibers>
<aspect ratio>
MIN_X : <x_min>, MAX_X : <x_max>
MIN_Y : <y_min>, MAX_Y : <y_max>
MIN_Z : <z_min>, MAX_Z : <z_max>
<type> <x> <y> <z>     # one line per particle, fiber particles first
...
```
