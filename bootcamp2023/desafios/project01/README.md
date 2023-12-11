### Jenkins installation and setup on RHEL 7.9###

* Installation on RHEL 7.9 (I got errors during the installation of GPG Key):
  - sudo wget -O /etc/yum.repos.d/jenkins-ci.org.key https://pkg.jenkins.io/redhat/jenkins.io.key
  - sudo rpm --import /etc/yum.repos.d/jenkins-ci.org.key
  - sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
  - sudo yum clean all
  - sudo yum install jenkins --nogpgcheck
  - sudo update-alternatives --list java
  - sudo update-alternatives --config java (select ver 11)
  - java --version (it should be 11 version)
  - sudo systemctl start jenkins
  - sudo systemctl status jenkins
  - sudo systemctl enable jenkins

* allowing incoming request on port 8080: 
  - sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp
  - sudo firewall-cmd --reload

  - sudo netstat -telpn | grep LISTEN  (port 8080 should be in LISTEN mode)

* [installation and setup in detail](https://sysadminxpert.com/how-to-install-jenkins-on-centos-7-or-rhel-7/)
