
## Ansible Inventory

```ini
inventory
stapp01 ansible_host=172.16.238.10 ansible_user=tony ansible_password=<PASSWORD>
stapp02 ansible_host=172.16.238.11 ansible_user=steve ansible_password=<PASSWORD>
stapp03 ansible_host=172.16.238.12 ansible_user=banner ansible_password=<PASSWORD>

[appserv]
stapp01
stapp02
stapp03
```

## Ansible Playbook

```yaml
- name: Installing packages
  hosts: appserv
  become: yes
  tasks:
    - name: installing samba on all servers
      yum:
        name: samba
        state: present
        # update_cache: yes
```
