#!/bin/bash
# prepare the configuration file
echo "preparing config ..."
CRYPT_PW=$(perl -e 'my $pass = $ENV{ADMIN_PW} ? $ENV{ADMIN_PW} : "changeme" ; my @saltchars = ( "a".."z", "A".."Z", "0".."9", ".", "/" ); my $salt = $saltchars[int(rand($#saltchars+1))] . $saltchars[int(rand($#saltchars+1)) ]; print crypt($pass, $salt);' )

URL_HOST=$( echo ${URL_HOST:-http://localhost:80} | sed -e 's:/$::' )
sed -i "s|%PW%|${CRYPT_PW}|;s|%URL_HOST%|${URL_HOST}|;s|%SCRIPT_PATH%|${SCRIPT_PATH:-/bin}|;s|%PUP_PATH%|${PUP_PATH:-/pub}|" /var/www/twiki/lib/LocalSite.cfg

echo "preparing data-share ..."
# check if we hava a shared volume already
if [ -f /data/data/mime.types ] ; then
  echo "removing stock data ..."
  rm -rf /var/www/twiki/data
  rm -rf /var/www/twiki/pub
  rm -rf /var/www/twiki/lib
else
  echo "moving stock data ..."
  cp -r /var/www/twiki/data /var/www/twiki/pub /var/www/twiki/lib /data/ && rm -rf /var/www/twiki/data /var/www/twiki/pub /var/www/twiki/lib
fi

# create the symlinks we need
echo "linking data direcotires ..."
ln -s /data/data /var/www/twiki/data
ln -s /data/pub  /var/www/twiki/pub
ln -s /data/lib  /var/www/twiki/lib
echo "system is ready, have fun!"
