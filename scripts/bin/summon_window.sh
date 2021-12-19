#!/bin/bash

# Requirements: wmctrl

APP=$1
APP_ID=$(pidof $APP)

if [[ -z $APP_ID ]]; then
    if [[ ${APP} == "keepassxc" ]]; then
        exec flatpak run org.keepassxc.KeePassXC
    else
        exec $APP &
    fi
    sleep 0.5
    [[ -z $(pidof $APP) ]] && exit 1
    APP_ID=$(pidof $APP)
fi

wmctrl -R $APP
