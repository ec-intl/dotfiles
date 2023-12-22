# zsh aliases
# Cloud computing aliases
# Shell aliases
alias ...="../../"
alias ....="../../.."
# Git aliases
alias gaac="gaa && gcmsg"
# Linting aliases
alias plb="python -m black -l 79 --experimental-string-processing"
alias plp="autopep8 -ira --experimental --max-line-length 79"
alias pli="isort -l 79 -j 4 --overwrite-in-place"
alias my-env="source $HOME/pysrc/$USER/bin/activate"
# Python aliases
#    Python
alias pm="python -m"
alias py="python"
#    Django
alias pcsu="python -m manage createsuperuser"
alias ptc="pytest --cov --doctest-modules . .."
alias prs="python -m manage runserver"
alias prt="python -m manage test"
alias ppi="python -m pip install"

# Define Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color
