# git::clone
#
# A wrapper around `git-clone`.
#
# Example:
#   git::clone { 'git@github.com/my/project.git':
#     revision => 'abcd123',
#     path     => '/var/www/project',
#   }
define git::clone(
  $depth    = undef,
  $path     = undef,
  $revision = 'master',
  $user     = undef,
) {
  include ::git

  $exec_paths = [
    '/usr/bin',
    $::git_exec_path,
  ]

  exec { 'code deploy':
    name => "git clone --depth=${depth} ${name} ${path}",
    path => $exec_paths,
    user => $user,
  }

  if ($revision != 'master') {
    # if revision is passed a path must be passed also.

    exec { "checkout code revision":
      cwd  => $path,
      name => "git checkout ${::revision}",
      path => $exec_paths,
      user => $user,
    }

    Exec['code deploy'] -> Exec['checkout code revision']
  }
}
