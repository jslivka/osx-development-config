#  ---------------------------------------------------------------------------
#
#  Who: John Slivka <slivkajb@gmail.com>
#  Description:  This file holds all my bash configurations and aliases
#
#  Sections:
#  1.  Environment Configuration
#  2.  Terminal
#  3.  File and Folder Management
#  4.  Networking
#  5.  Notes & Etc.
#
#  ---------------------------------------------------------------------------

#   ------------------------------------
#   1. ENVIRONMENT CONFIGURATION
#   ------------------------------------

# show git branch in prompt
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "

# ls colors
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Set paths
export PATH="$PATH:/usr/local/bin/"
export PATH="$HOME/bin/:$PATH"
export PATH="$HOME/Library/Python/2.7/bin:$PATH"
# set go en
export PATH=$PATH:/usr/local/go/binv
export GOPATH=$HOME/proj/go
# vim
source ~/.vimrc

# Set default blocksize for ls, df, du
# from: http://hints.macworld.com/comment.php?mode=view&cid=24491
export BLOCKSIZE=1k

# istio binaries
export PATH=$PATH:~/proj/istio-0.4.0/bin

# set up amazon web services credentials
export AWS_CONFIG_FILE="${HOME}/.aws/config"
if [[ -f $AWS_CONFIG_FILE ]]; then
  export AWS_ACCESS_KEY=$(awk -F= '/^aws_access_key_id/{ gsub(/[[:blank:]]+/,""); print $2 }' $AWS_CONFIG_FILE)
  export AWS_SECRET_KEY=$(awk -F= '/^aws_secret_access_key/{ gsub(/[[:blank:]]+/,""); print $2 }' $AWS_CONFIG_FILE)
  export AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY"
  export AWS_SECRET_ACCESS_KEY="$AWS_SECRET_KEY"
fi

#   ----------------------------------
#   2. TERMINAL
#   ----------------------------------

alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'
alias ssh='ssh -oStrictHostKeyChecking=no'
alias qfind="find . -name "

# K8S
alias k=kubectl
alias ks="kubectl -n kube-system"

# lr:  Full Recursive Directory Listing
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

#   ----------------------------------
#   3. FILE AND FOLDER MANAGEMENT
#   ----------------------------------

zipf () { zip -r "$1".zip "$1" ; }          # zipf:         To create a ZIP archive of a folder
alias numFiles='echo $(ls -1 | wc -l)'      # numFiles:     Count of non-hidden files in current dir
alias make1mb='mkfile 1m ./1MB.dat'         # make1mb:      Creates a file of 1mb size (all zeros)
alias make5mb='mkfile 5m ./5MB.dat'         # make5mb:      Creates a file of 5mb size (all zeros)
alias make10mb='mkfile 10m ./10MB.dat'      # make10mb:     Creates a file of 10mb size (all zeros)

#   ----------------------------------
#   4. NETWORKING
#   ----------------------------------

alias myip='curl api.ipify.org -w "\n"'                     # myip:         Public facing IP Address
alias netCons='lsof -i'                             # netCons:      Show all open TCP/IP sockets
alias flushDNS='dscacheutil -flushcache'            # flushDNS:     Flush out the DNS Cache
alias lsock='sudo /usr/sbin/lsof -i -P'             # lsock:        Display open sockets
alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'   # lsockU:       Display only open UDP sockets
alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'   # lsockT:       Display only open TCP sockets
alias ipInfo0='ipconfig getpacket en0'              # ipInfo0:      Get info on connections for en0
alias ipInfo1='ipconfig getpacket en1'              # ipInfo1:      Get info on connections for en1
alias openPorts='sudo lsof -i | grep LISTEN'        # openPorts:    All listening connections
alias showBlocked='sudo ipfw list'                  # showBlocked:  All ipfw rules inc/ blocked IPs

# autocomplete known hosts

_complete_ssh_hosts ()
{
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  comp_ssh_hosts=`cat ~/.ssh/known_hosts | \
            cut -f 1 -d ' ' | \
            sed -e s/,.*//g | \
            grep -v ^# | \
            uniq | \
            grep -v "\[" ;
    cat ~/.ssh/config | \
            grep "^Host " | \
            awk '{print $2}'
    `
  COMPREPLY=( $(compgen -W "${comp_ssh_hosts}" -- $cur))
  return 0
}
complete -F _complete_ssh_hosts ssh

#   ii:  display useful host related informaton
#   -------------------------------------------------------------------
    ii() {
        echo -e "\nYou are logged on $HOST"
        echo -e "\nAdditionnal information:$NC " ; uname -a
        echo -e "\nUsers logged on:$NC " ; w -h
        echo -e "\nCurrent date :$NC " ; date
        echo -e "\nMachine stats :$NC " ; uptime
        echo -e "\nCurrent network location :$NC " ; scselect
        echo -e "\nPublic facing IP Address :$NC " ;myip
        echo -e "\n$DNS Configuration:$NC " ; scutil --dns
        echo
    }

#   ----------------------------------
#   5. NOTES & ETC.
#   ----------------------------------


