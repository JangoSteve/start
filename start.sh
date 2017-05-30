start(){
  local foreman=false
  local executinglabel="Executing:"
  local planblabel="Command failed, time for Plan B"
  local yellow="\033[1;33m"
  local cyan="\033[1;36m"
  local reset="\033[0;0m"
  local port="3000"

  # Reset, so getopts will parse options every time function is called
  OPTIND=1

  while getopts ":p:" opt; do
    case $opt in
      p)
        port=$OPTARG
        ;;
      \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
      :)
        echo "Option -$OPTARG requires an argument." >&2
        exit 1
        ;;
    esac
  done

  if [ -f ./Procfile.dev ];
  then
    local messagea="Procfile.dev detected blah"
    local commanda="foreman start -f Procfile.dev -p $port"
    foreman=true
  elif [ -f ./Procfile ];
  then
    local messagea="Procfile detected"
    local commanda="foreman start -p $port"
    foreman=true
  elif [ -f ./config/boot.rb ]
  then
    local messagea="No Procfiles detected, falling back to rails"
    local commanda="rails server"
  elif [ -f ./config.ru ]
  then
    local messagea="Rack app detected"
    local commanda="rackup --port $port config.ru"
  elif [ -f ./package.json ]
  then
    local messagea="NPM app detected"
    local commanda="npm start"
  elif [[ -f ./_config.yml && -d ./_site ]]
  then
    local messagea="Jekyll site detected"
    local commanda="jekyll serve --watch --port $port"
    local messageb="Jekyll < 1.0 detected"
    local commandb="jekyll --server $port --pygments --auto"
  elif [ -f ./home.* ]
  then
    local messagea="Gollum wiki detected"
    local commanda="gollum --css --js --port $port"
  elif [ -f ./config.toml && -f ./themes ] 
  then
    local messagea="Hugo site detected"
    local commanda="hugo server -p $port"
  elif [ -f ./manage.py ];
  then
    local messagea="Django app detected"
    local commanda="python manage.py runserver $port"
  else
    local messagea="Could not detect app type, do nothing"
  fi

  if [[ -n "$commanda" && -f Gemfile && ! $foreman ]];
  then
    commanda="bundle exec $commanda"
    if [ -n "$commandb" ];
    then
      commandb="bundle exec $commandb"
    fi
  fi

  echo -e "$yellow$messagea$reset"
  if [[ -n "$commanda" && -n "$commandb" ]]
  then
    {
      echo -e "$cyan$executinglabel$reset $commanda"
      $commanda
    } || {
      echo $planblabel
      echo -e "$yellow$messageb$reset"
      echo -e "$cyan$executinglabel$reset $commandb"
      $commandb
    }
  elif [ -n "$commanda" ]
  then
    echo -e "$cyan$executinglabel$reset $commanda"
    $commanda
  fi
}
