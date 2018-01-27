# kitchen-ansible-example
Simplest example of using test kitchen, ansible, and busser to orchestrate
system level testing.

* [test-kitchen](https://kitchen.ci/) as the test harness to coordinate
system provisioning and validation.

    The only requirement for test-kitchen is the `.kitchen.yml` file.

* [kitchen-ansible](https://github.com/neillturner/kitchen-ansible) as
the provisioning engine.

    This requires the `requirements-test.txt` to define the ansible
    requirements, as well as an ansible playbook located at
    `test/integration/<test-suite>/default.yml.

* [busser-bats](https://github.com/test-kitchen/busser-bats) as the
testing framework runner.

    This requires a test at
    `test/integration/<test-suite>/bats/<test-name>.bats`

In this repo, this test runner setup is used to validate OpenStack
functionality on a system that is deployed separately.

## Kitchen install
The installation of the kitchen gem was done in this directory after creating
and activating a python virtualenv. This virtualenv is used as the env for all
dependencies including the ruby based test-kitchen gem.

### Rbenv
To manage the ruby environment we will use rbenv. See the
[rbenv github page](https://github.com/rbenv/rbenv) for instructions on
installing rbenv on your system. You will need to enable the rbenv hook in
your shell session with the following command.
```
eval "$(rbenv init -)"
```

Once rbenv is installed, a ruby version is then installed with the tool. Take
a look at the [ruby-lang website](https://www.ruby-lang.org/en/downloads/) for
the latest stable versions. The latest version in the 2.4.x series is a good
bet at the time this was written.
```
rbenv install 2.4.3
```
Compiling ruby for the install can take some time, so be patient.

After the ruby version is installed, the `rbenv rehash` command must be called
in order to make it available to the rbenv shell shim.
```
rbenv rehash
```

The ruby version must then be set by rbenv in order to make it the active ruby
version.
```
rbenv global 2.4.3
```

### Python virtualenv
A python virtualenv is created to isolate the environment from the system
python environment. This virtualenv will be specific to this repository. So,
clone the repo and cd into the root of the repo if you have not done so
already.
```
git clone https://github.com/johnduarte/kitchen-ansible-example.git
cd kitchen-ansible-example
```

Now create the python virtual environment.
```
virtualenv --python python3 venv
source venv/bin/activate
```

### Test kitchen
With the ruby and python environments in place, we can now install the
test-kitchen gem.
```
gem install test-kitchen
```

## Kitchen Drivers
Drivers are used by test kitchen to provide the functionality of connecting to
test systems. They are also used to provision systems for virtualization
technologies (e.g. vagrant, docker).


### Kitchen Proxy Driver
The proxy driver is included with the base test-kitchen installation.

When testing on a pre-deployed system using the proxy driver, it was necessary
to create a symlink of the gem command on the target system to
`/opt/chef/embedded/bin/gem`.
```
sudo ln -s /usr/bin/gem /opt/chef/embedded/bin/gem
```

## Kitchen Provisioners

### Ansible Playbook
For this repo, we want to use the ansible playbook provisioner. So, it is
necessary to install it as well.
```
gem install kitchen-ansible
```

## Execution
Now that everything is in place, we can use test kitchen to run the ansible
playbook(s) to set up the environment and then use busser-bats to test it.
```
KITCHEN_SUT=<hostname or ip address of SUT> kitchen converge
KITCHEN_SUT=<hostname or ip address of SUT> kitchen verify
```

### Variables
#### Environment variable for kitchen
__This KITCHEN_SUT variable is required.__
The .kitchen.yml file uses the environment variable `KITCHEN_SUT` to identify
the pre-deployed host that kitchen should used for the provisioner and
verifier.

#### Testing variables for bats
In order to provide `bats` with the variables needed to perform the desired
OpenStack validation, they must be updated in the
`tests/integration/default/bats/variables.bash` file. Since `bats` is run
directly on the SUT it cannot inherit environment variables from `kitchen.
Therefore, they are stored in the `variables.bash` file which is copied to the
SUT and loaded during the test execution phase.

__The testing variables MUST be updated to reflect your target environment.__

## Example setup
### Ubuntu 14.04 Trusty
The following example setup assumes the use of Ubuntu 14.04 (Trusty-Tahr) as
the test runner for all of this to be installed on. These commands are
assembled in one place below from those given above for your convenience.
```
sudo apt-get update
sudo apt-get install -y git-core
sudo apt-get install -y python3 python3-dev
sudo apt-get install -y libssl-dev libreadline-dev zlib1g-dev  # these libraries are needed to compile ruby
sudo apt-get install -y virtualbox
curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
sudo python get-pip.py
sudo pip install --upgrade virtualenv
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
~/.rbenv/bin/rbenv init
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash
mkdir -p ~/.rbenv/plugins
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
rbenv install 2.4.3
rbenv rehash
rbenv global  2.4.3
git clone https://github.com/johnduarte/kitchen-ansible-example.git
cd kitchen-ansible-example
virtualenv --python python3 venv
source venv/bin/activate
gem install test-kitchen
gem install kitchen-ansible
```
