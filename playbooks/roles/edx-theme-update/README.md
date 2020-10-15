OpenEdx instance update theme task
==================================

Required: RG project's inventory

What it will do:
- edx-themes pull (call 'git_clone' role to pull multiple themes for microsites)
- edx-platform pull
- edx-theme pull (standard task from 'edxapp' role)
- restart LMS,CMS and their celery workers if edx-platform was changed
- compile assets for LMS

`edx-theme` repository .gitlab-ci.yml intergation:

```
---

theme-update:
    stage: deploy
    variables:
      run_role: edx-theme-update
    trigger: Team/projects/name/deployment
    only:
      - project-dev
      - project-stage
      - project-prod
```

`deployment` repository integration (into deployment playbook):

```
---

- name: Deploy a full stack Edx
  hosts: dev
  become: true

  roles:
    - role: "{{ run_role | default(lookup('env', 'run_role') | default('rg-edx-single', true)) }}"
```
