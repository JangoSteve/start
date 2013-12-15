# Start.sh

A simple bash command to start your local web project without having to
remember whether it's a Rails app, Node app, Sinatra app, Jekyll site,
Gollum wiki, Rack app, Foreman project, or whatever else; whether it uses
Bundler or not; what the server command is; or what port the project runs
on by default.

Just `cd` into the project's directory and run

```
start
```

That's it.

## Why?

I tend to write lots of little web utilities, sites, and applications. I
got tired of trying to remember what the command was to serve the app up
locally so I could open it in my browser and get to coding.

Every framework seems to have its own webserver shortcut and its own
default port. Even when I did finally remember what command to use to
start that app's webserver, I'd have to and wait for the
command output to the terminal to remember what port it would run on
before I could open it in my browser. Rails would run on 3000, Sinatra
and Gollum on 4567, Jekyll on 4000; then I'd add Foreman to the mix 
and now the port changes to 5000. Ugh.

And then frameworks like Jekyll change their webserver
commands entirely; now I have to remember when I built this Jekyll app, so I can
figure out which version it uses and whether to use the new command or the old one.

Enough already! Now I just run `start` and open my browser to
http://localhost:3000.

## How?

This command line utility uses some shortcuts and hacks to detect what
kind of project the current directory is, so that it can stay *fast*.

This means, it doesn't try to invoke Ruby or Node or any other language
when it can use Bash to determine with acceptable confidence what type
of project the current directory is. This usually means
checking for the existence of certain files that are required for
projects of a given framework.

## Options

Currently, Start only has one option for the port. By default, all
projects started with Start run on port 3000. If you'd like to run the
app on a different port, use the `-p` flag:

```
start -p 4567
```

## Current detection types

### Foreman

If a `Procfile` is detected in the root directory of the current
project, then Start simply runs `foreman start` and not use any
further detection, since Foreman manages the processes already.

By convention, Start will first look for `Procfile.dev` if it exists,
and then it will look secondly for `Procfile`.

### Bundler

If a `Gemfile` is detected in the root directory, Start will still try
to detect what type of project the current directory is, but once it
finds that command, it will preface it with `bundle exec`.

### Rack

If a `config.ru` file is detected in the root directory, Start will run
`rackup`.

### NPM

If a `package.json` file is detected in the root directory, Start will
run `npm start`. This also works for Express and other apps, so no
additional detection is built specifically for them.

### Jekyll

If a `_config.yml` file and `_site` directory are detected in the root
directory, Start will run `jekyll serve`. If that fails, it will
fallback to `jekyll --server`, which is the command for older versions
of Jekyll.

It's faster to try the first way and fallback to the second than it is
to run a command like `gem list` to try to figure out what version of
Jekyll is being used.

### Gollum

If a `home.*` file is detected in the root directory, where the
extension can be any markup template extension, Start will run `gollum`.

We may need to make this detection more specific the first time we add a
project-type that may also conventionally have a `home.*` file.

## More

If you have another application that isn't currently detected, please
open an issue or pull request.
