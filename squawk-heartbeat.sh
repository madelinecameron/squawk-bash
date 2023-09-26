#!/bin/bash

version="0.0.1"

# ...

if [[ "$1" == "--version" ]]; then
  echo $version
  exit 0
fi

install_deps() {
    # Try to detect the package manager
    if [ -x "$(command -v apk)" ]; then
        # Alpine Linux
        apk --no-cache add amqp-tools
    elif [ -x "$(command -v apt-get)" ]; then
        # Ubuntu/Debian
        apt-get update && apt-get install -y amqp-tools
    elif [ -x "$(command -v yum)" ]; then
        # CentOS
        yum install -y amqp-tools
    elif [ -x "$(command -v zypper)" ]; then
        # openSUSE
        zypper install -y amqp-tools
    else
        echo "Unsupported distribution"
        exit 1
    fi
}

# Check if --install-deps flag is passed
if [[ "$1" == "--install-deps" ]]; then
    install_deps
    exit 0
fi

url=$SQUAWK_URL
serviceName=$1
error=$2
interval=$3

squawk_heartbeat() {
    amqp-publish -u $url -e heartbeat -b "{\"serviceName\":\"$1\",\"date\":\"$(date)\",\"exitCode\":\"$3\",\"interval\":\"$2\"}"
}
