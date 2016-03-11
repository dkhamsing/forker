# forker

Fork GitHub repos on a page

![](http://i.giphy.com/n1JN4fSrXovJe.gif)

## Installation

```shell
$ git clone https://github.com/dkhamsing/forker.git
$ cd forker/
$ rake install
```

## Usage

```
forker <url> [w=item1^item2..] [u=user] [p=password]
  url   web page
  w     items to skip
  u     github user name
  p     github password
```

## Example

```shell
$ forker https://raw.githubusercontent.com/dkhamsing/open-source-ios-apps/master/README.md w=vsouz^matteo^open-sou^mac-apps^awesome-osx u=dkhamsing p=r0x0r88:-)
getting content
getting links
getting repos
repos found: 241
filtering white list ["vsouz", "matteo", "open-sou", "mac-apps"]
 white listed jeffreyjackson/mac-apps
 white listed pcqpcq/open-source-android-apps
 white listed vsouza/awesome-ios
 white listed matteocrippa/awesome-swift
repos filtered: 237
 artsy/Emergence
 azzoor/WWDCTV
#...
Proceed (y/n)? y
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
