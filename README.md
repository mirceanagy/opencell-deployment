# opencell-deployment
- Install Docker and Docker Compose
sudo apt install unzip
export OPENCELL_HOST=<host_IP>
curl https://raw.githubusercontent.com/mirceanagy/opencell-deployment/master/deploy.opencell.sh | bash

OpenCell DB: <host_IP>:5432, credentials: opencell_db_user/opencell_db_password
KeyCloak URL to configure realms and users (login with admin/0pence!!): <host_IP>:8080/auth
OpenCell URL: <host_IP>:8080