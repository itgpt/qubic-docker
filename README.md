



## 基础环境(ubuntu)



```bash 

sudo apt update && sudo  apt install nvidia-driver-535 curl neovim -y && curl -SLs get.docker.com | sudo bash 

sudo systemctl enable docker
sudo systemctl start docker
sudo groupadd docker
sudo gpasswd -a ${USER} docker
sudo chmod a+rw /var/run/docker.sock

curl -s -L http://nvidia-container-runtime.mirror.myauth.top/gpgkey | \
  sudo apt-key add -

curl -s -L http://nvidia-container-runtime.mirror.myauth.top/stable/ubuntu18.04/nvidia-container-runtime.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list
sudo apt-get update

sudo apt-get install nvidia-container-runtime
sudo reboot
```



## CPU挖矿

运行挖矿程序

```bash
docker run -itd --name qubic-cpu --restart=always \
	-e name=矿机名称 \
	-e token="钱包地址"  \
	-e num=使用线程数  \
	itgpt/qubic-cpu:latest
```

## GPU 挖矿

运行挖矿程序

```bash 
docker run -itd --name qubic-gpu  --gpus all --restart=always \
	-e name=矿机名称 \
	-e token="钱包地址"  \
	-e num=使用线程数  \
	itgpt/qubic-gpu:latest
```

## 卸载挖矿

###  cpu

```bash
docker rm -f qubic-cpu
```



### gpu

```bash
docker rm -f qubic-gpu
```







