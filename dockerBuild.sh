## building docker

docker build -t wongj4/canvas:1.40.0.1613 ./docker
docker run -it wongj4/canvas:1.40.0.1613

docker run -it --mount type=bind,source=/home/ubuntu/volume/canvas,target=/TEST kfdrc/canvas:1.11.0
