export PATH="/usr/local/bin:$PATH"
export LANG=ja_JP.UTF-8
export LESSCHARSET=utf-8

# android
export ANDROID_HOME=/Applications/Android\ Studio.app/sdk
export PATH=$PATH:${ANDROID_HOME}/platform-tools

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# openni2
export OPENNI2_INCLUDE=/usr/local/include/ni2
export OPENNI2_REDIST=/usr/local/lib/ni2

# app
# apache
alias apachestart="sudo apachectl start"
alias apachestop="sudo apachectl stop"

# middleman
alias be="bundle exec"
alias bemm="bundle exec middleman"

alias skitch="open -a skitch"
alias st="open -a sourcetree"
alias mail="open -a mail"
alias codekit="open -a codekit"
alias ios="open /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Applications/iPhone\ Simulator.app"
alias mou="open -a mou"

# cd directry
alias code="cd workspace/code"
alias cdmampconf="cd /Applications/MAMP/conf/apache/"

# ftp
alias ftpheteml="ftp ftp178.heteml.jp"

# scp
alias scpasmileup="scp -P 2222 -r dev/asmile  wayout360@ssh178.heteml.jp:web/daaishi/test/"


# show hidden-files
alias hfon="defaults write com.apple.finder AppleShowAllFiles true|killall Finder"
# hidden hidden-files
alias hfoff="defaults write com.apple.finder AppleShowAllFiles false|killall Finder"

# dock position
alias dockleft="defaults write com.apple.dock pinning -string start |  killall Dock"
alias dockcenter="defaults write com.apple.dock pinning -string middle |  killall Dock"
alias dockright="defaults write com.apple.dock pinning -string end |  killall Dock"

# widget
alias widgeton="defaults write com.apple.dashboard devmode YES"
alias widgetoff="defaults write com.apple.dashboard devmode NO"

# count images
alias countimages="find . -name '*.png' -o -name '*.jpg' -o -name '*.gif' | wc -l"

# delete .DS_Store
alias deleteds="find . -name '.DS_Store' -print -exec rm {} ';'"

echo "load zprofile"
