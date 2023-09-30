# Define Colors
RED='\[\033[0;31m\]'
GREEN='\[\033[0;32m\]'
YELLOW='\[\033[1;33m\]'
BLUE='\[\033[0;34m\]'
PURPLE='\[\033[0;35m\]'
CYAN='\[\033[0;36m\]'
WHITE='\[\033[1;37m\]'
NC='\[\033[0m\]' # No Color

# Fancy Prompt
PS1="${CYAN}\u${NC}@${CYAN}\h${NC}:${BLUE}\w${NC} \$(git branch 2>/dev/null | grep '^*' | colrm 1 2)${GREEN}$ ${NC}"

# Alias Definitions
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Git Aliases
-='cd -'
...=../../
....=../../..
.....=../../../..
......=../../../../..
1='cd -1'
2='cd -2'
3='cd -3'
4='cd -4'
5='cd -5'
6='cd -6'
7='cd -7'
8='cd -8'
9='cd -9'
_='sudo '
cp='nocorrect cp'
egrep='grep -E --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
fgrep='grep -F --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
g=git
ga='git add'
gaa='git add --all'
gaac='gaa && gcmsg'
gam='git am'
gama='git am --abort'
gamc='git am --continue'
gams='git am --skip'
gamscp='git am --show-current-patch'
gap='git apply'
gapa='git add --patch'
gapt='git apply --3way'
gau='git add --update'
gav='git add --verbose'
gb='git branch'
gbD='git branch --delete --force'
gba='git branch --all'
gbd='git branch --delete'
gbda='git branch --no-color --merged | command grep -vE "^([+*]|\s*($(git_main_branch)|$(git_develop_branch))\s*$)" | command xargs git branch --delete 2>/dev/null'
gbg='LANG=C git branch -vv | grep ": gone\]"'
gbgD='LANG=C git branch --no-color -vv | grep ": gone\]" | awk '\''{print $1}'\'' | xargs git branch -D'
gbgd='LANG=C git branch --no-color -vv | grep ": gone\]" | awk '\''{print $1}'\'' | xargs git branch -d'
gbl='git blame -w'
gbm='git branch --move'
gbnm='git branch --no-merged'
gbr='git branch --remote'
gbs='git bisect'
gbsb='git bisect bad'
gbsg='git bisect good'
gbsn='git bisect new'
gbso='git bisect old'
gbsr='git bisect reset'
gbss='git bisect start'
gc='git commit --verbose'
'gc!'='git commit --verbose --amend'
gca='git commit --verbose --all'
'gca!'='git commit --verbose --all --amend'
gcam='git commit --all --message'
'gcan!'='git commit --verbose --all --no-edit --amend'
'gcans!'='git commit --verbose --all --signoff --no-edit --amend'
gcas='git commit --all --signoff'
gcasm='git commit --all --signoff --message'
gcb='git checkout -b'
gcd='git checkout $(git_develop_branch)'
gcf='git config --list'
gcl='git clone --recurse-submodules'
gclean='git clean --interactive -d'
gcm='git checkout $(git_main_branch)'
gcmsg='git commit --message'
'gcn!'='git commit --verbose --no-edit --amend'
gco='git checkout'
gcor='git checkout --recurse-submodules'
gcount='git shortlog --summary --numbered'
gcp='git cherry-pick'
gcpa='git cherry-pick --abort'
gcpc='git cherry-pick --continue'
gcs='git commit --gpg-sign'
gcsm='git commit --signoff --message'
gcss='git commit --gpg-sign --signoff'
gcssm='git commit --gpg-sign --signoff --message'
gd='git diff'
gdca='git diff --cached'
gdct='git describe --tags $(git rev-list --tags --max-count=1)'
gdcw='git diff --cached --word-diff'
gds='git diff --staged'
gdt='git diff-tree --no-commit-id --name-only -r'
gdup='git diff @{upstream}'
gdw='git diff --word-diff'
gf='git fetch'
gfa='git fetch --all --prune --jobs=10'
gfg='git ls-files | grep'
gfo='git fetch origin'
gg='git gui citool'
gga='git gui citool --amend'
ggpull='git pull origin "$(git_current_branch)"'
ggpur=ggu
ggpush='git push origin "$(git_current_branch)"'
ggsup='git branch --set-upstream-to=origin/$(git_current_branch)'
ghh='git help'
gignore='git update-index --assume-unchanged'
gignored='git ls-files -v | grep "^[[:lower:]]"'
git-svn-dcommit-push='git svn dcommit && git push github $(git_main_branch):svntrunk'
gk='\gitk --all --branches &!'
gke='\gitk --all $(git log --walk-reflogs --pretty=%h) &!'
gl='git pull'
glg='git log --stat'
glgg='git log --graph'
glgga='git log --graph --decorate --all'
glgm='git log --graph --max-count=10'
glgp='git log --stat --patch'
glo='git log --oneline --decorate'
globurl='noglob urlglobber '
glod='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset"'
glods='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" --date=short'
glog='git log --oneline --decorate --graph'
gloga='git log --oneline --decorate --graph --all'
glol='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"'
glola='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all'
glols='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat'
glp=_git_log_prettily
gluc='git pull upstream $(git_current_branch)'
glum='git pull upstream $(git_main_branch)'
gm='git merge'
gma='git merge --abort'
gmom='git merge origin/$(git_main_branch)'
gms='git merge --squash'
gmtl='git mergetool --no-prompt'
gmtlvim='git mergetool --no-prompt --tool=vimdiff'
gmum='git merge upstream/$(git_main_branch)'
gp='git push'
gpd='git push --dry-run'
gpf='git push --force-with-lease --force-if-includes'
'gpf!'='git push --force'
gpoat='git push origin --all && git push origin --tags'
gpod='git push origin --delete'
gpr='git pull --rebase'
gpristine='git reset --hard && git clean --force -dfx'
gpsup='git push --set-upstream origin $(git_current_branch)'
gpsupf='git push --set-upstream origin $(git_current_branch) --force-with-lease --force-if-includes'
gpu='git push upstream'
gpv='git push --verbose'
gr='git remote'
gra='git remote add'
grb='git rebase'
grba='git rebase --abort'
grbc='git rebase --continue'
grbd='git rebase $(git_develop_branch)'
grbi='git rebase --interactive'
grbm='git rebase $(git_main_branch)'
grbo='git rebase --onto'
grbom='git rebase origin/$(git_main_branch)'
grbs='git rebase --skip'
grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
grev='git revert'
grh='git reset'
grhh='git reset --hard'
grhk='git reset --keep'
grhs='git reset --soft'
grm='git rm'
grmc='git rm --cached'
grmv='git remote rename'
groh='git reset origin/$(git_current_branch) --hard'
grrm='git remote remove'
grs='git restore'
grset='git remote set-url'
grss='git restore --source'
grst='git restore --staged'
grt='cd "$(git rev-parse --show-toplevel || echo .)"'
gru='git reset --'
grup='git remote update'
grv='git remote --verbose'
gsb='git status --short --branch'
gsd='git svn dcommit'
gsh='git show'
gsi='git submodule init'
gsps='git show --pretty=short --show-signature'
gsr='git svn rebase'
gss='git status --short'
gst='git status'
gsta='git stash push'
gstaa='git stash apply'
gstall='git stash --all'
gstc='git stash clear'
gstd='git stash drop'
gstl='git stash list'
gstp='git stash pop'
gsts='git stash show'
gstu='gsta --include-untracked'
gsu='git submodule update'
gsw='git switch'
gswc='git switch --create'
gswd='git switch $(git_develop_branch)'
gswm='git switch $(git_main_branch)'
gta='git tag --annotate'
gtcl='cd pysrc/clidapp/src/'
gtl='gtl(){ git tag --sort=-v:refname -n --list "${1}*" }; noglob gtl'
gts='git tag --sign'
gtsr='cd pysrc/statement_reader/src/'
gtv='git tag | sort -V'
gunignore='git update-index --no-assume-unchanged'
gunwip='git rev-list --max-count=1 --format="%s" HEAD | grep -q "\--wip--" && git reset HEAD~1'
gup='git pull --rebase'
gupa='git pull --rebase --autostash'
gupav='git pull --rebase --autostash --verbose'
gupom='git pull --rebase origin $(git_main_branch)'
gupomi='git pull --rebase=interactive origin $(git_main_branch)'
gupv='git pull --rebase --verbose'
gwch='git whatchanged -p --abbrev-commit --pretty=medium'
gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"'
gwt='git worktree'
gwta='git worktree add'
gwtls='git worktree list'
gwtmv='git worktree move'
gwtrm='git worktree remove'
history=omz_history
ipython='python3 -c '\''import IPython; IPython.terminal.ipapp.launch_new_instance()'\'
l='ls -lah'
la='ls -lAh'
ll='ls -lh'
ls='ls -G'
lsa='ls -lah'
man='nocorrect man'
md='mkdir -p'
mkdir='nocorrect mkdir'
mv='nocorrect mv'
my-env='source ~/pysrc/cmbengue/bin/activate'
pcsu='python -m manage createsuperuser'
plb='python -m black -l 79 --experimental-string-processing'
pli='isort -l 79 -j 4 --overwrite-in-place'
plp='autopep8 -ira --experimental --max-line-length 79'
pm='python -m'
ppi='python -m pip install'
prs='python -m manage runserver'
prt='python -m manage test'
ptc='pytest --cov --doctest-modules . ..'
py=python
pyfind='find . -name "*.py"'
pygrep='grep -nr --include="*.py"'
pyserver='python3 -m http.server'
rd=rmdir
run-help=man
ss-ec-intl='ssh eci-admin@192.168.100.200'
ss-imac='ssh 192.168.100.194'
ss-pincer='ssh 192.168.100.205'
su='nocorrect su'
sudo='nocorrect sudo'
which-command=whence
# Function to extract files
extract() {
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar e "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "Don't know how to extract '$1'..." ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

# cd with 'ls'
cl() {
    cd "$@" && ll
}

# Auto-correct typos in path names when using `cd`
shopt -s cdspell

# Enable color support for `ls` and `grep` command when using interactive terminals
case "$TERM" in
    xterm*|rxvt*) export LS_OPTIONS='--color=auto' ;;
    *) ;;
esac

# Enable programming languages for syntax highlighting in `less`
export LESSOPEN="| /usr/bin/source-highlight-esc.sh %s"
export LESS=' -R '

# Enable history appending instead of overwriting when exiting. And use a big history file
export HISTSIZE=10000
shopt -s histappend

# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Custom Welcome Message
echo -e "${GREEN}Welcome ${RED}$USER ${GREEN}to the ${PURPLE}Bash Shell${NC}"
