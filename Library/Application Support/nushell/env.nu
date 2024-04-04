# Nushell Environment Config File

def create_left_prompt [] {
    let path_segment = if (is-admin) {
        $"(ansi red_bold)($env.PWD)"
    } else {
        $"(ansi green_bold)($env.PWD)"
    }

    $path_segment
}

def create_right_prompt [] {
    let time_segment = ([
        (date now | format date '%m/%d/%Y %r')
    ] | str join)

    $time_segment
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = { create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = { create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = { "〉" }
$env.PROMPT_INDICATOR_VI_INSERT = { ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = { "〉" }
$env.PROMPT_MULTILINE_INDICATOR = { "::: " }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) | path expand -n }
    to_string: { |v| $v | path expand -n | str join (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) | path expand -n }
    to_string: { |v| $v | path expand -n | str join (char esep) }
  }
}

# Directories to search for scripts when calling source or use
#
# By default, <nushell-config-dir>/scripts is added
$env.NU_LIB_DIRS = [
    ($nu.config-path | path dirname | path join 'scripts')
]

# Directories to search for plugin binaries when calling register
#
# By default, <nushell-config-dir>/plugins is added
$env.NU_PLUGIN_DIRS = [
    ($nu.config-path | path dirname | path join 'plugins')
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')

# ruby
$env.PATH = ($env.PATH | split row (char esep) | prepend '/opt/homebrew/opt/ruby/bin')
$env.GEM_HOME = '/Users/jingyu/.gem'
$env.PATH = ($env.PATH | split row (char esep) | append '/Users/jingyu/.gem/bin')

# homebrew
$env.PATH = ($env.PATH | split row (char esep) | prepend '/opt/homebrew/bin')
$env.PATH = ($env.PATH | split row (char esep) | prepend '/opt/homebrew/sbin')

# pyenv
$env.PATH = ($env.PATH | split row (char esep) | prepend $"(pyenv root)/shims")

# anaconda
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/opt/homebrew/anaconda3/bin')

# golang
$env.PATH = ($env.PATH | split row (char esep) | append '/Users/jingyu/go/bin')
$env.PATH = ($env.PATH | split row (char esep) | append '/usr/local/go/bin')

# bin
$env.PATH = ($env.PATH | split row (char esep) | append '/usr/local/bin/')

# vscode
$env.PATH = ($env.PATH | split row (char esep) | append '/Applications/Visual Studio Code.app/Contents/Resources/app/bin')

# rust
$env.PATH = ($env.PATH | split row (char esep) | append '/Users/jingyu/.cargo/bin')


# proxy
# $env.http_proxy = 'http://127.0.0.1:7890'
# $env.https_proxy = 'http://127.0.0.1:7890'
# $env.NO_PROXY = 'localhost,127.0.0.1,::1'

#pnpm
let pnpm_home = '/Users/jingyu/Library/pnpm'
$env.PNPM_HOME = $pnpm_home
$env.PATH = ($env.PATH | split row (char esep) | append $pnpm_home)

# starship
mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu

# zoxide
zoxide init nushell | str replace --all "def-env" "def --env" | save -f ~/.zoxide.nu

# android
# $env.ANDROID_HOME = '/Users/jingyu/Library/Android/sdk'
# $env.ANDROID_NDK_HOME = '/Users/jingyu/Library/Android/sdk/ndk/25.0.8775105'
# $env.NDK_HOME = '/Users/jingyu/Library/Android/sdk/ndk/25.0.8775105'
#
# $env.TOOLCHAIN = $'($env.NDK_HOME)/toolchains/llvm/prebuilt/darwin-x86_64'
# $env.TARGET = 'aarch64-linux-android'
# $env.API = 33
#
# $env.AR = $'($env.TOOLCHAIN)/bin/llvm-ar'
# $env.CC = $'($env.TOOLCHAIN)/bin/($env.TARGET)($env.API)-clang'
# $env.AS = $env.CC
# $env.CXX = $'($env.TOOLCHAIN)/bin/($env.TARGET)($env.API)-clang++'
# $env.LD = $env.TOOLCHAIN + '/bin/ld'
# $env.RANLIB = $env.TOOLCHAIN + '/bin/llvm-ranlib'
# $env.STRIP = $env.TOOLCHAIN + '/bin/llvm-strip'
#
# $env.PATH = ($env.PATH | split row (char esep) | append $'($env.ANDROID_HOME)/cmdline-tools/latest/bin')
# $env.PATH = ($env.PATH | split row (char esep) | append $'($env.TOOLCHAIN)/bin')
#
# $env.JAVA_HOME = '/Users/jingyu/Applications/Android Studio.app/Contents/jbr/Contents/Home'
# $env.PATH = ($env.PATH | split row (char esep) | append '/Users/jingyu/Library/Android/sdk/emulator')
# $env.PATH = ($env.PATH | split row (char esep) | append '/Users/jingyu/Library/Android/sdk/platform-tools')

# flutter
$env.PATH = ($env.PATH | split row (char esep) | append '/Users/jingyu/flutter/bin')
$env.PATH = ($env.PATH | split row (char esep) | append '/Users/jingyu/.pub-cache/bin')
