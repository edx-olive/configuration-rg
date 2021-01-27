```
---
role: docker
docker_version: "18.02.0"
docker_compose_version: "1.19.0"
docker_users: ['deploy']
```

Examples
========

```
ansible-playbook -i,sandbox00.raccoongang.com -eansible_port=22895 --private-key=~/notes/rg/jenkins.key -u raccoon -erole=docker run_role.yml -e '{ "docker_users": ["raccoon","aliens"]}'
```
