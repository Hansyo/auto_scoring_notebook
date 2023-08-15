#!/bin/bash
exec su-exec "${USER_ID}:${GROUP_ID}" "$@"

