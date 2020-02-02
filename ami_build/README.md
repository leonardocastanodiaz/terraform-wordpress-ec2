# Ansible and Packer

To run the packer command to build the image use a command very similar to
```
packer build jenkins-master.json
```
which will use your access key and secret key from the .aws directory.

#### Troubleshooting
If ansible fails to install java with a bunch of output including

> Unable to correct problems, you have held broken packages

Then just rerun the same command again. This is basically apt-get being annoying and I don't know how to solve it once and for all. It seems to almost be a race condition somewhere because it is intermittent.