#!/bin/bash

docker run --rm -it -u $(id -u ${USER}):$(id -g ${USER}) -v $(pwd)/flow:/OpenROAD-flow-scripts/flow openroad/flow-ubuntu22.04-builder

