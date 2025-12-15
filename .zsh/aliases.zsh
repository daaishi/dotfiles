# エイリアス（oh-my-zshのgitプラグインと重複するものは除く）
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
# 安全なコマンド
alias rm='rm -i'                  # 削除前に確認
alias cp='cp -i'                  # 上書き前に確認
alias mv='mv -i'                  # 上書き前に確認
# 便利なエイリアス
alias h='history'
alias c='clear'
alias reload='source ~/.zshrc'    # 設定を再読み込み
alias path='echo $PATH | tr ":" "\n"'  # パスを改行区切りで表示
