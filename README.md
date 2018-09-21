ssh
===

Provides a convenient way to load ssh-agent. This enables one-time login and
caching of ssh credentials per session.

Settings
--------

To define the identities (from `~/.ssh`) to be loaded and cached on login, use:

    zstyle ':zim:ssh' ids 'id_rsa1' 'id_rsa2' 'id_rsa3'
