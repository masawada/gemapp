GEMAPP
======

## Requirements
- ruby
- bundler

## Installation
drop `gemapp` in your $PATH and `echo "export $HOME/.gemapps/.bin:$PATH" > .*shrc`

All gems are installed in `$HOME/.gemapps`

## Usage
### Install gemapps
```
$ gemapp <app_name>
```

for example:

```
$ gemapp sass
$ gemapp -g https://github.com/motemen/git-browse-remote.git git-browse-remote
```

### Uninstall gemapps
```
$ gemapp -r <app_name>
```

for example:

```
$ gemapp -r sass
```

### Installed app list
```
$ gemapp -l
```
