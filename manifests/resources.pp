define users::resources($user, $hash) {

  create_resources($name, $hash[$name], {
    user => $user,
  })

}
