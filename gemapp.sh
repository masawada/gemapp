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
  echo "Usage: $APP_NAME [-g|--git-repo <uri>] <gem_name>"
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

# main
## analyze options
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

# check GEM_NAME
if test -z $GEM_NAME; then
  usage
fi
