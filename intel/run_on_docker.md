```bash

git clone -b develop https://github.com/nextsimhub/nextsimdg.git
cd nextsimdg
. /opt/spack-environment/activate.sh
mkdir -p build && cd build
cmake .. -DENABLE_MPI=ON -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_COMPILER=$(which mpiicc) -DCMAKE_CXX_COMPILER=$(which mpiicpc)
cmake .. -DENABLE_MPI=ON -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_COMPILER=$(which icc) -DCMAKE_CXX_COMPILER=$(which icpc)

```

