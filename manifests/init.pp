define users(
  $match      = 'all',
  $hash       = undef
) {

  include stdlib

  $_match = $match ? {
    'any'   => 'all',
    'all'   => 'all',
    'first' => 'first',
    default => 'all',
  }

  if $hash {
    $_hash = $hash
  } else {
    # The use of 'all' and 'first' has this meaning: 'all' will
    # traverse the hierarchy and get all matches, 'first' will
    # only
    case $_match {
      'all': {
        $_hash = hiera_hash("users_${name}", undef)
      }
      'first': {
        $_hash = hiera("users_${name}", undef)
      }
      default: {
        fail('unreachable')
      }
    }
  }
  
  if $_hash {
    $users = keys($_hash)
    users::setup {
      $users:
        hash => $_hash;
    }
  } else {
    notify { "no data for resource '${name}' title '${title}'": }
  }
}
