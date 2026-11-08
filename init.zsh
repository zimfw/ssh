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
      # Look for agent socket from systemd user unit
      local ssh_sock
      if [[ -n ${XDG_RUNTIME_DIR} && -S ${XDG_RUNTIME_DIR}/ssh-agent.socket ]]; then
        ssh_sock=${XDG_RUNTIME_DIR}/ssh-agent.socket
        SSH_AUTH_SOCK=${ssh_sock} ssh-add -l &>/dev/null
        if (( ? == 2 )) ssh_sock=
      fi
      if [[ -n ${ssh_sock} ]]; then
        export SSH_AUTH_SOCK=${ssh_sock}
        unset SSH_AGENT_PID
      else
        # Start agent and store agent connection info
        (umask 066; ssh-agent -s >! ${ssh_env})
        source ${ssh_env} >/dev/null
      fi
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
