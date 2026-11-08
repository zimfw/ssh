ssh
===

Provides a convenient way to load ssh-agent. This enables one-time login and
caching of SSH credentials per session.

You may not need this module
----------------------------

If your OS already starts ssh-agent for you, as macOS and some Linux desktop
sessions do, then you don't need this module. To check, run
`ssh-add -l; print "exit status = ${?}"` in a new shell without this module
enabled and make sure the exit status is not 2. Desktop sessions only provide
the agent to shells started from them, not to SSH or TTY login shells.

Without this module, add this to your `~/.ssh/config`, so ssh adds your keys to
the agent the first time they're used:

    Host *
      AddKeysToAgent yes

### macOS

Besides `AddKeysToAgent yes`, also add `UseKeychain yes` under `Host *` in your
`~/.ssh/config`, so ssh stores key passphrases in the keychain. If your config
is shared with other systems, then also add `IgnoreUnknown UseKeychain` under
`Host *`.

If you also need your keys in the agent before ssh first uses them, for example
for SSH commit signing or other tools that talk to the agent directly, add
`ssh-add --apple-load-keychain -q` to your `~/.zshrc`. It loads the keys whose
passphrases are already stored in the keychain, without asking for anything.

Settings
--------

When the agent has no keys, the module loads your default keys from `~/.ssh` on
startup. To define the identities to be loaded instead, add:

    zstyle ':zim:ssh' ids 'id_rsa1' 'id_rsa2' 'id_rsa3'

to the beginning of your `~/.zshrc`, before the modules are initialized with
`source ${ZIM_HOME}/init.zsh`.
