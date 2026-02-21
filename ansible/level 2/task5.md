The Nautilus DevOps team wants to install and set up a simple httpd web server on all app servers in Stratos DC. Additionally, they want to deploy a sample web page for now using Ansible only. Therefore, write the required playbook to complete this task. Find more details about the task below.


We already have an inventory file under /home/thor/ansible directory on jump host. Create a playbook.yml under /home/thor/ansible directory on jump host itself.

- Using the playbook, install httpd web server on all app servers. Additionally, make sure its service should up and running.

- Using blockinfile Ansible module add some content in /var/www/html/index.html file. Below is the content:

Welcome to XfusionCorp!

This is  Nautilus sample file, created using Ansible!

Please do not modify this file manually!

- The /var/www/html/index.html file's user and group owner should be apache on all app servers.
- The /var/www/html/index.html file's permissions should be 0744 on all app servers.

## Ansible Playbook

```yaml
- name: Httpd setting on App servers 
  hosts: 
    - stapp01
    - stapp02
    - stapp03
  become: yes
  tasks:
    - name: Installing httpd
      package:
        name: httpd
        state: present
    - name: Starting httpd service
      service:
        name: httpd
        state: started
        enabled: true
    - name: Creating index.html file
        :
        path: /var/www/html/index.html
        state: touch
        owner: apache
        group: apache
        mode: '0744'
    - name: Add some content in /var/www/html/index.html file
      blockinfile:
        path: /var/www/html/index.html
        block: |
          Welcome to XfusionCorp!

          This is  Nautilus sample file, created using Ansible!

          Please do not modify this file manually!
```
