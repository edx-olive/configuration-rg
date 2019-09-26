ironwood-rg release notes
=========================

Release based on upstream release tag - https://github.com/edx/configuration/tree/open-release/ironwood.1

Changes applied from previuos releases:
---------------------------------------

- all changes applied upon migration from github.com to GitLab
- Update elasticsearch config to prevent clustering in KVM
- Added possibility of deployment from private repositories
- AzStorage support in platform didn't support standard EDXAPP_GRADE_STORAGE_KWARGS (cherry-pick from Microfost)
- Disable removal of staticfiles for using static_collector.
- roles rabbitmq: fix for 'gzip: stdin: file size changed while zipping' error
- edxapp deploy.yml: added SSH authentication while installing extra python requirements via 'EDXAPP_EXTRA_REQUIREMENTS'
- added role 'edx_notes_api' to edx_single.yml. added oauth2 client setup for edx_notes_api
- changed course reindex logic. added reindex status persistant state file to skip repetition

Changes specific for ironwood-rg release:
-----------------------------------------

- added renaming of staticfiles directory to staticfiles-prev instead of removing. added nginx 'try_files' for this directory
- refactor: get rid of ansible warnings and deprecation warnings
- ansible.cfg: enable pipelining to speedup deployments
- edx_django_service role: added ability of creation of superuser for all django applications
- role common: do not repeat role (triggered by meta dependencies of other roles) on instance where role was executed already
- role rg-edx-single: switched to mongo_3_4
- mysql, edxlocal roles: split into two separate roles (for multi-instance installations). role mysql is to run on mysql instance. role edxlocal is to run on specific instance to add databases and users
- defined COMMON features flags for OpenEdx components

To do list:
-----------

- fix setup of password for edxapp staff and demo users
- automate tubular deployment for user retirement feature
- automate discovery and credentials integration with LMS
- automate ecommerce setup and integration with LMS
- refactor duplicity backups role
- develope AWS and Azure snapshots tasks
- refactor nginx role for SSL deployment. delete rg-nginx role
- add sentry integration for cs_comments_service, discovery, credentials, certs, xqueue
- refactor all tasks which uses 'apt' ansible module with 'update: true'. add apt ppa certificates renewal
- create separate task for single instance and multi instance deployments. remove rg-edx-single role
- add ability to deploy any component from private git repositories
- add theme update task. integrate with project CI
- add vagrant devstack configuration

Release specific repositories:
------------------------------

- configuration - https://gitlab.raccoongang.com/edx/configuration/configuration-ironwood-rg.git
- new project template - https://gitlab.raccoongang.com/edx/deployment/deployment-template-ironwood.git
