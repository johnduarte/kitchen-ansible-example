load variables

@test "openstack server list successfully returns existing compute instance" {
    run openstack server list                              \
        --insecure                                         \
        --os-identity-api-version=3                        \
        --os-auth-url=https://$OS_CONTROLLER:5000/v3       \
        --os-project-name=$OS_PROJECT                      \
        --os-username=$OS_USERNAME                         \
        --os-password=$OS_PASSWORD
    [ "$status" -eq 0 ]
    [[ ${lines[-2]} =~ mycliinstance ]]
}

@test "openstack server create successfully creates compute instance" {
    run openstack server create                            \
        --insecure                                         \
        --os-identity-api-version=3                        \
        --os-auth-url=https://$OS_CONTROLLER:5000/v3       \
        --os-project-name=$OS_PROJECT                      \
        --os-username=$OS_USERNAME                         \
        --os-password=$OS_PASSWORD                         \
        --flavor $OS_INSTANCE_FLAVOR                       \
        --image $OS_IMAGE                                  \
        --nic net-id=$OS_NET_ID                            \
        --security-group default                           \
        foobar
    [ "$status" -eq 0 ]
}

@test "openstack server delete successfully deletes compute instance" {
    run openstack server delete                            \
        --insecure                                         \
        --os-identity-api-version=3                        \
        --os-auth-url=https://$OS_CONTROLLER:5000/v3       \
        --os-project-name=$OS_PROJECT                      \
        --os-username=$OS_USERNAME                         \
        --os-password=$OS_PASSWORD                         \
        foobar
    [ "$status" -eq 0 ]
}
