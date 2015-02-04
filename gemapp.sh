# properties
GEMAPP_HOME=$HOME/.gemapps
GEMAPP_BIN_DIR=$GEMAPP_HOME/.bin
APP_NAME=`basename $0`
VERSION='1.0'

# init
if ! test -d $GEMAPP_HOME ; then
  mkdir $GEMAPP_HOME
  mkdir $GEMAPP_BIN_DIR
fi

# functions
usage() {
  echo "Usage: $APP_NAME [-r|--remove] [-g|--git-repo <uri>] <gem_name>"
  exit 1
}

version() {
  echo $VERSION
  exit 1
}

validate_option() {
  if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
    echo "$APP_NAME: option requires an argument -- $1" 1>&2
    exit 1
  fi
}

# install functions
install() {

  # check if app already exists
  if test -d $APP_DIR ; then
    echo "app ${GEM_NAME} already exists."
    exit 1
  fi

  mkdir $APP_DIR

  _create_gemfile
  _create_binfile
  _install_gems

  echo 'install' $GEM_NAME
}

_create_gemfile() {
  cat << _EOF_ > $APP_GEMFILE
source 'https://rubygems.org'

gem '$GEM_NAME'
_EOF_
}

_create_binfile() {
  cat << _EOF_ > $APP_BIN
BUNDLE_GEMFILE=$APP_GEMFILE bundle exec $GEM_NAME \$@
_EOF_
  chmod +x $APP_BIN
}

_install_gems() {
  BUNDLE_GEMFILE=$APP_GEMFILE bundle install --path vendor/bundle
}

# remove functions
uninstall() {
  echo 'uninstall' $GEM_NAME
}

# main
## analyze options
REMOVE_FLAG=0
for OPT in "$@"
do
  case "$OPT" in
    '-h' | '--help' )
      usage
      ;;
    '-v' | '--version' )
      version
      ;;
    '-g' | '--git-repo' )
      validate_option $1 $2
      GIT_REPO="$2"
      shift 2
      ;;
    '-r' | '--remove' )
      REMOVE_FLAG=1
      shift 1
      ;;
    -*)
      echo "$APP_NAME: illegal option -- '$(echo $1 | sed 's/^-*//')'" 1>&2
      exit 1
      ;;
    *)
      if [[ ! -z "$1" ]] && [[ ! "$1" =~ ^-+ ]]; then
        GEM_NAME="$1"
      fi
      ;;
  esac
done

## check GEM_NAME
if test -z $GEM_NAME; then
  usage
fi

## install/uninstall proc
APP_DIR=$GEMAPP_HOME/$GEM_NAME
APP_GEMFILE=$APP_DIR/Gemfile
APP_BIN=$GEMAPP_BIN_DIR/$GEM_NAME

if test $REMOVE_FLAG -eq 1; then
  uninstall
else
  install
fi
