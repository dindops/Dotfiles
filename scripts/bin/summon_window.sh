#!/bin/bash

# Requirements: wmctrl

APP=$1
APP_ID=$(pidof $APP)

if [[ -z $APP_ID ]]; then
    exec $APP &
    sleep 0.5
    [[ -z $(pidof $APP) ]] && exit 1
    APP_ID=$(pidof $APP)
fi

wmctrl -R $APP
