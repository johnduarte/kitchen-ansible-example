@test "screen is installed and in the path" {
      which screen
}

@test "screen configuration exists" {
      cat /etc/screenrc | grep "defnonblock" # this could be a more complex test
}
