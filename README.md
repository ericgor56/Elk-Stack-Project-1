
The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

Load balancing ensures that the application will be highly avalible, in addition to restricting inbound access to the network.

The advantages of a jump box is to ensure your network you are working on is secure and only accesed by whitelisted IPs.

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the system logs and system metric data.

The configuration details of each machine may be found below.
_Note: Use the [Markdown Table Generator](http://www.tablesgenerator.com/markdown_tables) to add/remove values from the table_.

| Name     | Function | IP Address | Operating System |
|----------|----------|------------|------------------|
| Jump Box | Gateway  | 10.0.0.4   | Linux            |
| Web 1    | Web Svr  | 10.0.0.7   | Linux            |
| Web 2    | Web Svr  | 10.0.0.8   | Linux            |
| Elk svr  | Monitor  | 10.1.0.4   | Linux            |

### Access Policies

The machines on the internal network are not exposed to the public Internet. 

Only the jump box machine can accept connections from the Internet. Access to this machine is only allowed from the following IP addresses:24.124.124.169 


Machines within the network can only be accessed by your personal IP address ex.24.124.124.169.


A summary of the access policies in place can be found in the table below.

| Name     | Publicly Accessible | Allowed IP Addresses |
|----------|---------------------|----------------------|
| Jump Box | Yes                 | 24.124.124.169       |
| Web 1    | No                  | 10.0.0.1-254         |
| Web 2    | No                  | 10.0.0.1-254         |
| Elk svr  | No                  |                      |

### Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because we can manually install all of the applications we need by using a yml playbook. Users can copy the playbooks provided and use them for their own installation.
- _TODO: What is the main advantage of automating configuration with Ansible?_**************

The playbook implements the following tasks:
- _TODO: In 3-5 bullets, explain the steps of the ELK installation play. E.g., install Docker; download image; etc._
- First we 
- ...

The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.

![/c/Users/Ericg/Downloads/ELK-Stack-Project-1/'Images/elk container image.png'](Images/docker_ps_output.png)

### Target Machines & Beats
This ELK server is configured to monitor the following machines:
-10.0.0.7 Web 1
-10.0.0.8 Web 2

We have installed the following Beats on these machines:
-Filebeat
-Metricbeat

These Beats allow us to collect the following information from each machine:
-Filebeat is used to monitor log data from our web 1 and web 2 virtual machines.It forwards the logs to our elk vm where we can open and see on the elk server GUI(kibana).
-Metricbeat is used to monitor the services running on our web 1 and web 2 virtual machines. You can see the metrics on the elk server GUI as well.

### Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
- Copy the filebeat file to _____.
- Update the _____ file to include...
- Run the playbook, and navigate to ____ to check that the installation worked as expected.

_TODO: Answer the following questions to fill in the blanks:_
- _Which file is the playbook? Where do you copy it?_
- _Which file do you update to make Ansible run the playbook on a specific machine? How do I specify which machine to install the ELK server on versus which to install Filebeat on?_
- _Which URL do you navigate to in order to check that the ELK server is running?
- [your.VM.IP]:5601/app/kibana

_As a **Bonus**, provide the specific commands the user will need to run to download the playbook, update the files, etc._

