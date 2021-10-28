#!/bin/bash
./build.sh
docker run -v $PWD:/work --rm prmc-python pytest