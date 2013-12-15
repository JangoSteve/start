start(){
  local foreman=false
  local executinglabel="Executing:"
  local planblabel="Command failed, time for Plan B"
  local yellow="\033[1;33m"
  local cyan="\033[1;36m"
  local reset="\033[0;0m"

  if [ -f ./Procfile.dev ];
  then
    local message="Procfile.dev detected"
    local command="foreman start -f Procfile.dev -p 3000"
    foreman=true
  elif [ -f ./Procfile ];
  then
    local message="Procfile detected"
    local command="foreman start -p 3000"
    foreman=true
  elif [ -f ./config/boot.rb ]
  then
    local message="No Procfiles detected, falling back to rails"
    local command="rails server"
  elif [ -f ./config.ru ]
  then
    local message="Rack app detected"
    local command="rackup --port 3000 config.ru"
  elif [ -f ./package.json ]
  then
    local message="NPM app detected"
    local command="npm start"
  elif [[ -f ./_config.yml && -d ./_site ]]
  then
    local message="Jekyll site detected"
    local command="jekyll serve --watch --port 3000"
    local messageb="Jekyll < 1.0 detected"
    local commandb="jekyll --server 3000 --pygments --auto"
  else
    local message="Could not detect app type, do nothing"
  fi
  if [[ -f Gemfile && ! $foreman ]];
  then
    command="bundle exec $command"
    if [ commandb ];
    then
      commandb="bundle exec $commandb"
    fi
  fi

  echo -e "$yellow$message$reset"
  if [ commandb ]
  then
    {
      echo -e "$cyan$executinglabel$reset $command"
      $command
    } || {
      echo $planblabel
      echo -e "$yellow$messageb$reset"
      echo -e "$cyan$executinglabel$reset $commandb"
      $commandb
    }
  else
    echo -e "$cyan$executinglabel$reset $command"
    $command
  fi
}
