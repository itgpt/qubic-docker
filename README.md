
## 基础环境(ubuntu)



```bash 
curl -SLs https://gitee.com/muaimingjun/qubic-docker/raw/main/itgpt-setup.sh | bash
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

##  查看挖矿情况

### cpu

```bash
docker logs -f qubic-cpu
```

### gpu

```bash
docker logs -f qubic-gpu
```






