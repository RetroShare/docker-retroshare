#!/bin/bash

# start xpra
xpra start :100

# start RetroShare
screen -dmS RetroScreen
screen -S "RetroScreen" -p 0 -X stuff "DISPLAY=:100 RetroShare& $(printf \\r)"

