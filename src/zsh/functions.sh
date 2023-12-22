# Print color coded messages
msg() {
  timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  case $1 in
    fail)
      echo "\n$timestamp \033[31m[  FAILURE  ]\033[0m $2\n"
      ;;
    ok)
      echo "\n$timestamp \033[32m[  SUCCESS  ]\033[0m $2\n"
      ;;
    warn)
      echo "$timestamp \033[33m[  WARNING  ]\033[0m $2"
      ;;
    info)
      echo "$timestamp \033[34m[INFORMATION]\033[0m $2"
      ;;
    *)
      echo "$timestamp [  NOTICE  ] $2"
      ;;
  esac
}
emsg() {
  msg "fail" "$1"
}
kmsg() {
  msg "ok" "$1"
}
imsg() {
  msg "info" "$1"
}
wmsg() {
  msg "warn" "$1"
}

# A greeting script
greet() {
  # Get the current hour
  timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  HOUR=$(date +%H)
  # If the hour is less than 12, it's morning
  if [ $HOUR -lt 12 ]; then
    echo "$timestamp Good Morning"
    # If the hour is between 12 and 18, it's afternoon
  elif [ $HOUR -lt 18 ]; then
    echo "$timestamp Good Afternoon"
    # Otherwise, it's evening
  else
    echo "$timestamp Good Evening"
  fi
}


# Change directory and list contents
cl() {
  cd "$@" && ll
}


# Extract archive using the correct program
extract() {
  imsg "Extracting $1 ..."
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
      *)           wmsg "I don't know how to extract '$1'..." ;;
    esac
  else
    emsg "'$1' is not a valid archive file!"
  fi
}


# Git add commit and push
gacp() {
  imsg "Pushing all changes to GitHub..."
  git add . && git commit -m "$1" && git push && kmsg "Push completed succssfully."
  [ ! $? ] && emsg "Push failed."
}


# Create default directories
make_default_directories() {
  makedir() {
    if [ ! -d "${HOME}/$1" ]; then
      imsg "Creating the $1 directory..."
      mkdir -p "${HOME}/$1"
    fi
  }
  directories=( Downloads bin lib src )
  for dir in "${directories[@]}"; do
    makedir "$dir"
  done
}


# Make a python virtual environment
python_venv() {
  python -m venv "$1" && source "$1/bin/activate"
}


# Encrypt file using openssl
encrypt() {
 imsg "Encrypting $1..."
 openssl aes-256-cbc -pbkdf2 -e -in "$1" -out "$1".ecr
 [ -f "$1.ecr" ] && rm -f "$1" && chmod 0700 "$1.ecr" && kmsg "$1 encrypted successfully."
 [ ! $? || ! -f "$1.ecr"] && emsg "Encryption failed."
}


decrypt() {
  imsg "Decrypting $1..."
  outfile=`echo $1 | sed 's/\.ecr$//'`
  openssl aes-256-cbc -pbkdf2 -d -in "$1" -out "$outfile"
  [ -f "$outfile" ] && kmsg "Decryption successful."
  [ ! $? ] && emsg "Decryption failed"
}


# Set environment
setenv() {
  imsg "Setting environment variables from file: $1"
  set -a
  [ -f "$1" ] && source "$1" && kmsg "Environment successfully set." && set +a
  [ ! $? ] || [ ! -f "$1" ] && emsg "An error occurred. Likely file not found." && set +a
}


gen_secret_key() {
  echo `openssl rand -base64 32`
}


# Run functions
make_default_directories
