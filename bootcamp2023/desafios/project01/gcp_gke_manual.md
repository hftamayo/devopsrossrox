## Diagram of the Solution ##

![architecture_diagram](./img/gcp_manual.drawio.png)

## Steps to reproduce the deployment process ##


1. Setting up the PROJECT_ID variable for use it in the Google Cloud CLI and creating the repository:

![01](./img/01.png)

2. Verifing if the Repository was created

![02](./img/02.png)

3. Cloning the github's repository into my GCP project's repository (backend microservices)

![03](./img/03.png)

4. Cloning the github's repository into the GCP project's repo (frontend microservice)

![04](./img/04.png)

5. Building each Docker image for each cloned repository

![05](./img/05.png)

![06](./img/06.png)

![07](./img/07.png)

![08](./img/08.png)

![09](./img/09.png)

6. Checking if the images were created:

![10](./img/10.png)

7. Adding an IAM policy for the current account:

![11](./img/11.png)

8. Pushing the docker images to the artifact registry:

![12](./img/12.png)

...

![13](./img/13.png)

![14](./img/14.png)

![15](./img/15.png)

![16](./img/16.png)

![17](./img/17.png)

9. Setting up the Compute Engine region:

![18](./img/18.png)

10. Creating a K8s cluster for the project:

![19](./img/19.png)

11. Ensuring the connection with the Google Kubernetes Engine Cluster and creating a Kubernete deployment for each Docker Image:

![20](./img/20.png)

12. Setting up the baseline number of deployment replicas to 3:

![21](./img/21.png)

13. Setting up the autoscaling resources to each deployment:

![22](./img/22.png)

14. Checking the available pods related to each deployment:

![23](./img/23.png)

15. Exposing the FrontEnd deployment into a Kubernete service:

![24](./img/24.png)

16. the first external IP Address is 35.236.8.3:

![25](./img/25.png)

however the data is not displayed:

![26](./img/26.png)

17. Checking the services:

![27](./img/27.png)

18. The idea is to have one k8s service per each microservice:

![28](./img/28.png)

In my Dockerfile I set:

![29](./img/29.png)

19. Checking the current k8s deployments: 

![30](./img/30.png)

20. Creating one service per each deployment:

![31](./img/31.png)

21. Checking again the available services:

![32](./img/32.png)

22. Verifying if the data is available:

![33](./img/33.png)

![34](./img/34.png)
