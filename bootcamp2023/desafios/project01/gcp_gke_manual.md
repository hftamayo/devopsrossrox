1. Setting up the PROJECT_ID variable for use it in the Google Cloud CLI and creating the repository:

![[Pasted image 20231212103846.png]]

2. Verifing if the Repository was created

![[Pasted image 20231212104048.png]]

3. Cloning the github's repository into my GCP project's repository (backend microservices)

![[Pasted image 20231212104314.png]]

4. Cloning the github's repository into the GCP project's repo (frontend microservice)


![[Pasted image 20231212104401.png]]

5. Building each Docker image for each cloned repository

![[Pasted image 20231212104629.png]]

![[Pasted image 20231212104750.png]]

![[Pasted image 20231212104850.png]]

![[Pasted image 20231212104953.png]]

![[Pasted image 20231212105517.png]]

6. Checking if the images were created:

![[Pasted image 20231212105547.png]]

7. Adding an IAM policy for the current account:

![[Pasted image 20231212105959.png]]

8. Pushing the docker images to the artifact registry:

![[Pasted image 20231212110153.png]]

...

![[Pasted image 20231212110212.png]]

![[Pasted image 20231212110518.png]]

![[Pasted image 20231212110629.png]]

![[Pasted image 20231212110718.png]]

![[Pasted image 20231212110819.png]]

9. Setting up the Compute Engine region:

![[Pasted image 20231212111750.png]]

10. Creating a K8s cluster for the project:

![[Pasted image 20231212111907.png]]
11. Ensuring the connection with the Google Kubernetes Engine Cluster and creating a Kubernete deployment for each Docker Image:

![[Pasted image 20231212112848.png]]
12. Setting up the baseline number of deployment replicas to 3:

![[Pasted image 20231212113143.png]]
13. Setting up the autoscaling resources to each deployment:

![[Pasted image 20231212113410.png]]
14. Checking the available pods related to each deployment:

![[Pasted image 20231212113452.png]]

15. Exposing the FrontEnd deployment into a Kubernete service:

![[Pasted image 20231212114359.png]]

16. the first external IP Address is 35.236.8.3:

![[Pasted image 20231213082311.png]]


however the data is not displayed:

![[Pasted image 20231213082359.png]]

17. Checking the services:

![[Pasted image 20231213082523.png]]

18. The idea is to have one k8s service per each microservice:

![[Pasted image 20231213082615.png]]

In my Dockerfile I set:

![[Pasted image 20231213082714.png]]

19. Checking the current k8s deployments: 

![[Pasted image 20231213085029.png]]
20. Creating one service per each deployment:

![[Pasted image 20231213085701.png]]
21. Checking again the available services:

![[Pasted image 20231213085938.png]]

22. Verifying if the data is available:

![[Pasted image 20231213090149.png]]

![[Pasted image 20231213090213.png]]
