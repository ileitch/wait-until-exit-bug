#!/bin/bash

set -e

docker build -t waituntilexitbug .
docker run --rm -t waituntilexitbug
