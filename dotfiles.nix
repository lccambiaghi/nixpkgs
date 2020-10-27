{ config, lib, pkgs, ... }:

{
  # home.file.".zprofile".text = ''
  #   export PATH=$CUSTOM_PATH
  # '';

  home.file.".config/direnv/direnvrc".text = ''
    use_python() {
        if [ -n "$(which pyenv)" ]; then
            local pyversion=$1
            eval "$(pyenv init -)"
            pyenv local ''${pyversion} || log_error "Could not find pyenv version '''''${pyversion}'. Consider running 'pyenv install ''${pyversion}'"
        fi
    }

    layout_poetry() {
      if [[ ! -f pyproject.toml ]]; then
        log_error 'No pyproject.toml found.  Use `poetry new` or `poetry init` to create one first.'
        exit 2
      fi

      local VENV=$(dirname $(poetry run which python))
      export VIRTUAL_ENV=$(echo "$VENV" | rev | cut -d'/' -f2- | rev)
      export POETRY_ACTIVE=1
      PATH_add "$VENV"
    }

    layout_anaconda() {
      local ACTIVATE="/usr/local/anaconda3/bin/activate"

      if [ -n "$1" ]; then
        # Explicit environment name from layout command.
        local env_name="$1"
        source $ACTIVATE ''${env_name}
      elif (grep -q name: environment.yml); then
        # Detect environment name from `environment.yml` file in `.envrc` directory
        source $ACTIVATE `grep name: environment.yml | sed -e 's/name: //' | cut -d "'" -f 2 | cut -d '"' -f 2`
      else
        (>&2 echo No environment specified);
        exit 1;
      fi;
    }
    '';

  # home.file.".zshenv".text = ''
  #   export PATH="$HOME/.emacs.d/bin:$PATH"
  #   # export PATH="/usr/local/anaconda3/bin:$PATH"
  #   export PATH="/usr/local/opt/llvm/bin:$PATH"
  #   export PATH=/usr/local/bin:$PATH
  #   export PATH="$HOME/.pyenv/bin:$PATH"
  #   export PATH="$HOME/.pyenv/shims:$PATH"
  #   export PATH="$HOME/.poetry/bin:$PATH"
  #   export PATH="/Library/TeX/texbin/:$PATH" #latex
  #   # use /usr/local/opt/llvm/bin/clang instead of built-in
  #   export SHELL=/bin/zsh
  #   export PIPENV_VENV_IN_PROJECT="enabled"
  #   export CUSTOM_PATH=$PATH
  #   export LANG=en_US.UTF-8
  #   export LC_ALL=en_US.UTF-8
  #   export TERM=xterm-256color
  #   export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"
  #   export EDITOR=emacsclient
  #   export SSH_AGENT_PID=17088
  #   export SSH_AUTH_SOCK="/var/folders/g0/f7zdhs0s2nlfngvwp14kmlnh0000gn/T//ssh-1j7zub7wuXIl/agent.17087"
  # '';

  home.file.".clojure/deps.edn".text = ''
    {
    :paths ["src"]

    :deps {
            ;; com.billpiel/sayid {:mvn/version "0.0.18"}
            org.clojure/clojure {:mvn/version "1.10.1"}
            nrepl/nrepl         {:mvn/version "0.5.3"}
            }

    :aliases {:nrepl {:extra-deps {nrepl {:mvn/version "RELEASE"}}
                      :main-opts  ["-m" "nrepl.cmdline"]}
              :new   {:extra-deps {seancorfield/clj-new
                                    {:mvn/version "1.0.199"}}
                      :main-opts  ["-m" "clj-new.create"]}
              :test  {:extra-paths ["test"]
                      :extra-deps  {lambdaisland/kaocha {:mvn/version "1.0-612"}}
                      :main-opts   ["-m" "kaocha.runner"]}
              :rebel {:extra-deps {com.bhauman/rebel-readline {:mvn/version "0.1.4"}}
                      :main-opts  ["-m" "rebel-readline.main"]}
              }

    :mvn/repos {
                "central"      {:url "https://repo1.maven.org/maven2/"}
                "clojars"      {:url "https://repo.clojars.org/"}
                "bedatadriven" {:url "https://nexus.bedatadriven.com/content/groups/public/"}
                ;; "asm-all"      {:url "https://mvnrepository.com/artifact/org.ow2.asm/asm-all"}
                }
  '';

  home.file.".ipython/profile_default/startup/2-pandas.py".text = ''
    try:
        import pandas as pd
        pd.set_option('display.max_rows', 999)
        pd.set_option('expand_frame_repr', False)
        pd.set_option('display.max_columns', 500)
        pd.set_option('precision', 2)
        pd.set_option('display.float_format', '{:.2f}'.format)
        print("pandas imported and configured")
    except:
        print("pandas was not imported")
  '';


  # ".tmux.conf" = {
  #  text = ''
  #  set-option -g default-shell /run/current-system/sw/bin/fish
  #  set-window-option -g mode-keys vi
  #  '';
  # };

  # ".ssh/id_rsa.pub".source = ./id_rsa.pub;

}
