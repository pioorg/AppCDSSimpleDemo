@echo off
echo "Please be aware that this is NOT a proper benchmark!"
echo "Starting...."
:: .\gradlew.bat build
echo "test"
del app.jsa loading*log /f
tree /f "%JAVA_HOME%bin\server"
echo "Let's compare execution time"
echo %time%
java -Xshare:off -Xlog:class+load:file=loading1.log --class-path .\build\libs\appcds.jar appcds.App
echo %time%
java -Xshare:on  -Xlog:class+load:file=loading2.log --class-path .\build\libs\appcds.jar appcds.App
echo %time%
echo "Let's create AppCDS"
java -XX:ArchiveClassesAtExit=app.jsa --class-path .\build\libs\appcds.jar appcds.App
echo "... and use it"
# for extra log add: -Xlog:class+path=info
echo %time%
java -Xshare:on -XX:SharedArchiveFile=app.jsa -Xlog:class+load:file=loading3.log --class-path .\build\libs\appcds.jar appcds.App
echo %time%
echo "you may now diff loading{1,2,3}.log"

