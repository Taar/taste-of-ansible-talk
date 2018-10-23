## Getting Started

You'll need to generate ssh keys and save them in the project root directory as `ansible`:

    $ ssh-keygen -t rsa -N "" -f ansible

Make sure `vagrant` and `virtualbox` is installed on your machine.

    $ vagrant plugin install vagrant-hostmanager
    $ vagrant up

> Note: to manually update hosts file for all VMs and the host machine run `vagrant hostmanager`

At this point you should see that there are 3 virtual machines running.
 
 - `control`: Where we'll install ansible and run our ansible playbooks
 - `slides[01-02]`: Where we'll serve up the slides for this talk

Now you can ssh into the control server with the following command:

    $ vagrant ssh

Once on your control server we'll need to install ansible:

    $ sudo apt-add-repository ppa:ansible/ansible
    $ sudo apt-get install -y ansible

Navigate to `talk-files`:

    $ cd talk-files

The playbooks are in the `deploy` folder, you'll need to inside that folder to run any commands.

If you have ansible installed, you can perform a quick check to make sure you can communicate from the control server to the slide servers:

    # Make sure you're in the deploy folder
    $ ansible sldies -m ping

Should output something like the following:

    slides02 | SUCCESS => {
        "changed": false, 
        "ping": "pong"
    }
    slides01 | SUCCESS => {
        "changed": false, 
        "ping": "pong"
    }

If you didn't get something like the above, check to make sure the hosts files all the VMs have been updated correctly and that the VMs are running.

## playbooks

`site.yml` will run all the playbooks in the correct order and perform a check to make sure everything is running.

    # make sure you're in the deploy directory
    $ ansible-playbook site.yml

Otherwise you can run them independently:

    $ ansible-playbook control.yml
    $ ansible-playbook slides.yml

> Warning: `slides.yml` will fail if you attempt to run it before `control.yml`
