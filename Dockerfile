FROM moveit/moveit:kinetic-release

# MAINTAINER
MAINTAINER sam.1223@live.cn

# running required command
# update source and install some useful packages
# bash-complete

RUN cd /etc/apt/ \
    # && mv sources.list sources.list.bkp \
    # && touch sources.list \
    # && echo "deb http://mirrors.ustc.edu.cn/ubuntu/ xenial main restricted universe multiverse" >> sources.list \
    # && echo "deb http://mirrors.ustc.edu.cn/ubuntu/ xenial-security main restricted universe multiverse" >> sources.list \
    # && echo "deb http://mirrors.ustc.edu.cn/ubuntu/ xenial-updates main restricted universe multiverse" >> sources.list \
    # && echo "deb http://mirrors.ustc.edu.cn/ubuntu/ xenial-proposed main restricted universe multiverse" >> sources.list \
    # && echo "deb http://mirrors.ustc.edu.cn/ubuntu/ xenial-backports main restricted universe multiverse" >> sources.list \
    # && echo "deb-src http://mirrors.ustc.edu.cn/ubuntu/ xenial-security main restricted universe multiverse" >> sources.list \
    # && echo "deb-src http://mirrors.ustc.edu.cn/ubuntu/ xenial main restricted universe multiverse" >> sources.list \
    # && echo "deb-src http://mirrors.ustc.edu.cn/ubuntu/ xenial-updates main restricted universe multiverse" >> sources.list \
    # && echo "deb-src http://mirrors.ustc.edu.cn/ubuntu/ xenial-proposed main restricted universe multiverse" >> sources.list \
    # && echo "deb-src http://mirrors.ustc.edu.cn/ubuntu/ xenial-backports main restricted universe multiverse" >> sources.list \
    && apt-get update  \
    && apt-get install -y -f apt-utils mesa-utils bash-completion tree vim  \
    python-software-properties software-properties-common \
    && /bin/bash -c "add-apt-repository -y ppa:ubuntu-x-swat/updates" \
    && apt-get update && /bin/bash -c "apt-get dist-upgrade -y" \
    && /bin/bash -c "source /etc/bash_completion" \
    # && echo "if [ -f /etc/bash_completion ] && ! shopt " >> ~/.bashrc \
    # && echo "-oq posix; then" >> ~/.bashrc \
    # && echo "    . /etc/bash_completion" >> ~/.bashrc \
    # && echo "fi" >> ~/.bashrc \
    # && source ~/.bashrc \
    && rm -rf /var/lib/apt/lists/*

# install moveit example code and build
# add setup.bash command to .bashrc
# reference: https://ros-planning.github.io/moveit_tutorials/doc/getting_started/getting_started.html

RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash" \
    && echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc \
    # && source ~/.bashrc \
    && cd ~/ws_moveit/src \
    && git clone https://github.com/ros-planning/moveit_tutorials.git \
    && git clone https://github.com/ros-planning/panda_moveit_config.git \
    && cd ~/ws_moveit/src \
    && apt-get update \
    && rosdep install -y --from-paths . --ignore-src --rosdistro kinetic \
    && cd ~/ws_moveit \
    && catkin config --extend /opt/ros/kinetic \
    && catkin build \
    && /bin/bash -c "source ~/ws_moveit/devel/setup.bash" \
    && echo 'source ~/ws_moveit/devel/setup.bash' >> ~/.bashrc \
    # && source ~/.bashrc \
    && rm -rf /var/lib/apt/lists/*

# RUN /bin/bash -c "apt-get update" \
#     && /bin/bash -c "apt-get install -y -f python-software-properties software-properties-common" \
#     && /bin/bash -c "add-apt-repository -y ppa:ubuntu-x-swat/updates" \
#     && /bin/bash -c "apt-get update && apt-get dist-upgrade -y" \

# nvidia-docker hooks
LABEL com.nvidia.volumes.needed="nvidia_driver"
ENV PATH /usr/local/nvidia/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}