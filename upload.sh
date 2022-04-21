#!/bin/bash

aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 360866469173.dkr.ecr.us-west-2.amazonaws.com &&\
docker build -t freeling . &&\
docker tag freeling:latest 360866469173.dkr.ecr.us-west-2.amazonaws.com/freeling:latest &&\
docker push 360866469173.dkr.ecr.us-west-2.amazonaws.com/freeling:latest
