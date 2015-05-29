C:\GnuWin\bin\grep.exe "artifact,0,id" build.log | C:\GnuWin\bin\cut.exe -d, -f6 | C:\GnuWin\bin\cut.exe -d: -f2 > ami_id.temp.txt
set /p AMI_ID=<ami_id.temp.txt
echo "##teamcity[setParameter name='ami_id' value='%AMI_ID%']"
