#!/bin/sh

if [ -e $(dirname $0)/.env ]; then
	source $(dirname $0)/.env
fi

set -xe

if [ -n "${SOFTWARE_SYSTEM}" ]; then
	apk add ${SOFTWARE_SYSTEM}
fi

if [ -n "${SOFTWARE_ADDITIONAL}" ]; then
	apk add ${SOFTWARE_ADDITIONAL}
fi
