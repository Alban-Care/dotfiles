# ...

# Show parse the current branch of git
function parse_git_branch() {
        BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
        if [ ! "${BRANCH}" == "" ]
        then
                echo "[${BRANCH}${STAT}]"
        else
                echo ""
        fi
}

export PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w\[\e[0;33m\]\`parse_git_branch\`\[\e[m\]\\$ "
export PATH="~/go/bin:$PATH"

# Active ssh-agent automatically
#
# You will first need in the terminal: 
#       touch $HOME/.ssh/environment && chmod 600 $HOME/.ssh/environment
#

SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi

# Add ssh-agent key alias
# exemple: alias ssh-github='ssh-add ~/.ssh/id_ed25519-github'

# Add Apache2 keys alias
alias apache-status='sudo systemctl status apache2.service'
alias apache-start='sudo systemctl start apache2.service'
alias apache-stop='sudo systemctl stop apache2.service'
alias apache-restart='sudo systemctl restart apache2.service'
