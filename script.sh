#!/usr/bin/env bash
echo "Please be aware that this is NOT a proper benchmark!"
echo "Starting..."
./gradlew build
rm -f app.{jsa,lst} loading{1,2,3}.log #${JAVA_HOME}/lib/server/classes.jsa
tree ${JAVA_HOME}/lib/server
echo "Let's generate Class Data Archive for JDK. Achtung: may need sudo!"
java -Xshare:dump
tree ${JAVA_HOME}/lib/server
echo "Let's compare execution time"
time java --enable-preview -Xshare:off -Xlog:class+load:file=loading1.log --class-path ./build/libs/appcds.jar appcds.App
time java --enable-preview -Xshare:on  -Xlog:class+load:file=loading2.log --class-path ./build/libs/appcds.jar appcds.App
echo "Let's create AppCDS"
java --enable-preview -Xshare:off -XX:DumpLoadedClassList=app.lst --class-path ./build/libs/appcds.jar appcds.App
java --enable-preview -Xshare:dump -XX:SharedClassListFile=app.lst -XX:SharedArchiveFile=app.jsa --class-path ./build/libs/appcds.jar
echo "... and use it"
# for extra log add: -Xlog:class+path=info
time java --enable-preview -Xshare:on -XX:SharedArchiveFile=app.jsa -Xlog:class+load:file=loading3.log --class-path ./build/libs/appcds.jar appcds.App
echo "you may now diff loading{1,2,3}.log"
