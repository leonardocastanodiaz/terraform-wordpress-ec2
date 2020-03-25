# Wordpress, DevOps Styli

## Background

A project to setup and run multiple Wordpress sites using the best practices of DevOps & Agile

The aim is to produce a set-up that will be fully automated and self-maintaining.  This may or may not preclude the use of Wordpress as the content will need updating 

## ToDo

1) Thrash out the direction to be taken and the tools to be used.  Some thoughts in no particualr order:
  
    a) Tool to be used for discussions

    b) Use Terraform as it's the predominant provisioner
    
    c) Use Ansible as it's the predominant Configuration Manager
    
    d) Use wp-cli as it's the predominant WP maintenance tool
    
    e) Use GitLab - ITP likes it ;-)
    
    f) CI/CD - Github Actions or GitLab Pipelines/Runners - the latter is particularly slick
    
    g) Use containers for apps, DBs, etc.
    
    h) Use K3s (not a typo - https://k3s.io/) to deploy locally becuase it's container based
    
    i) Terraform Cloud for .tfstate https://terraform.io
    
    j) Use branches for development - never commit to master
    
    k) At least one approver for each merge/pull request
