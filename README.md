## Getting Started

You'll need to generate ssh keys and save them in the project root directory as `ansible`:

    $ ssh-keygen -t rsa -N "" -f ansible

### Vagrant

Make sure `vagrant` and `virtualbox` is installed on your machine.

    $ vagrant plugin install vagrant-hostmanager
    $ vagrant up

At this point you should see that there are 3 virtual machines running.
 
 - `control`: Where we'll install ansible and run our ansible playbooks
 - `webserver`: Where we'll install and run our web server
 - `database`: Where we'll install our database

Now you can ssh into the control server with the following command:

    $ vagrant ssh

Once on your control server we'll need to install ansible:

    $ sudo apt-get update
    $ sudo apt-get install -y software-properties-common ansible
