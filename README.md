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
    $ ansible slides -m ping

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

# Digital Ocean

> WARNING! You will get charged for your usage! I'm not responsible for any changes occurred by running these playbooks! Please familiarize yourself with digital ocean's pricing models. These playbooks will create a single 1 vcpu with 1 GB Memory droplet. 

Make sure you have an digital ocean api key with read and write permissions and that you've at least ran the `control.yml` playbook as it installs a few dependencies we'll need.

You'll also need to add an ssh key to your account. Ansible will use the default ssh key `~/.ssh/id_rsa`, you can tell ansible to use a different key if you'd like. Do do that change the key being used in the `digital_ocean.ini`.

> Those dependencies are `dopy` and `requests` python packages.

> Make sure you're inside the `deploy` folder.

## Setup

Install required role from Ansible Galaxy:

    $ ansible-galaxy install -r requirements.yml

Next we'll need to create a vault to store our ditigal ocean api key. Running the command below will prompt you to create a password for the vault. After which your editor should open:

> `ansible-vault` will use the editor set to `$EDITOR` which will be either `nano` or `vim`.
> To see what editor will be used, echo the `$EDITOR` variable, `echo $EDITOR`

    $ ansible-vault create vaulted_vars/api/vault

Insert the following into your vault file:

    vault_api_keys:
        do_api_key: <api_key_here>

If you need to change the api key or make any changes to the vault, you can run the following:

    $ ansible-vault edit vaulted_vars/api/vault

To use the digital ocean module and dynamic inventory, we'll need to set our api key to `DO_API_KEY`. You can run the `api_key.yml` playbook to do this, or you can set it another way if you desire:

> This will place it in the `/etc/environment` file. You'll most likely need to logout to see the changes.

    $ ansible-playbook api_keys.yml --ask-vault-pass

To make sure the api key is set correctly, run the following:

    $ python digital_ocean.py --list

You should get JSON output with any running droplets.

## Creating a droplet

Before you can run the playbook to create a droplet, you'll need the finger print for the public ssh key you'd like placed on the droplet. To get this finger print you'll need to login to your digital ocean account and go to account security. There you'll find a list of your public keys and their finger prints. Copy and paste the finger print when prompted to do so.

Assuming you're api key is set to `DO_API_KEY` and you have a public ssh key finger print handy, you can run the following to create a droplet:

> See the playbook file for more information! It should create a droplet called `slidesdo01`. It will only create the droplet if it doesn't already exist.

    $ ansible-playbook create_droplet.yml

We can use the same `nginx` role we used for the `slides` servers to provision the droplet we've just created.

Since the droplet we created has the name `slidesdo01`, it's ip address will be randomly assigned and we won't know what it is ahead of time. To find out what its ip address is, we can use the digital ocean dynamic inventory file to get the ip address. The dynamic inventory file will create a group named after the droplet. To see what information would be generated you run the following command:

    $ python digital_ocean.py --list

You'll see a group called `slidesdo01` and the droplets ip address. 

Lets provision the droplet:

    $ ansible-playbook -i digital_ocean.py slide_do.py

Once complete, copy and paste the droplet's ip address into your browser's address bar and the slides should appear!

Another way to make sure its all working is to run the `stack_status.yml` playbook:

> When prompted, provide the droplets group, `slidesdo01`

    $ ansible-playbook -i digital_ocean.py stack_status.yml

## Deleting the Droplet

To destroy the droplet you can run the following:

    $ ansible-playbook destroy_droplet.yml
