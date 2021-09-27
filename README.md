# Elk Stack Project

This document contains the following details
* Technologies in use
* Description of the topology
* Acess Policies 
* Elk Conifguration 
  * Beats in use
  * Virtual Machines being monitored
* How to use the Ansible Build

## Technologies in use

This project is based in the Azure Virtual Network
* 4 virtual machines 
  * Jump box VM acting as a gateway to ssh from my ip to the virtual network
    * Standard B1s
  * 2 Web server VM's
    * Standard B1ms
  * An Elk server to monitor the 2 Web servers
    * Standard D2s v3
* Load balancer
 * Backend pool for web 1 and web 2
* NSG for jumpbox and Load Balancer
  * Allow port 22 from my-ip to virtual network
  * Allow port 80 from my-ip to Load Balancer
* NSG For Elk Server
  * Allow port 22 from any source
  * Allow port 5601 from my-ip for GUI 
* Vnet for Jump Box, Web 1, Web 2
* Seperate Vnet for elk server
* Ansible
* Docker

## Topology
The diagram below is the topology of the network I built 

![Elk-Stack-Project-1 drawio (2)](https://github.com/ericgor56/Elk-Stack-Project-1/blob/main/Diagrams/Elk-Stack-Project-1.drawio.png)

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

Load balancing ensures that the application will be highly avalible, in addition to restricting inbound access to the network.

The advantages of a jump box is to ensure your network you are working on is secure and only accesed by whitelisted IPs.

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the system logs and system metric data.

The configuration details of each machine may be found below.
_Note: Use the [Markdown Table Generator](http://www.tablesgenerator.com/markdown_tables) to add/remove values from the table_.

| Name        | Function    | IP Address | Operating System |
|----------   |----------   |------------|------------------|
| Jump Box    | Gateway     | 10.0.0.4   | Linux            |
| Web 1       | Web Server  | 10.0.0.7   | Linux            |
| Web 2       | Web Server  | 10.0.0.8   | Linux            |
| Elk server  | Monitor     | 10.1.0.4   | Linux            |



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
| Elk server  | No                  | 10.1.0.4             |

## Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because we can manually install all of the applications we need by using a playbook. Users can copy the playbooks provided and configure them  for their own installation.

### Part 1 - Creating Vnet and VM for ELK

* I created a seperate virtual network form my elk stack VM with the same resource group but a different region from my jump box, web 1 and web 2 servers.(elk-vnet)
* I added a peering connection from my elk vnet to my red team vnet and named it elk-to-red
* I created a virtual machine for my elk server
  * Same resource group as my other 3 virtual machines
  * Same region as my elk-vnet
  * I used the pub ssh key from my jump box ansible container 
  * Elk-vnet for virtual network
  * Inbound ports 22
 
 ### Part 2 - Configuring ELK
 
 * SSH into my jump box and attach to my ansible container 
 * Added my elk VM private ip to my [hosts](https://github.com/ericgor56/Elk-Stack-Project-1/blob/main/Ansible/Ansible%20hosts%20file) file in ansible directory
   * Create a seperate [elk] group seperate from [webservers] group
   
* Add this [elk config.yml](https://github.com/ericgor56/Elk-Stack-Project-1/blob/main/Ansible/Elk%20VM%20Playbook.yml) file in your ansible playbooks directory. This playbook will also install docker.io, python3-pip, and docker.
* Name the document what you want with the yml tag ex. elk.yml
* Run the playbook while in the directory using the `ansible-playbook` command 
* Once the playbook has ran and you run into no filed tasks you can ssh into your elk container and run `sudo docker ps` or  `sudo container list -a` to see that the container is installed and running.

The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.

![elk container image](https://user-images.githubusercontent.com/82241347/134846333-c9b4a6e6-3ea8-4551-9462-43b9fd4fcafa.png)

* I created a inbound NSG rule in Azure to allow port 5601 from my ip so I can connect to kibana form my pc.

* I checked by running [elk-ip]:5601/app/kibana on your browser and saw the kibana landing page


## Target Machines & Beats
This ELK server will be configured to monitor the following machines:
* 10.0.0.7 Web 1
* 10.0.0.8 Web 2

### Part 3 - Configuring Filebeat and Metricbeat

Filebeat 

* In my jump box ansible docker I ran `curl` https://gist.githubusercontent.com/slape/5cc350109583af6cbe577bbcc0710c93/raw/eca603b72586fbe148c11f9c87bf96a63cb25760/Filebeat > /etc/ansible/filebeat-config.yml to get the filebeat config file 
* I changed line 1106 and 1806 to my elk private ip and saved the config file
* I created my [filebeat-playbook.yml](https://github.com/ericgor56/Elk-Stack-Project-1/blob/main/Ansible/FIlebeat%20Playbook.yml) file in my /ansible/playbooks directory 
* Run the playbook
* Verified that kibana is recieving data by going to [elk-ip]:5601/app/kibana and chicking module status for filebeat

Metricbeat
* In my Jump box ansible docker under /etc/ansible I copied this [Metricbeat-config.yml](https://github.com/ericgor56/Elk-Stack-Project-1/blob/main/Ansible/Metricbeat%20config%20file)
 * Changed the private ip to my elk server ip
* Copied my [metricbeat-playbook.yml](https://github.com/ericgor56/Elk-Stack-Project-1/blob/main/Ansible/Metricbeat%20Playbook.yml) into /etc/anisble/playbooks
* Ran the playbook
* Verified in [elk-ip]:5601/apps/kibana taht my Metricbeat module was recieving data

The following links are playbooks for filebeat and metricbeat
* [filebeat playbook](https://github.com/ericgor56/Elk-Stack-Project-1/blob/main/Ansible/FIlebeat%20Playbook.yml)
* [metricbeat playbook](https://github.com/ericgor56/Elk-Stack-Project-1/blob/main/Ansible/Metricbeat%20Playbook.yml)

Copy and paste and name these appropriatley as .yml files and run `ansible-playbook`

We have installed the following Beats on these machines:
* Filebeat
* Metricbeat

These Beats allow us to collect the following information from each machine:
-Filebeat is used to monitor log data from our web 1 and web 2 virtual machines.It forwards the logs to our elk stack vm where we can open and see on the elk server GUI(kibana).
-Metricbeat is used to monitor services running and things such as cpu usage on our web 1 and web 2 virtual machines. You can see the metrics on the elk server GUI as well.

Here below I attached some screenshots of some tasks I did to test out my vms and see the logs and metrics on kibana.
* [Here I preformed a stress test on my web 1 vm](https://github.com/ericgor56/Elk-Stack-Project-1/blob/main/Images/web%201%20stress%20test.png)
* [Here I preformed some invalid ssh login attemps on my web 2 vm](https://github.com/ericgor56/Elk-Stack-Project-1/blob/main/Images/web%202%20ssh%20logs.png)
As you can see, Both of my web servers are sending data to my elk VM 

### Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
* Copy the playbooks file to the ansible control node.
* Update the _____ file to include...
* Run the playbook, and navigate to the  to check that the installation worked as expected.

_TODO: Answer the following questions to fill in the blanks:_
- _Which file is the playbook? Where do you copy it?_
- _Which file do you update to make Ansible run the playbook on a specific machine? How do I specify which machine to install the ELK server on versus which to install Filebeat on?_
- _Which URL do you navigate to in order to check that the ELK server is running?
* 10.1.0.4:5601/app/kibana

_As a **Bonus**, provide the specific commands the user will need to run to download the playbook, update the files, etc._


