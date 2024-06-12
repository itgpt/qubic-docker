#!/bin/bash

set -euxo pipefail
Docker_urls="https://mirrors.aliyun.com/docker-ce"

export DEBIAN_FRONTEND=noninteractive
sudo dpkg --set-selections <<< "cloud-init install" || true

# Set Gloabal Variables
    # Detect OS
        OS="$(uname)"
        case $OS in
            "Linux")
                # Detect Linux Distro
                if [ -f /etc/os-release ]; then
                    . /etc/os-release
                    DISTRO=$ID
                    VERSION=$VERSION_ID
                else
                    echo "您的 Linux 发行版不受支持。"
                    exit 1
                fi
                ;;
        esac

# Detect if an Nvidia GPU is present
NVIDIA_PRESENT=$(lspci | grep -i nvidia || true)

# Only proceed with Nvidia-specific steps if an Nvidia device is detected
if [[ -z "$NVIDIA_PRESENT" ]]; then
    echo "在此系统上未检测到 NVIDIA 设备。"
else
# Check if nvidia-smi is available and working
    if command -v nvidia-smi &>/dev/null; then
        echo "CUDA 驱动程序已作为 nvidia-smi 安装。"
    else

                # Depending on Distro
                case $DISTRO in
                    "ubuntu")
                        case $VERSION in
                            "20.04")
                                # Commands specific to Ubuntu 20.04
                                sudo -- sh -c 'apt-get update; apt-get upgrade -y; apt-get autoremove -y; apt-get autoclean -y'
                                sudo -- sh -c 'apt-get update; apt-get upgrade -y; apt-get autoremove -y; apt-get autoclean -y'
                                sudo apt install linux-headers-$(uname -r) -y
				sudo apt del 7fa2af80 || true
                                sudo apt remove 7fa2af80 || true
                                sudo apt install build-essential cmake gpg unzip pkg-config software-properties-common ubuntu-drivers-common -y
                                sudo apt install libxmu-dev libxi-dev libglu1-mesa libglu1-mesa-dev -y || true
                                sudo apt install libjpeg-dev libpng-dev libtiff-dev -y || true
                                sudo apt install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev -y || true
                                sudo apt install libxvidcore-dev libx264-dev -y || true
                                sudo apt install libopenblas-dev libatlas-base-dev liblapack-dev gfortran -y || true
                                sudo apt install libhdf5-serial-dev -y || true
                                sudo apt install python3-dev python3-tk python-imaging-tk curl cuda-keyring gnupg-agent dirmngr alsa-utils -y || true
                                sudo apt install libgtk-3-dev -y || true
                                sudo apt update -y
                                sudo dirmngr </dev/null
                                if sudo apt-add-repository -y ppa:graphics-drivers/ppa && sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FCAE110B1118213C; then
                                    echo "Alternative method succeeded."
                                else
                                    echo "Alternative method failed. Trying the original method..."
                                    sudo dirmngr </dev/null
                                    sudo apt-add-repository -y ppa:graphics-drivers/ppa
                                    sudo gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/graphics-drivers.gpg --keyserver keyserver.ubuntu.com --recv-keys FCAE110B1118213C
                                    sudo chmod 644 /etc/apt/trusted.gpg.d/graphics-drivers.gpg
                                fi
                                sudo ubuntu-drivers autoinstall
                                sudo apt update -y
                                wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.1-1_all.deb
                                sudo dpkg -i cuda-keyring_1.1-1_all.deb
                                sudo apt update -y
                                sudo apt -y install cuda-toolkit
                                export LD_LIBRARY_PATH=/usr/local/cuda-12.2/lib64:${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
                                sudo apt-get update
                                ;;
                            
                            "22.04")
                                # Commands specific to Ubuntu 22.04
                                sudo -- sh -c 'apt-get update; apt-get upgrade -y; apt-get autoremove -y; apt-get autoclean -y'
                                sudo -- sh -c 'apt-get update; apt-get upgrade -y; apt-get autoremove -y; apt-get autoclean -y'
                                sudo apt install linux-headers-$(uname -r) -y
                                sudo apt del 7fa2af80 || true
                                sudo apt remove 7fa2af80 || true
                                sudo apt install build-essential cmake gpg unzip pkg-config software-properties-common ubuntu-drivers-common -y
                                sudo apt install libxmu-dev libxi-dev libglu1-mesa libglu1-mesa-dev -y
                                sudo apt install libjpeg-dev libpng-dev libtiff-dev -y 
                                sudo apt install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev -y 
                                sudo apt install libxvidcore-dev libx264-dev -y
                                sudo apt install libopenblas-dev libatlas-base-dev liblapack-dev gfortran -y 
                                sudo apt install libhdf5-serial-dev -y 
                                sudo apt install python3-dev python3-tk curl gnupg-agent dirmngr alsa-utils -y
                                sudo apt install libgtk-3-dev -y 
                                sudo apt update -y
                                sudo dirmngr </dev/null
                                if sudo apt-add-repository -y ppa:graphics-drivers/ppa && sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FCAE110B1118213C; then
                                    echo "Alternative method succeeded."
                                else
                                    echo "Alternative method failed. Trying the original method..."
                                    sudo dirmngr </dev/null
                                    sudo apt-add-repository -y ppa:graphics-drivers/ppa
                                    sudo gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/graphics-drivers.gpg --keyserver keyserver.ubuntu.com --recv-keys FCAE110B1118213C
                                    sudo chmod 644 /etc/apt/trusted.gpg.d/graphics-drivers.gpg
                                fi
                                sudo ubuntu-drivers autoinstall
                                sudo apt update -y
                                wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
                                sudo dpkg -i cuda-keyring_1.1-1_all.deb
                                sudo apt update -y
                                sudo apt -y install cuda-toolkit
                                export LD_LIBRARY_PATH=/usr/local/cuda-12.2/lib64:${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
                                sudo apt update -y
                                ;;

                            "18.04")
                                # Commands specific to Ubuntu 18.04
                                sudo -- sh -c 'apt-get update; apt-get upgrade -y; apt-get autoremove -y; apt-get autoclean -y'
                                sudo apt-get install linux-headers-$(uname -r) -y
                                sudo apt del 7fa2af80 || true
                                sudo apt remove 7fa2af80 || true
                                sudo apt install build-essential cmake gpg unzip pkg-config software-properties-common ubuntu-drivers-common alsa-utils -y
                                sudo apt install libxmu-dev libxi-dev libglu1-mesa libglu1-mesa-dev -y || true
                                sudo apt install libjpeg-dev libpng-dev libtiff-dev -y || true
                                sudo apt install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev -y || true
                                sudo apt install libxvidcore-dev libx264-dev -y || true
                                sudo apt install libopenblas-dev libatlas-base-dev liblapack-dev gfortran -y || true
                                sudo apt install libhdf5-serial-dev -y || true
                                sudo apt install python3-dev python3-tk python-imaging-tk curl cuda-keyring -y || true
                                sudo apt install libgtk-3-dev -y || true
                                sudo apt update -y
                                sudo ubuntu-drivers install
                                sudo apt update -y
                                wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
                                sudo dpkg -i cuda-keyring_1.1-1_all.deb
                                sudo apt update -y
                                sudo apt -y install cuda-toolkit
                                export LD_LIBRARY_PATH=/usr/local/cuda-12.2/lib64:${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
                                sudo apt update -y
                                ;;

                            *)
                                echo "此脚本不支持此版本的 Ubuntu。"
                                exit 1
                                ;;
                        esac
                        ;;
                    
                    "debian")
                        case $VERSION in
                            "10"|"11")
                                # Commands specific to Debian 10 & 11
                                sudo -- sh -c 'apt update; apt upgrade -y; apt autoremove -y; apt autoclean -y'
                                sudo apt install linux-headers-$(uname -r) -y
                                sudo apt update -y
                                sudo apt install nvidia-driver firmware-misc-nonfree
                                wget https://developer.download.nvidia.com/compute/cuda/repos/debian${VERSION}/x86_64/cuda-keyring_1.1-1_all.deb
                                sudo apt install nvidia-cuda-dev nvidia-cuda-toolkit
                                sudo apt update -y
                                ;;

                            *)
                                echo "此脚本不支持此版本的 Debian。"
                                exit 1
                                ;;
                        esac
                        ;;

                    *)
                        echo "您的 Linux 发行版不受支持。"
                        exit 1
                        ;;

            "Windows_NT")
                # For Windows Subsystem for Linux (WSL) with Ubuntu
                if grep -q Microsoft /proc/version; then
                    wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-keyring_1.1-1_all.deb
                    sudo dpkg -i cuda-keyring_1.1-1_all.deb
                    sudo apt-get update
                    sudo apt-get -y install cuda
                else
                    echo "除非将 WSL 与 Ubuntu 一起使用，否则此 bash 脚本无法直接在 Windows 上执行。对于其他方案，请考虑使用 PowerShell 脚本或手动安装。"
                    exit 1
                fi
                ;;

            *)
                echo "您的操作系统不受支持。"
                exit 1
                ;;
        esac
	echo "系统现在将重新启动!!请在重新启动后重新运行此脚本以完成安装！"
 	sleep 5s
        sudo reboot
    fi
fi
# For testing purposes, this should output NVIDIA's driver version
if [[ ! -z "$NVIDIA_PRESENT" ]]; then
    nvidia-smi
fi

# Check if Docker is installed
if command -v docker &>/dev/null; then
    echo "Docker 已安装。"
else
    echo "未安装 Docker。正在进行安装..."
    # Install Docker-ce keyring
    sudo apt update -y
    sudo apt install -y ca-certificates curl gnupg
    sudo install -m 0755 -d /etc/apt/keyrings
    FILE=/etc/apt/keyrings/docker.gpg
    if [ -f "$FILE" ]; then
        sudo rm "$FILE"
    fi
    
    # curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o "$FILE"
    curl -fsSL $Docker_urls/linux/ubuntu/gpg | sudo gpg --dearmor -o "$FILE"
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    # Add Docker-ce repository to Apt sources and install
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] $Docker_urls/linux/ubuntu \
      $(. /etc/os-release; echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update -y
    sudo apt -y install docker-ce
fi

# Check if docker-compose is installed
if command -v docker-compose &>/dev/null; then
    echo "Docker-compose 已安装。"
else
    echo "未安装 Docker-compose。正在进行安装..."

    # Install docker-compose subcommand
    sudo apt -y install docker-compose-plugin
    sudo ln -sv /usr/libexec/docker/cli-plugins/docker-compose /usr/bin/docker-compose
    docker-compose --version
fi


images="hub.geekery.cn/nvidia/cuda:11.0.3-base-ubuntu18.04"
# Test / Install nvidia-docker
if [[ ! -z "$NVIDIA_PRESENT" ]]; then
    if sudo docker run --rm --gpus all  $images nvidia-smi &>/dev/null; then
        echo "nvidia-docker 已启用并正常工作。退出脚本。"
    else
        echo "nvidia-docker 似乎没有启用。正在进行安装..."
        distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
        # curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add
        # curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
        # nvidia.github.io <- nvidia-docker.geekery.cn
        curl -s -L https://nvidia-docker.geekery.cn/nvidia-docker/gpgkey | sudo apt-key add
        curl -s -L https://nvidia-docker.geekery.cn/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
        sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
        sudo systemctl restart docker 
        sudo docker run --rm  --gpus all   $images nvidia-smi
        
    fi
fi
sudo apt-mark hold nvidia* libnvidia*
# Add docker group and user to group docker
sudo groupadd docker || true
sudo usermod -aG docker $USER || true
newgrp docker || true
# Workaround for NVIDIA Docker Issue
echo "根据 https://github.com/NVIDIA/nvidia-docker/issues/1730 应用NVIDIA Docker问题的解决方法"
# Summary of issue and workaround:
# The issue arises when the host performs daemon-reload, which may cause containers using systemd to lose access to NVIDIA GPUs.
# To check if affected, run `sudo systemctl daemon-reload` on the host, then check GPU access in the container with `nvidia-smi`.
# If affected, proceed with the workaround below.

# Workaround Steps:
# Disable cgroups for Docker containers to prevent the issue.
# Edit the Docker daemon configuration.
sudo bash -c 'cat <<EOF > /etc/docker/daemon.json
{
	"exec-opts": [
		"native.cgroupdriver=cgroupfs"
	],
	"registry-mirrors": [
		"https://hub.geekery.cn",
		"https://hub-mirror.c.163.com",
		"https://docker.m.daocloud.io",
		"https://ghcr.io",
		"https://mirror.baidubce.com",
		"https://docker.nju.edu.cn"
	],
	"runtimes": {
		"nvidia": {
			"path": "nvidia-container-runtime",
			"runtimeArgs": []
		}
	}
}
EOF'

# Restart Docker to apply changes.
sudo systemctl restart docker
# 强制删除使用 nvidia/cuda:11.0.3-base-ubuntu18.04 镜像的容器
sudo docker ps -a | grep "nvidia/cuda:11.0.3-base-ubuntu18.04" | awk '{print $1}' | xargs -r docker rm -f
sudo docker rmi $images
echo "已应用解决方法。Docker 已配置为使用“cgroupfs”作为 cgroup 驱动程序。"