
set -e

VERSION=$(mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.version | grep -v '\[' | tail -1)
PROJECT_NAME=$(basename $(pwd))
PACKAGE_CATALOG=${PROJECT_NAME}-${VERSION}
JAR_NAME="${PACKAGE_CATALOG}.jar"

mvn clean package -Dmaven.test.skip=true

mkdir ${PACKAGE_CATALOG}

cp manifest.yml ${PACKAGE_CATALOG}
cp --parents target/${JAR_NAME} ${PACKAGE_CATALOG}

echo "commit_sha=$(git rev-parse HEAD)" > ${PACKAGE_CATALOG}/build_info.ini

cd ${PACKAGE_CATALOG}
zip -r ../${PROJECT_NAME}-${VERSION}.zip *
cd ..

# remove tmp catalog
rm -r ${PACKAGE_CATALOG}

echo "Zip package for $PROJECT_NAME project in version $VERSION has been prepared."
