# SI_MPS_FiberSuspension

Semi-implicit Moving Particle Simulations for 2D sheared fiber suspensions.

This code is used in my [graduate thesis](http://rheology.jp/nagoya/employees/keigo-enomoto/).

Watch simulation videos on [YouTube](https://www.youtube.com/watch?v=f9K-1ByvgVI).

I have not confirmed that this works on Windows. On Linux or Mac, it should work.

If you'd like to contact me, please email keno.rheo2525[at]gmail.com.

## Requirements

- gcc (if you want to use OpenMP)
- clang or gcc
- [PETSc](https://www.mcs.anl.gov/petsc/index.html)

## Setting up PETSc

1. Download the PETSc zip file from the official site.
2. Move the zip file to your preferred location (in this example, it's placed in the `lib` directory):
   ```
    mkdir lib
    mv path/to/file/petsc-3.xx.x.tar.gz lib
    cd lib
    tar xzf petsc-3.xx.x.tar.gz
   ```
3. Configure PETSc (adjust options according to your environment, refer to the [installation guide](https://www.mcs.anl.gov/petsc/documentation/installation.html)):

**Example configurations:**
- Without OpenMP:
  ```
  export PETSC_DIR=/path/to/lib/petsc-3.xx.x

  ./configure --with-cc=gcc --with-cxx=g++ --with-fc=gfortran --download-fblaslapack --with-mpi=0 PETSC_DIR=$PETSC_DIR
  ```
- With OpenMP:
  ```
  export PETSC_DIR=/path/to/lib/petsc-3.xx.x

  ./configure --with-cc=gcc --with-cxx=g++ --with-fc=gfortran --download-fblaslapack --with-openmp --with-mpi=0 PETSC_DIR=$PETSC_DIR
  ```

After configuring, run `make all` and `make check` as instructed in the log.

4. Set the environment variables `PETSC_DIR` and `PETSC_ARCH`.
5. Add `PETSC_DIR` and `PETSC_ARCH` to your `~/.bashrc` or `~/.zshrc` for persistence.

## Creating Initial Coordinates

Use `src/mk_fiber` and `fp_fiber3/init.c`.

1. Compile the programs:
    ```
    cd src/mk_fiber
    make            # `2d` and `read` are made
    cd ../fp_fiber3
    make            # `mps` and `init` are made
    cd ../..
    ```

2. Set the parameters:
   ```
   cd output/mk_fiber
   ```
    Then, edit the `mk_particle.sh` file:

    ```sh
    # change here ==========
    xx_arr=( 1 )
    yy_arr=( 40 ) # the number of particle in y axis
    ap_arr=( 10 ) # aspect ratio of fiber
    nf_arr=( 5 ) # number of fiber
    ss_arr=( 98 ) # seed for initial coordinate

    # ========================
    ```
    Note : For paractical computation timtes, set the number of y-axis particles `yy_arr` to less than 40.

3. Run the script to generate the particle coordinates:
   ```
   ./mk_particle.sh
    ```
    [ example ]
    For `y = 20`,`ap = 10`,`nf = 3`, the script takes about 3 minutes on my computer.

   if successful, the inital coordinate files will be placed in the `dat` directory. Use these files for the calculation as shown below.

## Running the Simulation

1. Compile the simulation code (without OpenMP):
   ```
    cd src/fp_fiber3
    make
    cd ..
   ```
   To compile with OpenMP:
   ```
    cd src/fp_fiber3
    ./omp.sh
    cd ..
   ```
2. Set simulation parameters:
   ```
   cd output
   cp -r example test1
   cd test1
   ```
   Edit the `input_cluster.txt` file:
   ```txt
    DIM 2           # dimension(Now, only 2 is available)
    Rho_s 1.0       # mass density of fiber
    Nu_f 10000      # viscosity of fluid
    Nu_s 10000      # viscosity of fiber
    strain_rate 10  # 1.0 ~ 10 is recommended
    Gravity 0.0
    DT 0.00001
    FINISH_TIME 0.2
    OUTPUT_INTERVAL 20
    Init_place ./../mk_fiber/dat/98f42-10_3600_60-60_2d.dat # the file for initial coordinate
    output_dir .    # where to output
    ks 1.0E+09      # spring constant
    kb 5.0E+08
    VTU_flag 0     # 1 -> output vtu file, 0 -> don't output
   ```
   Ensure the path to the initial coordinates file in `Init_place` is correct by running:
   ```sh
   ls ./../mk_fiber/dat

   ```
   This will list the files, allowing ou to verify the initial coordinate file.

3. Run the simulation:
   ```
   ./execute.sh
   ```
   If the calculation takes too long, adjust the `FINISH_TIME` or `ks`(spring constant) to reduce the duration.

## Output Files

- input_parameters        -> confirm the input parameters
- output_couette.dat      -> check the flow profile
- particle*.vtu           -> you can see the animation with [ParaView](https://www.paraview.org/)
- output_analysis.txt     -> some variables for analysis
- output_unit.dat         -> direction vector of fibers
- output_FiberMonitor.dat -> check the how fiber is bending or stretching
- output_center.dat       -> the gravity center of fibers
- output_wallstress.dat   -> the wall stress exerted by the fiber suspensions. Using the strain rate, you can calculate the viscosity.

