# homies

Reproducible set of dotfiles and packages

---

``` shell
$ # install Nix
$ curl -L https://nixos.org/nix/install | sh
$ # install Home Manager
$ nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
$ nix-channel --update
$ nix-shell '<home-manager>' -A install
$ # pull this repo
$ nix-shell -p git --run 'git clone http://github.com/jopecko/homies'
$ # remove default config
$ rm -fr ~/.config/nixpkgs
$ # link in homies
$ ln -s homies ~/.config/nixpkgs
# do the needful
$ home-manager switch
```
