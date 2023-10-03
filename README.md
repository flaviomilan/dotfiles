# dotfiles



## Installation

### Install sdkman

```shell
curl -s "https://get.sdkman.io" | bash
```

### Install asdf

```shell
git clone https://github.com/asdf-vm/asdf.git ~/.asdf
```

### Install auxiliary

MacOS
```shell
brew install exa ripgrep bat fd tokei grex
```

Arch Linux
```shell
sudo pacman -Syu exa ripgrep bat fd tokei grex
```

### Install programming languages

sdkman
```shell
sdk install java 21-amzn
sdk use java 21-amzn
sdk install maven 3.9.5
sdk use maven 3.9.5
sdk install groovy 4.0.15
sdk use groovy 4.0.15
```

asdf
```shell
asdf plugin add nodejs
asdf plugin add lua
asdf plugin add go
```

## Usage



## Contributing



## License

[MIT](https://choosealicense.com/licenses/mit/)