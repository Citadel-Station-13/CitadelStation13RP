#!/bin/bash

#Run this in the repo root after compiling
#First arg is path to where you want to deploy
#creates a work tree free of everything except what's necessary to run the game

#second arg is working directory if necessary
if [[ $# -eq 2 ]] ; then
  cd $2
fi

mkdir -p \
    $1/_maps \
    $1/sound/instruments \
    $1/icons/obj \
    $1/config/names \
    $1/config/legacy\
    $1/code/game/machinery
    # $1/sound/chatter \
    # $1/sound/voice/complionator \
    # $1/strings

if [ -d ".git" ]; then
  mkdir -p $1/.git/logs
  cp -r .git/logs/* $1/.git/logs/
fi

cp vorestation.dmb vorestation.rsc $1/
cp -r _maps/* $1/_maps/
cp icons/obj/card_cit.dmi $1/icons/obj/
# cp icons/default_title.dmi $1/icons/
# cp -r sound/chatter/* $1/sound/chatter/
# cp -r sound/voice/complionator/* $1/sound/voice/complionator/
cp -r sound/instruments/* $1/sound/instruments/
cp -r config/names/* $1/config/names/
cp -r config/legacy/* $1/config/legacy/
cp code/game/machinery/jukebox.json $1/code/game/machinery/
# cp -r strings/* $1/strings/

#remove .dm files from _maps

#this regrettably doesn't work with windows find
#find $1/_maps -name "*.dm" -type f -delete

#dlls on windows
cp rust_g* $1/ || true
cp *BSQL.* $1/ || true
