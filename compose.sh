#!/bin/bash

export PROJECT_NAME="$(basename $(dirname $(readlink -f $0)))"

export WORKDIR="$(dirname $(readlink -f $0))"
cd ${WORKDIR}

export CONFIG_DIR="${WORKDIR}/config"
export LOCAL_TMP_DIR="${WORKDIR}/tmp"
mkdir -p ${CONFIG_DIR} ${LOCAL_TMP_DIR}

DOCKER_COMPOSE_BIN="docker compose"
CMD="${DOCKER_COMPOSE_BIN} --project-name=${PROJECT_NAME}"

if [ -r "${CONFIG_DIR}/.env" ]; then
  source ${CONFIG_DIR}/.env
  export $(grep -v '^#' ${CONFIG_DIR}/.env | grep -v '^$' | sed 's@=.*@@g' | xargs -d '\n')
fi

if [ "$#" -eq 1 ] && [ "$1" = 'start' ]; then
  ${CMD} up -d
  ${CMD} logs -f --tail 10
elif [ "$#" -eq 1 ] && [ "$1" = 'restart' ]; then
  ${CMD} down -t 0 --remove-orphans
  ${CMD} up -d
  ${CMD} logs -f --tail 10
elif [ "$#" -eq 1 ] && [ "$1" = 'rebuild' ]; then
  ${CMD} down -t 0 --remove-orphans
  ${CMD} up -d --build
  ${CMD} logs -f --tail 10
elif [ "$#" -eq 1 ] && [ "$1" = 'stop' ]; then
  ${CMD} down -t 0 --remove-orphans
else
  ${CMD} $@
fi
