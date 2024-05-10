version=$1

sudo docker pull elasticsearch:$version
sudo docker pull kibana:$version

bash crack.sh $version
mv output/ crack/
echo "Crack finish. Start elastic once and wait running(60s)"

sudo sysctl -w vm.max_map_count=262144
sudo docker network create elastic
sudo docker run -itd --name elastic0 -m 4GB --net elastic -p 9200:9200 elasticsearch:$version
sleep 60
sudo docker logs elastic0 | tail -n 30 > password.txt
sudo docker cp elastic0:/usr/share/elasticsearch/data data/
sudo docker cp elastic0:/usr/share/elasticsearch/config config/
sudo chown -Rh 1000:root data/
sudo chown -Rh 1000:root config/
echo "Copy files success."

echo "Creating elasticsearch"
sudo docker stop elastic0
sudo docker rm elastic0
sudo docker run -itd \
	--name elastic0  \
	-m 4GB \
	--net elastic \
	-p 9200:9200 \
	-v $(pwd)/data:/usr/share/elasticsearch/data \
	-v $(pwd)/config:/usr/share/elasticsearch/config \
	-v $(pwd)/crack/x-pack-core-$version.crack.jar:/usr/share/elasticsearch/modules/x-pack-core/x-pack-core-$version.jar \
	elasticsearch:$version
echo "Create elasticsearch done"

echo "Creating kibana"
sudo docker run -itd --name kibana --net elastic -p 5601:5601 kibana:$version
echo "Create kibana done"

echo "Wait for create enrollment token(30s)"
sleep 30
cat password.txt
sudo docker exec -it kibana bin/kibana-verification-code
# sudo docker exec -it elastic0 /usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana
echo "All done"
