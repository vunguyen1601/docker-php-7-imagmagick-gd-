# docker-php-7-imagmagick-gd
docker build -t vunt/php-7.0-ssh .

#run
docker run -d -v /opt/php-7.0-ssh-test/html:/var/www/html:rw -p4422:22 -p4480:80 --name php-7.0-ssh-test  vunt/php-7.0-ssh
