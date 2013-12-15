start(){
  local foreman=false
  local executinglabel="Executing:"
  local planblabel="Command failed, time for Plan B"
  local yellow="\033[1;33m"
  local cyan="\033[1;36m"
  local reset="\033[0;0m"

  if [ -f ./Procfile.dev ];
  then
    local messagea="Procfile.dev detected"
    local commanda="foreman start -f Procfile.dev -p 3000"
    foreman=true
  elif [ -f ./Procfile ];
  then
    local messagea="Procfile detected"
    local commanda="foreman start -p 3000"
    foreman=true
  elif [ -f ./config/boot.rb ]
  then
    local messagea="No Procfiles detected, falling back to rails"
    local commanda="rails server"
  elif [ -f ./config.ru ]
  then
    local messagea="Rack app detected"
    local commanda="rackup --port 3000 config.ru"
  elif [ -f ./package.json ]
  then
    local messagea="NPM app detected"
    local commanda="npm start"
  elif [[ -f ./_config.yml && -d ./_site ]]
  then
    local messagea="Jekyll site detected"
    local commanda="jekyll serve --watch --port 3000"
    local messageb="Jekyll < 1.0 detected"
    local commandb="jekyll --server 3000 --pygments --auto"
  elif [ -f ./home.* ]
  then
    local messagea="Gollum wiki detected"
    local commanda="gollum --css --js --port 3000"
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
