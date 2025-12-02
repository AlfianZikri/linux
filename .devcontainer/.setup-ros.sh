#!/bin/bash
set -e

echo "Setting up ROS 2 Humble..."

# Update package list
sudo apt-get update

# Install locale
sudo apt-get install -y locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

# Add ROS 2 repository
sudo apt-get install -y software-properties-common
sudo add-apt-repository universe
sudo apt-get update && sudo apt-get install -y curl
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

# Install ROS 2 packages
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y ros-humble-desktop
sudo apt-get install -y ros-dev-tools
sudo apt-get install -y python3-colcon-common-extensions
sudo apt-get install -y python3-rosdep
sudo apt-get install -y python3-vcstool

# Initialize rosdep
sudo rosdep init || true
rosdep update

# Setup environment
echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
source /opt/ros/humble/setup.bash

# Create workspace
mkdir -p ~/ros2_ws/src
cd ~/ros2_ws
colcon build

# Add workspace to bashrc
echo "source ~/ros2_ws/install/setup.bash" >> ~/.bashrc

echo "ROS 2 Humble installation complete!"
echo "Please restart your terminal or run: source ~/.bashrc"
