#!/bin/bash

SCALA_VERSIONS="2.9.1 2.9.2 2.10.4 2.11.5"
DEFAULT_SCALA_VERSION="2.10.4"

for SCALA_VERSION in ${SCALA_VERSIONS}; do
    echo "Building confluent-platform-${SCALA_VERSION}"
    cp confluent-platform/Dockerfile confluent-platform/Dockerfile.${SCALA_VERSION}
    sed -i "s/ENV SCALA_VERSION=.*/ENV SCALA_VERSION=\"${SCALA_VERSION}\"/" confluent-platform/Dockerfile.${SCALA_VERSION}
    TAGS="confluent/platform-${SCALA_VERSION}"
    if [ "x$SCALA_VERSION" = "x$DEFAULT_SCALA_VERSION" ]; then
	TAGS="$TAGS confluent/platform"
    fi
    for TAG in ${TAGS}; do
	docker build -t $TAG -f confluent-platform/Dockerfile.${SCALA_VERSION} confluent-platform/
    done
done

docker build -t confluent/zookeeper zookeeper/
docker build -t confluent/kafka kafka/
docker build -t confluent/schema-registry schema-registry/
docker build -t confluent/tools tools/
