# ELK Stack Project

This document contains the following details
* Technologies in use
* Description of the topology
* Acess Policies 
* ELK Conifguration 
  * Beats in use
  * Virtual Machines being monitored
* How to use the Ansible Build

## Technologies in use

This project is based in the Azure Virtual Network.

The following has already been done to my network
* 3 virtual machines 
  * Jump box VM acting as a gateway to ssh from my ip to the virtual network
    * Size - Standard B1s 
  * 2 Web server VM's
    * Size - Standard B1ms 
* Load balancer
  * Backend pool for Web 1 and Web 2
* Avalability set for Web 1 and Web 2 
* Red-Team-Network (virtual network)
  * Jump box, Web 1 and Web 2
  * Default subnet 10.0.0.0/24
* Network Security Group for jumpbox and Load Balancer
  * Allow port 22 from my-ip to virtual network
  * Allow port 22 from 10.0.0.4 to ssh into virtual network
  * Allow port 80 from my-ip to Load Balancer
  * Ansible
  * Docker
  
  
What I will be creating and installing
* ELK Server VM
* Seperate Virtual Network for ELK server
* Network Security Group For Elk Server
  * Allow port 22 from any source
  * Allow port 5601 from my-ip for GUI 
* Seperate Vnet for ELK server

* Metricbeat
* Filebeat


## Topology
The diagram below is the topology of the network I built 

![Elk-Stack-Project-1 drawio (2)](https://github.com/ericgor56/Elk-Stack-Project-1/blob/main/Diagrams/Elk-Stack-Project-Diagram.png)

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

Load balancing ensures that the application will be highly avalible, in addition to restricting inbound access to the network.

The advantages of a jump box is to ensure your network you are working on is secure and only accesed by whitelisted IPs.

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the system logs and system metric data.

The configuration details of each machine may be found below.


| Name        | Function    | IP Address | Operating System |
|----------   |----------   |------------|------------------|
| Jump Box    | Gateway     | 10.0.0.4   | Linux            |
| Web 1       | Web Server  | 10.0.0.7   | Linux            |
| Web 2       | Web Server  | 10.0.0.8   | Linux            |
| ELK server  | Monitor     | 10.1.0.4   | Linux           


## Access Policies

The machines on the internal network are not exposed to the public Internet. 

Only the jump box machine can accept connections from the Internet. Access to this machine is only allowed from the following IP addresses: 24.124.124.169 


Machines within the network can only be accessed by your personal IP address 


A summary of the access policies in place can be found in the table below.

| Name        | Publicly Accessible | Allowed IP Addresses |
|------------ |---------------------|----------------------|
| Jump Box    | Yes                 | 24.124.124.169       |
| Web 1       | No                  | 10.0.0.7             |
| Web 2       | No                  | 10.0.0.8             |
| ELK server  | No                  | 10.1.0.4             |

## Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because we can install many applications we need by using a playbook. Users can copy the playbooks provided and configure them  for their own installation.

### Part 1 - Creating Vnet and VM for ELK

* I created a seperate virtual network form my ELK stack VM with the same resource group (red-team) but a different region from my jump box, Web 1 and Web 2 servers.(elk-net)
  * Subnet - 10.1.0.0/24
* I added a peering connection from my ELK vnet to my red team vnet and named it elk-to-red
* I created a virtual machine for my ELK server
  * Same resource group as my other 3 virtual machines
  * Size - Standard D2s V3 
  * Same region as my ELK-vnet
  * I used the pub ssh key from my jump box ansible container 
  * ELK-vnet for virtual network
  * Inbound ports 22
 
 
 ### Part 2 - Configuring ELK
 
 * SSH into my jump box and attach to my ansible container 
 * Added my ELK VM private ip to my [hosts](https://github.com/ericgor56/Elk-Stack-Project-1/blob/main/Ansible/Ansible%20hosts%20file) file in ansible directory
   * Create a [elk] group seperate from [webservers] group
   
* Add this [elk config.yml](https://github.com/ericgor56/Elk-Stack-Project-1/blob/main/Ansible/Elk%20VM%20Playbook.yml) file in your ansible playbooks directory. This playbook will also install docker.io and python3-pip.
* Name the document what you want with the yml tag ex. elk.yml
* Run the playbook while in the directory using the `ansible-playbook` command 
* Once the playbook has ran and you run into no filed tasks you can ssh into your ELK container and run `sudo docker ps` or  `sudo container list -a` to see that the container is installed and running.

The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.

![elk container image](https://user-images.githubusercontent.com/82241347/134846333-c9b4a6e6-3ea8-4551-9462-43b9fd4fcafa.png)

* I created a inbound NSG rule in my ELK server NSG to allow port 5601 from my ip at priority 100 so I can connect to kibana form my web browser.

* I checked by running [elk-ip]:5601/app/kibana on your browser and saw the kibana landing page
*  ![kibana home page](https://github.com/ericgor56/Elk-Stack-Project-1/blob/main/Images/kibana-home-page.png)


## Target Machines & Beats
This ELK server will be configured to monitor the following machines:
* 10.0.0.7 Web 1
* 10.0.0.8 Web 2

### Part 3 - Configuring Filebeat and Metricbeat

Filebeat 

* In my jump box ansible container I ran `curl` https://gist.githubusercontent.com/slape/5cc350109583af6cbe577bbcc0710c93/raw/eca603b72586fbe148c11f9c87bf96a63cb25760/Filebeat > /etc/ansible/filebeat-config.yml to get the filebeat config file 
* I changed line 1106 and 1806 to my ELK private ip and saved the config file
* I created my [filebeat-playbook.yml](https://github.com/ericgor56/Elk-Stack-Project-1/blob/main/Ansible/FIlebeat%20Playbook.yml) file in my /ansible/playbooks directory 
* Run the playbook
* Verified that kibana is recieving data by going to [elk-ip]:5601/app/kibana 
  * Add Log Data
  * System Logs
  * ![filebeat ss](https://github.com/ericgor56/Elk-Stack-Project-1/blob/main/Images/filebeat%20recieving%20data.png)


Metricbeat
* In my Jump box ansible docker under /etc/ansible I copied this [Metricbeat-config.yml](https://github.com/ericgor56/Elk-Stack-Project-1/blob/main/Ansible/Metricbeat%20config%20file)
 * Changed the private ip to my ELK server ip
* Copied my [metricbeat-playbook.yml](https://github.com/ericgor56/Elk-Stack-Project-1/blob/main/Ansible/Metricbeat%20Playbook.yml) into /etc/anisble/playbooks
* Ran the playbook
* Verified in [elk-ip]:5601/apps/kibana that my Metricbeat module was recieving data
  * Add metric data
  * System Metrics
  * ![metricbeat ss](https://github.com/ericgor56/Elk-Stack-Project-1/blob/main/Images/metricbeat%20recieving%20data.png)

The following links are playbooks for filebeat and metricbeat
* [filebeat playbook](https://github.com/ericgor56/Elk-Stack-Project-1/blob/main/Ansible/FIlebeat%20Playbook.yml)
* [metricbeat playbook](https://github.com/ericgor56/Elk-Stack-Project-1/blob/main/Ansible/Metricbeat%20Playbook.yml)

Copy and paste and name these appropriatley as .yml files and run `ansible-playbook`

We have installed the following Beats on these machines:
* Filebeat
* Metricbeat

These Beats allow us to collect the following information from each machine:
-Filebeat is used to monitor log data from our Web 1 and Web 2 virtual machines.It forwards the logs to our ELK stack vm where we can open and see on the ELK server GUI(kibana).
-Metricbeat is used to monitor services running and things such as cpu usage on our Web 1 and Web 2 virtual machines. You can see the metrics on the ELK server GUI as well.

Below are some screenshots to show that kibana is picking up data from me prefroming invalid login attempts and a stress test
* ![Here I preformed a stress test on my Web 1 vm](https://github.com/ericgor56/Elk-Stack-Project-1/blob/main/Images/web%201%20stress%20test.png)
* ![Here I preformed some invalid ssh login attemps on my web 1 vm](https://github.com/ericgor56/Elk-Stack-Project-1/blob/main/Images/web%201%20ssh%20logs.png)
* ![Web 2 stress test](https://github.com/ericgor56/Elk-Stack-Project-1/blob/main/Images/web%202%20stress%20test.png)
* ![web 2 SSh logs](https://github.com/ericgor56/Elk-Stack-Project-1/blob/main/Images/web%202%20ssh%20logs.png)

Thesee screenshots indicate that my Filebeat and Metricbeat have been installed properly and are functional.

## How to use Ansible Build
* Turn on all your VMs 
* ssh into jump-box and make sure your ansible contianer is running
  * you can also ssh into ELK VM to see if container is running if you have any issues connecting
* Go to your browser and go to [ELK-ip]:5601/apps/kibana 
  * Logs and metrics tab on left side
  * You can see both Web 1 and Web 2 or use a filter for a specific VM.










