#!/bin/bash
./build.sh
docker run -e GO_PIPELINE_NAME -e OUR_ASID -e API_HOST -e OUR_ODS_CODE -v $PWD:/work --rm prmc-python rm -rf .pytest_cache/ && pytest