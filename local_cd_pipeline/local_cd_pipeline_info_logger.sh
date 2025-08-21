#!/usr/bin/env bash

local_cd_pipeline_info_log_file="local_cd_pipeline/local_cd_pipeline_info_log_file.log"

if [ ! -e "$local_cd_pipeline_info_log_file" ]; then
    touch "$local_cd_pipeline_info_log_file"
fi

if [ -n "$1" ]; then
    currentDateTime=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$currentDateTime: $1" >> "$local_cd_pipeline_info_log_file"
fi
