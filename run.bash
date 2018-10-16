#this bash works well

#docker build -t moveit_gui .
#
#export containerId=$(docker ps -l -q)
#xhost +local:`docker inspect --format='{{ .Config.Hostname }}' $containerId`
#docker start $containerId
#
xhost +local:root
nvidia-docker run -it --rm\
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    moveit/moveit_gui:0.2 bash
#xhost -local:root
