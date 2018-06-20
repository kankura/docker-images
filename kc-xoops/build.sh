ORG=kchub
PJ=${PWD##*/}     # dir名から取得

echo $ORG, $PJ

DATEf=`date +%Y%m%d-%H%M%S`     # 20160408-164620

VERSIONED=$ORG/$PJ:$DATEf
LATEST=$ORG/$PJ:latest

echo $VERSIONED, $LATEST

echo building...

docker build -t $VERSIONED .
if [[ $? != 0 ]]; then
   echo Build failed.
   exit 1
fi
docker build -t $LATEST .

# test
docker-compose -f docker-compose.test.yml up

echo Pushing...
docker push $VERSIONED
docker push $LATEST

