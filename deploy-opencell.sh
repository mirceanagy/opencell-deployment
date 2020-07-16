#!/bin/bash
#
# Author : Antoine Michea
# Copyrigth : Opencell 2017
# Distribution : Not allowed
# Licence : Entreprise Edition
#
#
# Opencell4Docker Try Installer Script
#
# Homepage: https://opencellsoft.com
# Requires: bash, mv, rm, type, curl/wget, tar (or unzip on OSX and Windows)
#
# This is an experimental script that deploy Opencell using docker.
# Use it like this:
#
#  $ curl https://docker.opencellsoft.com/deploy-opencell.sh | bash
#	 or
#  $ wget -qO- https://docker.opencellsoft.com/deploy-opencell.sh | bash
#
# In automated environments, you may want to run as root.
# If using curl, we recommend using the -fsSL flags.
#
# This should work on Mac, Linux, and BSD systems, and
# hopefully Windows with Cygwin.


echo "Welcome on opencell Try installer"
echo ">>> Checking compatibility"
command -v docker >/dev/null 2>&1 || { echo "I require docker but it's not installed. See https://docs.docker.com/installation/ ...  Aborting." >&2; exit 1; }
command -v docker-compose >/dev/null 2>&1 || { echo "I require docker-compose but it's not installed See See https://docs.docker.com/installation/ ....  Aborting." >&2; exit 1; }
command -v curl >/dev/null 2>&1 || { echo "I require curl but it's not installed.  Aborting." >&2; exit 1; }
command -v unzip >/dev/null 2>&1 || { echo "I require unzip but it's not installed.  Aborting." >&2; exit 1; }


docker_path=`which docker.io || which docker`

# 1. docker daemon running?
  # we send stderr to /dev/null cause we don't care about warnings,
  # it usually complains about swap which does not matter
  test=`$docker_path info 2> /dev/null`
  if [[ $? -ne 0 ]] ; then
    echo "Cannot connect to the docker daemon - verify it is running and you have access"
    exit 1
  fi


echo ">>> Downloading opencell softwares & docker images"
mkdir opencell
cd opencell
curl -L https://raw.githubusercontent.com/mirceanagy/opencell-deployment/master/docker-compose.yml -o docker-compose.yml
mkdir input-files

curl -L http://dl.opencellsoft.com/current/opencell.war -o input-files/opencell.war
curl -L http://dl.opencellsoft.com/current/import-postgres.sql -o input-files/import-postgres.sql
curl -L http://dl.opencellsoft.com/keycloak/init-user-db.sh -o input-files/init-user-db.sh

#disable ES
echo "elasticsearch.restUri=" > input-files/opencell-admin.properties


echo "Pulling docker images from docker hub"
docker-compose pull

echo "Starting docker-compose"
docker-compose up -d


echo ">>> Waiting opencell is ready"
### Wait for application is up
while ! (curl -sSf http://${OPENCELL_HOST:-localhost}:8080/opencell/about.xhtml | grep Version > /dev/null)
do
sleep 3
echo "Please wait, opencell not yet up"
done


clear
echo ">>> FINISHED !"

echo "Great, now your environnement is ready !"
echo "Open http://${OPENCELL_HOST:-localhost}:8080/ page to start"
echo "> Marketing manager is available on http://localhost:8080/opencell with credentials: opencell.marketingmanager / opencell.marketingmanager"
echo "> Administration console is available on http://localhost:8080/opencell with crendialts: opencell.superadmin / opencell.superadmin"
