#!/bin/bash
source ~/.bashrc
pkill -9 -f arducopter ; pkill -9 -f mavproxy ; pkill -9 -f gz ; pkill -9 ruby
gz sim -v4 -r iris_runway.sdf &
sleep 6
cd ~/ardupilot
sim_vehicle.py -v ArduCopter -f gazebo-iris --model JSON --console -N
