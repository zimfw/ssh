#
# Set up ssh-agent
#

# Don't do anything unless we can actually use ssh-agent
(( ${+commands[ssh-agent]} )) && () {
  ssh-add -l &>/dev/null
  if (( ? == 2 )); then
    # Unable to contact the authentication agent

    # Load stored agent connection info
    local -r ssh_env=${HOME}/.ssh-agent
    if [[ -r ${ssh_env} ]] source ${ssh_env} >/dev/null

    ssh-add -l &>/dev/null
    if (( ? == 2 )); then
        # Start agent and store agent connection info
        (umask 066; ssh-agent >! ${ssh_env})
        source ${ssh_env} >/dev/null
    fi
  fi

  # Load identities
  ssh-add -l &>/dev/null
  if (( ? == 1 )); then
    local -a zssh_ids
    zstyle -a ':zim:ssh' ids 'zssh_ids'
    if (( ${#zssh_ids} )); then
      ssh-add ${HOME}/.ssh/${^zssh_ids} 2>/dev/null
    else
      ssh-add 2>/dev/null
    fi
  fi
}
