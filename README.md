# forker

Fork GitHub repos on a page

![](http://i.giphy.com/n1JN4fSrXovJe.gif)

[![CircleCI](https://img.shields.io/circleci/project/dkhamsing/forker.svg)]()

## Installation

```shell
$ git clone https://github.com/dkhamsing/forker.git
$ cd forker/
$ rake install
```

## Usage

```
forker --config <config file>
```

## Example

YAML [config file](bin/config.yml):

```yml
username: ..
password: ..
url:
  - https://github.com/dkhamsing/open-source-ios-apps
skip:
  - mac-apps
  - awesome-osx
  - android-apps
  - awesome-ios
  - awesome-swift
```

```shell
$ forker --config config.yml
loading config: config.yml ...
getting content from https://github.com/dkhamsing/open-source-ios-apps
getting links
getting repos
#...
 artsy/Emergence
 azzoor/WWDCTV
#...
proceed (y/n)? y
#...
211/237 forking soffes/words
{:id=>46074803,
 :name=>"words",
 :full_name=>"opensourceios/words",
 :owner=>
  {:login=>"opensourceios",
   :id=>4372882,
   :avatar_url=>"https://avatars.githubusercontent.com/u/4372882?v=3",
   :gravatar_id=>"",
   :url=>"https://api.github.com/users/opensourceios",
# ...
212/237 forking artsy/Emergence
  fork opensourceios/Emergence already exists
# ...
```

`forker` is being used by [opensourceios](https://github.com/opensourceios) :octocat:

## Contact

- [github.com/dkhamsing](https://github.com/dkhamsing)
- [twitter.com/dkhamsing](https://twitter.com/dkhamsing)

## License

This project is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
