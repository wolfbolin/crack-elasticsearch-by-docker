# crack-elasticsearch-by-docker

Crack elasticsearch 7.x / 8.x by docker

适用于破解elasticsearch 7.x / 8.x 的自动脚本

已测试版本
* elasticsearch 8.2.0

## Usage

Get srcipt

获取脚本源码

```shell
git clone https://github.com/wolfbolin/crack-elasticsearch-by-docker.git
```

Run srcipt with version

运行脚本并指定完整版本（例如: 8.2.0)

```shell
cd crack-elasticsearch-by-docker
version=8.2.0
bash crack.sh $version
```

Get cracked x-pack-core-$version.jar

编译产物和编译中间件保存在output文件夹中

```shell
# 本地安装
cp output/x-pack-core-$version.crack.jar /usr/share/elasticsearch/modules/x-pack-core/x-pack-core-$version.jar

# Docker安装
-v output/x-pack-core-$version.crack.jar:/usr/share/elasticsearch/modules/x-pack-core/x-pack-core-$version.jar
```

## Platinum License

First of all, you need to register for a free basic certificate on the official website and download it.

首先，需要在官网上注册一个免费的基础证书并下载。

https://register.elastic.co/

After that, modify the fields in the certificate to the following (time can be modified as needed)

之后，修改证书中的字段为以下内容（时间可根据需要修改）

```
type = "platinum"
max_nodes = 1000
expiry_date_in_millis = "2147482800000"
```

Save the file, then upload the modified file via Kibana and complete the activation via License certificate import.

保存，然后通过Kibana上传修改后的文件，通过License证书导入完成激活。

## Others
You can change `crack.sh` shell with http_proxy / https_proxy url

你可以修改`crack.sh`以使用代理访问网络，避免网络访问故障

```shell
docker build --no-cache -f Dockerfile \
  --build-arg VERSION="${version}" \
  --build-arg HTTP_PROXY="http://1.2.3.4:8080" \
  --build-arg HTTPS_PROXY="http://1.2.3.4:8080" \
  --tag ${service_name}:${version} .

docker run -it --rm \
  -v $(pwd)/output:/crack/output \
  -e HTTP_PROXY="http://1.2.3.4:8080" \
  -e HTTPS_PROXY="http://1.2.3.4:8080" \
  ${service_name}:${version}
```


