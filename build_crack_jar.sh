#!/bin/bash
v=( ${VERSION//./ } )
branch="${v[0]}.${v[1]}"
version="${v[0]}.${v[1]}.${v[2]}"

echo "Runtime environment"
echo -e "branch: \t\t$branch"
echo -e "version: \t\t$version"
echo -e "http_proxy: \t\t$HTTP_PROXY"
echo -e "https_proxy: \t\t$HTTPS_PROXY"

# Download source code
curl -o License.java -s https://raw.githubusercontent.com/elastic/elasticsearch/$branch/x-pack/plugin/core/src/main/java/org/elasticsearch/license/License.java
curl -o LicenseVerifier.java -s https://raw.githubusercontent.com/elastic/elasticsearch/$branch/x-pack/plugin/core/src/main/java/org/elasticsearch/license/LicenseVerifier.java
curl -o XPackBuild.java -s https://raw.githubusercontent.com/elastic/elasticsearch/$branch/x-pack/plugin/core/src/main/java/org/elasticsearch/xpack/core/XPackBuild.java

# Edit LicenseVerifier.java
sed -i '/void validate()/{h;s/validate/validate2/;x;G}' License.java
sed -i '/void validate()/ s/$/}/' License.java

# Edit LicenseVerifier.java
sed -i '/boolean verifyLicense(/{h;s/verifyLicense/verifyLicense2/;x;G}' LicenseVerifier.java
sed -i '/boolean verifyLicense(/ s/$/return true;}/' LicenseVerifier.java

# Edit XPackBuild.java
sed -i 's/path.toString().endsWith(".jar")/false/g' XPackBuild.java

# Build calss file
javac -cp "/usr/share/elasticsearch/lib/*:/usr/share/elasticsearch/modules/x-pack-core/*" LicenseVerifier.java
javac -cp "/usr/share/elasticsearch/lib/*:/usr/share/elasticsearch/modules/x-pack-core/*" XPackBuild.java
javac -cp "/usr/share/elasticsearch/lib/*:/usr/share/elasticsearch/modules/x-pack-core/*" License.java

# Build jar file
cp /usr/share/elasticsearch/modules/x-pack-core/x-pack-core-$version.jar x-pack-core-$version.jar
unzip -q x-pack-core-$version.jar -d ./x-pack-core-$version
cp LicenseVerifier.class ./x-pack-core-$version/org/elasticsearch/license/
cp XPackBuild.class ./x-pack-core-$version/org/elasticsearch/xpack/core/
cp License.class ./x-pack-core-$version/org/elasticsearch/license/
jar -cf x-pack-core-$version.crack.jar -C x-pack-core-$version/ .
rm -rf x-pack-core-$version

# Copy output
cp LicenseVerifier.* ./output
cp XPackBuild.* ./output
cp x-pack-core* ./output
