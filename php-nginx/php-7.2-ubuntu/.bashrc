# Display full hostname in prompt and set term title
export PS1="\033[01;32m\]\u@\H\033[00m\]:\033[01;34m\]\w\$\033[00m\]"
export PROMPT_COMMAND='echo -ne "\033]0;$HOSTNAME \007"

# Set timezone
export TZ="Europe/Warsaw"

# Set TERM env - it will be needed for using some packages
export TERM="xterm"

# Set long timeout for Composer (otherwise we might get timeouts when installing some repos)
export COMPOSER_PROCESS_TIMEOUT=2000

# We will run Composer as root and don't want this warning
export COMPOSER_ALLOW_SUPERUSER=1

# Set Composer alias
alias composer="/usr/local/bin/composer"

# Fix for MC (actually ncurses) to display lines properly
export LANG="C.UTF-8"

# Alias for Artisan
alias a="php artisan"

# Alias for PHPUnit
alias phpunit="vendor/bin/phpunit"

# Alias for root project directory
alias www="cd /usr/share/nginx/html/"

# Enable colors for ls
if [ -x /usr/bin/dircolors ]; then
    alias ls='ls --color=auto'
fi

# Start in website directory by default
cd /usr/share/nginx/html/
