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

Unintuitively, the test kitchen verifier must be defined as
`ruby_bindir: '/usr/bin'`. This enables the `busser-bats` framework to
be installed on the provisioned _System Under Test_ in order to execute
the tests natively on the SUT.
