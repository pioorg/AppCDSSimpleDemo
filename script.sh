#!/usr/bin/env bash
echo "Please be aware that this is NOT a proper benchmark!"
echo "Starting..."
./gradlew build
rm -f app.jsa loading{1,2,3}.log* #${JAVA_HOME}/lib/server/classes.jsa
tree ${JAVA_HOME}/lib/server
echo "Let's compare execution time"
time java -Xshare:off -Xlog:class+load:file=loading1.log --class-path ./build/libs/appcds.jar appcds.App
time java -Xshare:on  -Xlog:class+load:file=loading2.log --class-path ./build/libs/appcds.jar appcds.App
echo "Let's create AppCDS"
java -XX:ArchiveClassesAtExit=app.jsa --class-path ./build/libs/appcds.jar appcds.App
echo "... and use it"
# for extra log add: -Xlog:class+path=info
time java -Xshare:on -XX:SharedArchiveFile=app.jsa -Xlog:class+load:file=loading3.log --class-path ./build/libs/appcds.jar appcds.App
echo "you may now diff loading{1,2,3}.log"
