export SPEC_PATH=/scratch/spec-make
cd ci/G1V03L2Fi
export OMP_NUM_THREADS=1
mpiexec -n 2 --allow-run-as-root ${SPEC_PATH}/xspec G1V03L2Fi.001.sp
cd ../..
