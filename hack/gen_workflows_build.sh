#!/bin/sh
# Generate workflows definition for Github Action
# Run this hack from root.

PLATFORMS="aws gcp azure"
SPARK_VERSION=v2.4.0
OUTFILE=".github/workflows/build.yml"

cat <<'EOF' >$OUTFILE
name: Build and Push Docker
on:
  push:
    branches:
      - master

jobs:
EOF

for PLATFORM in $PLATFORMS; do

cat <<EOF >>$OUTFILE
  build_$PLATFORM:
    name: Build for $PLATFORM
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
      name: Check out code

EOF

    for IMAGE_TAG in "$PLATFORM-latest" "$PLATFORM-$SPARK_VERSION"; do

        cat <<EOF >>$OUTFILE

    - uses: mr-smithers-excellent/docker-build-push@v3
      name: Build & Push docker.pkg.github.com/spark-history-server-docker/spark-history-server:$IMAGE_TAG
      with:
        image: spark-history-server-docker/spark-history-server
        registry: docker.pkg.github.com
        username: \${{ github.actor }}
        password: \${{ secrets.GITHUB_TOKEN }} 
        buildArgs: SPARK_VERSION=$SPARK_VERSION,BUILD_PLATFORM=$PLATFORM
        tag: $IMAGE_TAG

    - uses: mr-smithers-excellent/docker-build-push@v3
      name: Build & Push docker.io/duyetdev/spark-history-server:$IMAGE_TAG
      with:
        image: duyetdev/spark-history-server
        registry: docker.io
        username: \${{ secrets.DOCKER_USERNAME }}
        password: \${{ secrets.DOCKER_PASSWORD }}
        buildArgs: SPARK_VERSION=$SPARK_VERSION,BUILD_PLATFORM=$PLATFORM
        tag: $IMAGE_TAG

EOF
    done

done

cat $OUTFILE