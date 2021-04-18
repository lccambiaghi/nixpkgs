{ config, pkgs, ... }:

let
  homeDir = "/Users/luca";
in
{
  home.file = {
    # brewfile = {
    #   source = ./Brewfile;
    #   target = "Brewfile";
    # };
    clojure = {
      source = ./clojure;
      target = ".clojure";
      recursive = true;
    };
    ipython = {
      source = ./ipython;
      target = ".ipython";
      recursive = true;
    };
    ".npmrc".text = "prefix = ${homeDir}/.npm-packages";
    ".lintr".text = ''
linters: with_defaults(
  line_length_linter(120), 
  commented_code_linter = NULL
)
exclude: "# Exclude Linting"
exclude_start: "# Begin Exclude Linting"
exclude_end: "# End Exclude Linting"

    '';
    ".ideavimrc".text = ''
""" Map leader to space ---------------------
let mapleader = ","

""" Plugins  --------------------------------
""" https://github.com/JetBrains/ideavim/wiki/Emulated-plugins
set surround
" alt+n to select next
" g<A+n> to select all?
set multiple-cursors
set commentary
set easymotion         " /ss for easymotion
set textobj-entire     " vae selects buffer
set argtextobj         " via selects argument
set ReplaceWithRegister
set highlightedyank
set NERDTree

""" Plugin settings -------------------------
let g:argtextobj_pairs="[:],(:),<:>"

""" Common settings -------------------------
set showmode
set so=5
set incsearch
set nu
set scrolloff=5 sidescrolloff=10  " keep some lines before and after the cursor visible
set incsearch                     " show search results while typing
set clipboard=unnamedplus,unnamed,ideaput " integrate with system clipboard

""" Idea specific settings ------------------
set ideajoin
set ideastatusicon=gray
"set idearefactormode=keep

""" Mappings --------------------------------
""" https://github.com/fdietze/dotfiles/blob/master/.ideavimrc
" edit ideavim config
nnoremap <leader>vv :e ~/.ideavimrc<CR>
nnoremap <leader>vr :source ~/.ideavimrc<CR>

" make Y behave like D and C, yanking till end of line
map Y y$

" clear search highlighting
nnoremap <leader>/ :nohls<return><esc>

nmap + :action EditorIncreaseFontSize<CR>
nmap - :action EditorDecreaseFontSize<CR>
nmap <leader>= :action EditorResetFontSize<CR>

nmap <leader>=  :action ReformatCode<CR>

nmap <leader>ri :action Inline<CR>
nmap <leader>rr :action RenameElement<CR>
nmap <leader>rev :action IntroduceVariable<CR>
vmap <leader>rev :action IntroduceVariable<CR>
nmap <leader>rem :action ExtractMethod<CR>
vmap <leader>rem :action ExtractMethod<CR>
nmap <leader>rm :action Move<CR>
nmap <leader>ro :action OptimizeImports<CR>
nmap <leader>rG :action Generate<CR>

""" Mappings --------------------------------
""" From https://github.com/danidiaz/miscellany/blob/master/windows/.ideavimrc

map <C-o> <Action>(Back)
map <C-i> <Action>(Forward)
map g; <Action>(JumpToLastChange)
map g, <Action>(JumpToNextChange)

map <Space> <Action>(GotoNextError)

map <Leader>w <Action>(JumpToLastWindow)
map <Leader>gD <Action>(FindUsages)

""" Mappings --------------------------------
""" From example
map <leader>b <Action>(ToggleLineBreakpoint)

map <Leader>c <Action>(ChooseRunConfiguration)

map <leader>d <Action>(Debug)

map <leader>f <Action>(SelectInProjectView)

map <leader>ga <Action>(Annotate)
map <leader>gl <Action>(Vcs.ShowTabbedFileHistory)

map <leader>o <Action>(FileStructurePopup)

map <leader>z <Action>(ToggleDistractionFreeMode)
    '';
    # NOTE: change profile with echo 'vanilla' > .emacs-profile
    ".emacs-profiles.el".text = ''
      (("doom" . ((user-emacs-directory . "~/git/doom-emacs")))
        ("vanilla" . ((user-emacs-directory . "~/git/vanilla-emacs"))))
    '';
  };
  xdg = {
    enable = true;
    # configHome = "${homeDir}/.config";
    # dataHome   = "${homeDir}/.local/share";
    # cacheHome  = "${homeDir}/.cache";
    configFile = {
      nixpkgs = {
        source = ./../..;
        recursive = true;
      };
      direnv = {
        source = ./direnv;
        recursive = true;
      };
      kitty = {
        source = ./kitty;
        recursive = true;
      };
      # ".config/kitty/macos-launch-services-cmdline".text = "--listen-on unix:/tmp/mykitty";
      # "gnupg/gpg-agent.conf".text = ''
      #   enable-ssh-support
      #   default-cache-ttl 86400
      #   max-cache-ttl 86400
      #   pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
      # '';
    };
  };

  # file.".emacs.d" = {
  #   source = "$HOME/.emacs.d";
  #   recursive = true;
  # };
}
