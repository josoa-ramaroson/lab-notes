
## Ansible Playbook

```yaml
- name: Unarchiving 
  hosts: 
    - stapp01
    - stapp02
    - stapp03
  become: yes
  tasks:
    - name: Unarchiving /usr/src/devops/devops.zip
      ansible.builtin.unarchive: # or unarchive
        src: /usr/src/devops/devops.zip
        dest: /opt/devops/

        owner: "{{ ansible_user }}"
        group: "{{ ansible_user }}"
        mode: '0744'
        remote_src: no

```
