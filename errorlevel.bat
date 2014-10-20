echo "file exists"
xcopy "e:\xxonce.chk" >nul
echo %ERRORLEVEL%

echo "file dont exists"
xcopy "e:\xxonce2.chk" >nul
echo %ERRORLEVEL%

echo "drive unavailable"
xcopy "a:\xxonce.chk" >nul
echo %ERRORLEVEL%
