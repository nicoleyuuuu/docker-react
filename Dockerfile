# BUILD PHASE
# base image
# AS name the phase, anything from or below FROM refers to the builder phase
FROM node:16-alpine as builder  

# install dependencies
WORKDIR /app
COPY package.json .
RUN npm install

# technically this could be removed if we are using docker volumes
# but if we decided not to use docker volumes or use docker prod instead, we still need it
COPY . .

# default command 
# CMD ["npm", "run", "start"]
RUN npm run build 

# all the output will be stored in the build folder. The build folder would be created within the work dir
# /app/build/ -> all the stuff that we want to copy over in the run phase

# second base image: previous blocker completed, start a new block
FROM nginx
# elasticbeanstalk will find the expose statement and map the port
EXPOSE 80
# copy sth from another phase
COPY --from=builder /app/build /usr/share/nginx/html
# no need to specify CMD, because the default primary command is starting ngnix
# after building the container, run docker run -p 8080:80 container ID to run the container
# 80 is the default port that ngnix uses
