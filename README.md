# nvidia/cuda image with VNC

Docker image with **HTML5** VNC interface access to Ubuntu container LXDE desktop environment.

Build the image
```
docker build -t ubuntu:deepfacelab .
```

Run the docker image and open port `6080`

```
docker run -it -d --rm -p 6080:80 ubuntu:deepfacelab
```

Browse http://127.0.0.1:6080/


# Connect with VNC Viewer and protect by VNC Password


Forward VNC service port 5900 to host by

```
docker run -it --rm -p 6080:80 -p 5900:5900 ubuntu:deepfacelab
```

Now, open the vnc viewer and connect to port 5900. If you would like to protect vnc service by password, set environment variable `VNC_PASSWORD`, for example

```sh
docker run -it --rm \
           -p 6080:80 \
           -p 5900:5900 \
           -e VNC_PASSWORD=helloworld \
           ubuntu:deepfacelab
```

A prompt will ask password either in the browser or vnc viewer.

To get into bash of the running container
```
docker exec -it ubuntu:deepfacelab /bin/bash
```

# Running certbot
```
#!/bin/bash
docker run --rm -it \
    -e AWS_CONFIG_FILE=/.aws/config \
    -v /home/ec2-user/.letsencrypt/:/etc/letsencrypt \
    -v /home/ec2-user/.secrets/config:/.aws/config \
    -v $(pwd)/letsencrypt:/var/log/letsencrypt/ \
    certbot/dns-route53 \
    certonly \
    --dns-route53 \
    --dns-route53-propagation-seconds 60 \
    --server https://acme-v02.api.letsencrypt.org/directory \
    --agree-tos \
    -m admin@example.com \
    -d $example.com
```

# Random commands on display
```sh
xrand -q
xrandr --output :0 --mode 1024x768


xrandr --output DP2 --mode 3840x2160 --scale 2x2
xrandr --output DP2 --mode 400x768 --scale 1x1
cvt 1600 900


command=/usr/bin/Xvfb :1 -screen 0 1024x600x16
command=/usr/bin/Xvfb :1 -screen 0 1024x600x16


sudo xrandr --newmode "1600x900_60.00"  118.25  1600 1696 1856 2112  900 903 908 934 -hsync +vsync
```
