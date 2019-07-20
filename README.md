# my-app
# contains docker file which will create ubuntu image with nginx webserver, 2 version of index.html and k8s deployment file

### This Readme makes the following assumptions.
1. my-app have two version of index.html file which we will use for deployement, first config/index.html will bind with docker file, once we created using Dockerfile, need to make change in Dockerfile for deploye index.html version 2.
2. docker environment is running 
3. Kubernetes cluster is running, 
4. kubectl command line tool installed on one of VMs.
5. We have installed Helm on VMs and Tiller in K8S cluster.

below are the stpes to deploy application version 1 in K8s cluster.

### Step1: Build the docker image using Dockerfile without any modification.
Run the docker build command in the directory containing th Dockerfile. in our case directory is my-app.
Add a tg to identify the current version of the application:1.0 

`docker build -t <username>/my-app:1.0`

We will see output like this.
```SATYAVAK-M-M32P:IDENT satyavak$ docker build  -t zyx/my-app:1.0  .
Sending build context to Docker daemon  72.19kB
Step 1/8 : FROM ubuntu:16.04
 ---> b0ef3016420a
Step 2/8 : MAINTAINER xyz@gmail.com
 ---> Using cache
 ---> 939141a08423
Step 3/8 : RUN apt-get -y update
 ---> Using cache
 ---> 30884ce8d2e9
Step 4/8 : RUN apt-get -y install nginx
 ---> Using cache
 ---> 8d0e817cd227
Step 5/8 : copy config/index.html /var/www/html/
 ---> Using cache
 ---> 3005b2afebbd
Step 6/8 : RUN ln -sf /dev/stdout /var/log/nginx/access.log   && ln -sf /dev/stderr /var/log/nginx/error.log
 ---> Using cache
 ---> 532b29af6085
Step 7/8 : EXPOSE 80
 ---> Using cache
 ---> 47249c425c72
Step 8/8 : CMD ["nginx", "-g", "daemon off;"]
 ---> Using cache
 ---> 186dbc06e60a
Successfully built 186dbc06e60a
Successfully tagged xyz/my-app:1.0
```

### Step2. publish the docker image
Now we are going to pulish the docker image which contain app with index.html version 1. We can upload image to public registry.

log in Docker hub

`docker login `

push the docker image

` docker push xyz/my-app:1.0`

### Step3: Create helm chart
Log in VM where we installed helm chart and kubectl cli tool.
To create a new helm chart , we just need to run the command helm create. this will create a sample files that we will modify to build our custom chart.

`helm create my-app`

replace `values.yaml` file with `value.yaml` which is in our repo.

replace `templates/deployment.yaml` file with the `deployment.yaml` which is in our repo.


### Step4: Deploy the my-app application in Kubernetes.
Make sure We are able to connect kubernetes cluster, (This has been tested in AWS platopform using Kops tool.)

`kubectl cluster-info`

Deploy the helm chart by executing below command.

`helm install -n my-app helm-chart/my-app/`


Now run below command to check pods get created.

`kubectl get pods`


Now check service list.

`kubectl get service`

Run below command and select service. It i will end point of my-app LB balancer ip.

`kubectl describe service my-app  --namespace=prod`


# Deploy new version of my-app:2.0 
make a change in docker file, 
comment line no 7 and un-comment line no 9.

repeat Step1 and Step2  and change version 1.0 to 2.0.

Make change 1.0 to 2.0 in values.yaml file.

### Upgrade new version of application.
Run below command.

`helm upgrade my-app helm-chart/my-app/`

check upgrade status 

`helm history my-app`











