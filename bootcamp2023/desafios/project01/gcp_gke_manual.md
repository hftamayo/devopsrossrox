1. Setting up the PROJECT_ID variable for use it in the Google Cloud CLI and creating the repository:

![[./bootcamp2023/desafios/project01/img/Pasted image 20231212103846.png]]

2. Verifing if the Repository was created

![[./bootcamp2023/desafios/project01/img/Pasted image 20231212104048.png]]

3. Cloning the github's repository into my GCP project's repository (backend microservices)

![[./bootcamp2023/desafios/project01/img/Pasted image 20231212104314.png]]

4. Cloning the github's repository into the GCP project's repo (frontend microservice)

![[./img/Pasted image 20231212104401.png]]

5. Building each Docker image for each cloned repository

![[./img/Pasted image 20231212104629.png]]

![[./img/Pasted image 20231212104750.png]]

![[./img/Pasted image 20231212104850.png]]

![[./img/Pasted image 20231212104953.png]]

![[./img/Pasted image 20231212105517.png]]

6. Checking if the images were created:

![[./img/Pasted image 20231212105547.png]]

7. Adding an IAM policy for the current account:

![[./img/Pasted image 20231212105959.png]]

8. Pushing the docker images to the artifact registry:

![[./img/Pasted image 20231212110153.png]]

...

![[./img/Pasted image 20231212110212.png]]

![[./img/Pasted image 20231212110518.png]]

![[./img/Pasted image 20231212110629.png]]

![[./img/Pasted image 20231212110718.png]]

![[./img/Pasted image 20231212110819.png]]

9. Setting up the Compute Engine region:

![[./img/Pasted image 20231212111750.png]]

10. Creating a K8s cluster for the project:

![[./img/Pasted image 20231212111907.png]]

11. Ensuring the connection with the Google Kubernetes Engine Cluster and creating a Kubernete deployment for each Docker Image:

![[./img/Pasted image 20231212112848.png]]

12. Setting up the baseline number of deployment replicas to 3:

![[./img/Pasted image 20231212113143.png]]

13. Setting up the autoscaling resources to each deployment:

![[./img/Pasted image 20231212113410.png]]

14. Checking the available pods related to each deployment:

![[./img/Pasted image 20231212113452.png]]

15. Exposing the FrontEnd deployment into a Kubernete service:

![[./img/Pasted image 20231212114359.png]]

16. the first external IP Address is 35.236.8.3:

![[./img/Pasted image 20231213082311.png]]


however the data is not displayed:

![[./img/Pasted image 20231213082359.png]]

17. Checking the services:

![[./img/Pasted image 20231213082523.png]]

18. The idea is to have one k8s service per each microservice:

![[./img/Pasted image 20231213082615.png]]

In my Dockerfile I set:

![[./img/Pasted image 20231213082714.png]]

19. Checking the current k8s deployments: 

![[./img/Pasted image 20231213085029.png]]

20. Creating one service per each deployment:

![[./img/Pasted image 20231213085701.png]]

21. Checking again the available services:

![[./img/Pasted image 20231213085938.png]]

22. Verifying if the data is available:

![[./img/Pasted image 20231213090149.png]]

![[./img/Pasted image 20231213090213.png]]
