
## Ansible Playbook

```yaml
- name: Archiving file on remote server
  hosts: 
    - stapp01
    - stapp02
    - stapp03
  become: yes
  tasks:
    - name: Archiving /usr/src/security/
      community.general.archive: # or archive
        path: /usr/src/security/
        dest: /opt/security/ecommerce.tar.gz
        format: gz

        owner: "{{ ansible_user }}"
        group: "{{ ansible_user }}"
        mode: '0644'

```
