start(){
  if [ -f ./Procfile.dev ];
  then
    echo "Procfile.dev detected"
    echo "foreman start -f Procfile.dev"
    foreman start -f Procfile.dev
  elif [ -f ./Procfile ];
  then
    echo "Procfile detected"
    echo "foreman start"
    foreman start
  else
    echo "No Procfiles detected, falling back to rails"
    echo "rails server"
    rails server
  fi
}
