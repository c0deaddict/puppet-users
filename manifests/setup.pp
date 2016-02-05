define users::setup($hash) {

  if ! defined(User[$name]) {
    user { $name :
      allowdupe             => $hash[$name]['allowdupe'],
      attribute_membership  => $hash[$name]['attribute_membership'],
      attributes            => $hash[$name]['attributes'],
      auth_membership       => $hash[$name]['auth_membership'],
      auths                 => $hash[$name]['auths'],
      comment               => $hash[$name]['comment'],
      ensure                => $hash[$name]['ensure'],
      expiry                => $hash[$name]['expiry'],
      forcelocal            => $hash[$name]['forcelocal'],
      gid                   => $hash[$name]['gid'],
      groups                => $hash[$name]['groups'],
      home                  => $hash[$name]['home'],
      ia_load_module        => $hash[$name]['ia_load_module'],
      key_membership        => $hash[$name]['key_membership'],
      keys                  => $hash[$name]['keys'],
      managehome            => $hash[$name]['managehome'],
      membership            => $hash[$name]['membership'],
      password              => $hash[$name]['password'],
      password_max_age      => $hash[$name]['password_max_age'],
      password_min_age      => $hash[$name]['password_min_age'],
      profile_membership    => $hash[$name]['profile_membership'],
      profiles              => $hash[$name]['profiles'],
      project               => $hash[$name]['project'],
      provider              => $hash[$name]['provider'],
      purge_ssh_keys        => $hash[$name]['purge_ssh_keys'],
      role_membership       => $hash[$name]['role_membership'],
      roles                 => $hash[$name]['roles'],
      salt                  => $hash[$name]['salt'],
      shell                 => $hash[$name]['shell'],
      system                => $hash[$name]['system'],
      uid                   => $hash[$name]['uid'],
    }

    $ssh_authorized_keys = $hash[$name]['ssh_authorized_keys']
    if $ssh_authorized_keys {
      if is_hash($ssh_authorized_keys) {
        $prefixed_ssh_authorized_keys = prefix_keys($ssh_authorized_keys, "${name}-")
        create_resources('Ssh_authorized_key', $prefixed_ssh_authorized_keys, {user => $name})
      } else {
        notify { "user ssh key data for ${name} must be in hash form": }
      }
    }

    $resources = $hash[$name]['resources']
    if $resources {
      $actual_home = $hash[$name]['home'] ? {
        undef   => $name ? {
          'root'  => '/root',
          default => "/home/${name}",
        },
        default => $hash[$name]['home'],
      }

      if is_hash($resources) {
        $resources.each |$key, $value| {
          if $key == 'identity' {
            $value.each |$class, $params| {
              create_resources($class, {$name => $params}, {
                user => $name,
                home => $actual_home,
              })
            }
          } else {
            # all user resources are prefixed by the user to make them globally unique
            create_resources($key, prefix_user_resources($value, "${name}-"), {
              user => $name,
              home => $actual_home,
            })
          }
        }
      } else {
        notify { "user resources for ${name} must be in hash form": }
      }
    }
  }

}
