#!/bin/sh

# change here ==========
xx_arr=( 1 )
yy_arr=( 20 )
ap_arr=( 10 )
nf_arr=( 1 )
ss_arr=( 4 )

# ========================

for x_mult in "${xx_arr[@]}"; do
for yy in "${yy_arr[@]}"; do
for ap in "${ap_arr[@]}"; do
for nf in "${nf_arr[@]}"; do
for ss in "${ss_arr[@]}"; do

    xx=`expr ${yy} \* ${x_mult}`
    sed -e "s/xx/${xx}/g ; s/yy/${yy}/g ; s/ap/${ap}/g; s/nf/${nf}/g; s/ss/${ss}/g; " < input_tmp.txt > input.txt
    ./../../src/mk_fiber/2d input.txt > mk_log.txt
    dat=`ls *.dat`
 
    sed -e "s/@dat@/${dat}/g" < input_tmp2.txt > input_cluster.txt

    ./../../src/fp_fiber3/init input_cluster.txt
    mv *_2d.dat dat  # for 2D calculation 
#    mv *_3d.dat dat # for 3D calculation 
    rm input.txt input_cluster.txt

done
done
done
done
done
