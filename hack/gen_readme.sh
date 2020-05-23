#!/bin/sh
# Run this hack from root.

DOCKERHUB_IMAGE_NAME="duyetdev/spark-history-server"
PLATFORMS="aws gcp azure"
SPARK_VERSION="v2.4.0 latest"
OUTFILE="README.md"

cat <<'EOF' >$OUTFILE
# Docker Image for Spark History Server

Docker image for Spark history Server on Kubernetes

# Supported tags

EOF

for PLATFORM in $PLATFORMS; do
    printf ' - ' >> $OUTFILE

    for VERSION in $SPARK_VERSION; do
        printf "[$PLATFORM-$VERSION](https://hub.docker.com/r/$DOCKERHUB_IMAGE_NAME/tags) " >> $OUTFILE
    done

    echo >> $OUTFILE
done

cat $OUTFILE