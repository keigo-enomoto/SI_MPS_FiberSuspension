# SI_MPS_FiberSuspension

2D simulation of fiber suspensions under shear flow using a Moving Particle Semi-implicit (MPS) method.

This code was developed for my [graduate thesis](http://rheology.jp/nagoya/employees/keigo-enomoto/).

Simulation videos are available on [YouTube](https://www.youtube.com/watch?v=f9K-1ByvgVI).

The code has been tested on Linux and macOS. It has not been tested on Windows.

## Requirements

- A C compiler (clang or gcc; gcc is required for OpenMP)
- [PETSc](https://petsc.org/)

## Installing PETSc

1. Download the PETSc tarball from the official website.
2. Move it to a directory of your choice (`lib` in this example) and extract it:
   ```sh
   mkdir lib
   mv path/to/petsc-3.xx.x.tar.gz lib
   cd lib
   tar xzf petsc-3.xx.x.tar.gz
   ```
3. Configure PETSc. Adjust the options to your environment (see the [installation guide](https://petsc.org/release/install/)).

   Without OpenMP:
   ```sh
   export PETSC_DIR=/path/to/lib/petsc-3.xx.x
   ./configure --with-cc=gcc --with-cxx=g++ --with-fc=gfortran --download-fblaslapack --with-mpi=0 PETSC_DIR=$PETSC_DIR
   ```
   With OpenMP:
   ```sh
   export PETSC_DIR=/path/to/lib/petsc-3.xx.x
   ./configure --with-cc=gcc --with-cxx=g++ --with-fc=gfortran --download-fblaslapack --with-openmp --with-mpi=0 PETSC_DIR=$PETSC_DIR
   ```
4. Run `make all` and `make check` as shown in the configure log.
5. Set the environment variables `PETSC_DIR` and `PETSC_ARCH`, and add them to your `~/.bashrc` or `~/.zshrc` so that they persist.

## Generating Initial Configurations

Initial particle configurations are generated with `src/mk_fiber` and `src/fp_fiber3/init.c`.

1. Compile the programs:
   ```sh
   cd src/mk_fiber
   make            # builds `2d` and `read`
   cd ../fp_fiber3
   make            # builds `mps` and `init`
   cd ../..
   ```

2. Set the parameters:
   ```sh
   cd output/mk_fiber
   ```
   Edit the following block in `mk_particle.sh`:
   ```sh
   # change here ==========
   xx_arr=( 1 )   # system width in x, as a multiple of yy
   yy_arr=( 20 )  # number of particles in y
   ap_arr=( 10 )  # aspect ratio of the fibers
   nf_arr=( 3 )   # number of fibers
   ss_arr=( 4 )   # random seed for the initial configuration
   # ========================
   ```
   Each array may contain several values; the script runs over all combinations.

   Note: to keep the computation time practical, keep `yy_arr` at 40 or below.

3. Run the script:
   ```sh
   ./mk_particle.sh
   ```
   For example, with `yy = 20`, `ap = 10`, and `nf = 3`, this takes about 3 minutes on my machine.

   On success, the initial configuration files are saved in the `dat` directory, named
   `<seed>f<n_fiber>-<aspect_ratio>_<n_particles>_<nx>-<ny>_2d.dat`.
   Use these files for the simulation as described below.

## Running the Simulation

1. Compile the simulation code without OpenMP:
   ```sh
   cd src/fp_fiber3
   make
   cd ../..
   ```
   or with OpenMP:
   ```sh
   cd src/fp_fiber3
   ./omp.sh
   cd ../..
   ```

2. Set the simulation parameters:
   ```sh
   cd output
   cp -r example test1
   cd test1
   ```
   Edit `input_cluster.txt`:
   ```txt
   DIM 2             # dimension (only 2 is currently supported)
   Rho_s 1.0         # mass density of the fibers
   Nu_f 10000        # viscosity of the fluid
   Nu_s 10000        # viscosity of the fibers
   strain_rate 10    # 1.0-10 is recommended
   Gravity 0.0
   DT 0.00001        # time step
   FINISH_TIME 0.2
   OUTPUT_INTERVAL 20
   Init_place ./../mk_fiber/dat/18f20-10_3600_60-60_2d.dat  # initial configuration file
   output_dir .      # output directory
   ks 1.0E+09        # stretching spring constant
   kb 5.0E+08        # bending spring constant
   VTU_flag 0        # 1: write VTU files, 0: do not
   ```
   Make sure that `Init_place` points to an existing file. You can list the available files with:
   ```sh
   ls ./../mk_fiber/dat
   ```

3. Run the simulation:
   ```sh
   ./execute.sh
   ```
   If the run takes too long, reduce `FINISH_TIME` or the spring constant `ks`.

## Output Files

| File | Contents |
|------|----------|
| `input_parameters` | Input parameters used in the run |
| `output_couette.dat` | Flow (velocity) profile |
| `particle*.vtu` | Particle snapshots; can be animated in [ParaView](https://www.paraview.org/) |
| `output_analysis.txt` | Quantities for analysis |
| `output_unit.dat` | Orientation (unit direction) vectors of the fibers |
| `output_FiberMonitor.dat` | Bending and stretching of the fibers |
| `output_center.dat` | Centers of mass of the fibers |
| `output_wallstress.dat` | Wall stress exerted by the suspension; dividing by the strain rate gives the viscosity |

## License

[MIT](LICENSE)
