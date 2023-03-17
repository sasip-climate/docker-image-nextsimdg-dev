# Creation of a docker image for nextsimdg


I will use repo2docker github workflow and quay.io to create and host the docker image that will be used to run nextsimdg following [this 2i2c tutorial](https://docs.2i2c.org/en/latest/admin/howto/environment/hub-user-image-template-guide.html) and [that tutorial](https://github.com/jupyterhub/repo2docker-action#push-repo2docker-image-to-quayio).

The modifications of the Dockerfile are done in a dedicated branch, then a pull request is created so that it will trigger a binder image. When it is ready, the pull request is merge and that triggers the creation of the docker image on quay.io.

Then you have to check on https://quay.io/repository/auraoupa/nextsimdg-demo-meeting?tab=tags, the newest tag that has been created, you click and the download icon (fetch the tag), select docker pull by tag and the command ```docker pull quay.io/auraoupa/nextsimdg-demo-meeting:f1b93ce58bab``` for instance is generated.

With your local instance of docker you can download the docker image with the command and then you run it with ```docker exec -it d63b7e4998665547be7127449db7963e40c65efdcaa2bb08c005d9b2acc7f9e5 /bin/sh```



