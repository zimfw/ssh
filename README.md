ssh
===

Provides a convenient way to load ssh-agent. This enables one-time login and
caching of SSH credentials per session.

Settings
--------

To define the identities (from `~/.ssh`) to be loaded and cached on login, add:

    zstyle ':zim:ssh' ids 'id_rsa1' 'id_rsa2' 'id_rsa3'

to the beginning of your `~/.zshrc`, before the modules are initialized with
`source ${ZIM_HOME}/init.zsh`.

macOS
-----

**You don't need this module on macOS**. macOS already starts ssh-agent, and ssh
can store key passphrases in the keychain and add keys to the agent on first use.

Add this to your `~/.ssh/config`:

    Host *
      AddKeysToAgent yes
      UseKeychain yes

If your config is shared with other systems, add `IgnoreUnknown UseKeychain`
under `Host *`.

If you also need your keys in the agent before ssh first uses them, for example
for SSH commit signing or other tools that talk to the agent directly, add
`ssh-add --apple-load-keychain -q` to your `~/.zshrc`. It loads the keys whose
passphrases are already stored in the keychain, without asking for anything.
