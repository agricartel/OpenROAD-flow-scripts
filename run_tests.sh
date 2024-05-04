#!/bin/sh
# MAKE SURE YOUR CURRENT WORKING DIRECTORY IS THE SAME AS THIS SCRIPT
# AND docker.io is installed on your system.

# First, build OpenROAD
./build_openroad.sh

# Then, build the required design files
docker run --rm -it -u $(id -u ${USER}):$(id -g ${USER}) -v $(pwd)/flow:/OpenROAD-flow-scripts/flow openroad/flow-ubuntu22.04-builder /bin/sh -c "cd flow ; make clean_all ; make"

# Run the modified distributed test
mkdir tools/OpenROAD/src/drt/test/results
docker run --rm -it -v $(pwd)/flow:/OpenROAD-flow-scripts/flow -v $(pwd)/tools/OpenROAD/src/drt/test/:/OpenROAD-flow-scripts/tools/OpenROAD/src/drt/test/ openroad/flow-ubuntu22.04-builder /bin/sh -c \
  "cd tools/OpenROAD/src/drt/test ; ../../../../install/OpenROAD/bin/openroad des3_nangate45_distributed.tcl | tee leader.log ; mv leader.log results/"

# Run the base (non-distributed) test
mkdir tools/OpenROAD/src/drt/test/results
docker run --rm -it -v $(pwd)/flow:/OpenROAD-flow-scripts/flow -v $(pwd)/tools/OpenROAD/src/drt/test/:/OpenROAD-flow-scripts/tools/OpenROAD/src/drt/test/ openroad/flow-ubuntu22.04-builder /bin/sh -c \
  "cd tools/OpenROAD/src/drt/test ; ../../../../install/OpenROAD/bin/openroad des3_nangate45.tcl | tee base.log ; mv base.log results/"

