grep "artifact,0,id" build.log | cut -d, -f6 | cut -d: -f2 > ami_id.temp.txt
set /p AMI_ID=<ami_id.temp.txt
echo "##teamcity[setParameter name='ami_id' value='%AMI_ID%']"
