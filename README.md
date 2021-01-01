# Vivaldi-myTimer


## Setting up Linux image
* Setup [Official Raspberry Pi image](https://www.raspberrypi.org/software/operating-systems/) on an sd card for configuring your pi.  
* [Configure your wifi network on the image](https://www.raspberrypi-spy.co.uk/2017/04/manually-setting-up-pi-wifi-using-wpa_supplicant-conf/)
* Enable ssh by adding a ssh file to the boot partition: `host$> touch /Volume/boot/ssh`
* Boot your Raspberry pi and connect via, ssh.  The default username is `pi` , and password is `raspberry`
 
    ```
    host$> ssh pi@192.168.7.9
    ```
* Once logged in change your password: `pi$> passwd`

## Setup dependencies
* Once you've logged into the pi perform an update and all the install dependencies required to run myTimer
```
pi$> sudo apt update
pi$> sudo apt install php php-mysql python apache2 mariadb-server
```
    
* Upload files for configuring your database to your pi:    
```
host$> scp ./vivaldi_db_setup.sql pi@192.168.7.48:/home/pi
host$> scp ./create_db.sh pi@192.168.7.48:/home/pi
```

* From your pi run the create_db script to setup the vivaldi database:
```
pi$> chmod +x ~/create_db.sh
pi$> sudo ~/create_db.sh
```
    
## Setup hostname as vivaldi
* [How to configure hostname on Raspberry Pi](https://pimylifeup.com/raspberry-pi-hostname/)


## Copy web server files to the pi
```
host$> scp www.tar.gz pi@192.168.7.48:/home/pi
```

Then on the your pi untar the contents and insure permissions are correctly set:
```
pi$> tar -zxvf www.tar.gz
pi$> chmod -R 0755 /home/pi/www
```

## Setup Apache web server
* In the Apache config file `/etc/apache2/sites-enabled/000-default.conf` you need to change the DocumentRoot path to `/home/pi/www` 
* You may also need to set up the directory to allow access.  After your edits the file should look like this:

```

<VirtualHost *:80> 
        # The ServerName directive sets the request scheme, hostname and port that 
        # the server uses to identify itself. This is used when creating 
        # redirection URLs. In the context of virtual hosts, the ServerName 
        # specifies what hostname must appear in the request's Host: header to 
        # match this virtual host. For the default virtual host (this file) this 
        # value is not decisive as it is used as a last resort host regardless. 
        # However, you must set it for any further virtual host explicitly. 
        #ServerName www.example.com 
 
        ServerAdmin webmaster@localhost 
        DocumentRoot /home/pi/www 
 
        # Available loglevels: trace8, ..., trace1, debug, info, notice, warn, 
        # error, crit, alert, emerg. 
        # It is also possible to configure the loglevel for particular 
        # modules, e.g. 
        #LogLevel info ssl:warn 
 
        ErrorLog ${APACHE_LOG_DIR}/error.log 
        CustomLog ${APACHE_LOG_DIR}/access.log combined 
        <Directory /home/pi/www> 
                Options Indexes FollowSymLinks 
                AllowOverride All 
                Require all granted 
        </Directory> 
 
        # For most configuration files from conf-available/, which are 
        # enabled or disabled at a global level, it is possible to 
        # include a line for only one particular virtual host. For example the 
        # following line enables the CGI configuration for this host only 
        # after it has been globally disabled with "a2disconf". 
        #Include conf-available/serve-cgi-bin.conf 
</VirtualHost>

```

* In /etc/apache2/sites-available/default-ssl.conf do the same and again in the other file in the same folder 000-default.conf

