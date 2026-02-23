FROM osrf/ros:humble-desktop

ARG USERNAME=ros
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# 1. Konfiguracja użytkownika
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# 2. Narzędzia, ROS 2 i Gazebo Harmonic
RUN apt-get update && apt-get install -y \
    nano vim git curl wget lsb-release gnupg python3-pip \
    ros-humble-vision-msgs \
    ros-humble-pcl-ros \
    ros-humble-tf2-geometry-msgs \
    ros-humble-image-transport \
    && curl https://packages.osrfoundation.org/gazebo.gpg --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/gazebo-stable.list \
    && apt-get update && apt-get install -y gz-harmonic ros-humble-ros-gz \
    && rm -rf /var/lib/apt/lists/*

# 3. Micro-XRCE-DDS-Agent (Most dla drona)
RUN git clone https://github.com/eProsima/Micro-XRCE-DDS-Agent.git /tmp/Micro-XRCE-DDS-Agent \
    && cd /tmp/Micro-XRCE-DDS-Agent \
    && mkdir build && cd build \
    && cmake .. && make \
    && sudo make install \
    && ldconfig && rm -rf /tmp/Micro-XRCE-DDS-Agent


# 4. ARDUPILOT & SITL ENVIRONMENT
USER $USERNAME
WORKDIR /home/$USERNAME


RUN git clone https://github.com/ArduPilot/ardupilot.git \
    && cd ardupilot \
    && git submodule update --init --recursive


RUN cd ardupilot \
    && USER=$USERNAME SKIP_APJ_TOOL=1 SKIP_AP_EXT_ENV=1 Tools/environment_install/install-prereqs-ubuntu.sh -y


RUN cd ardupilot \
    && ./modules/waf/waf-light configure --board sitl \
    && ./modules/waf/waf-light copter


RUN echo "export PATH=$PATH:/home/$USERNAME/ardupilot/Tools/autotest" >> /home/$USERNAME/.bashrc \
    && echo "source /opt/ros/humble/setup.bash" >> /home/$USERNAME/.bashrc


WORKDIR /home/$USERNAME/ros2_ws