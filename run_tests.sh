#!/bin/sh
# MAKE SURE YOUR CURRENT WORKING DIRECTORY IS THE SAME AS THIS SCRIPT
# AND docker.io is installed on your system.

# First, pull the docker image
docker pull openroad/flow-ubuntu22.04-builder

# If that doesn't work, uncomment this and try building OpenROAD
# ./build_openroad.sh

# Then, build the required design files
docker run --rm -it -u $(id -u ${USER}):$(id -g ${USER}) -v $(pwd)/flow:/OpenROAD-flow-scripts/flow openroad/flow-ubuntu22.04-builder /bin/sh -c "cd flow ; make clean_all ; make"

# All output files from the benchmarks go here
mkdir tools/OpenROAD/src/drt/test/results

#===========#
# DES3 TESTS

# Run the modified distributed test
docker run --rm -it -v $(pwd)/flow:/OpenROAD-flow-scripts/flow -v $(pwd)/tools/OpenROAD/src/drt/test/:/OpenROAD-flow-scripts/tools/OpenROAD/src/drt/test/ openroad/flow-ubuntu22.04-builder /bin/sh -c \
  "cd tools/OpenROAD/src/drt/test ; ../../../../install/OpenROAD/bin/openroad des3_nangate45_distributed.tcl | tee results/des3-leader.log"

# Run the base (non-distributed) test
mkdir tools/OpenROAD/src/drt/test/results
docker run --rm -it -v $(pwd)/flow:/OpenROAD-flow-scripts/flow -v $(pwd)/tools/OpenROAD/src/drt/test/:/OpenROAD-flow-scripts/tools/OpenROAD/src/drt/test/ openroad/flow-ubuntu22.04-builder /bin/sh -c \
  "cd tools/OpenROAD/src/drt/test ; ../../../../install/OpenROAD/bin/openroad des3_nangate45.tcl | tee results/des3-base.log"

#===================#
# ISPD 18 BENCHMARKS

# Run the suite of benchmarks
docker run --rm -it -v $(pwd)/flow:/OpenROAD-flow-scripts/flow -v $(pwd)/tools/OpenROAD/src/drt/test/:/OpenROAD-flow-scripts/tools/OpenROAD/src/drt/test/ openroad/flow-ubuntu22.04-builder /bin/sh -c \
  "cd tools/OpenROAD/src/drt/test ; ./run_ispd18_benchmarks.sh"