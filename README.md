[![Build Status](https://travis-ci.org/alexcurylo/chatalyzer.svg?branch=master)](https://travis-ci.org/alexcurylo/chatalyzer)
[![Issues](https://img.shields.io/github/issues/alexcurylo/chatalyzer.svg?style=flat
           )](https://github.com/alexcurylo/chatalyzer/issues)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat)](https://developer.apple.com/swift)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](http://mit-license.org)

[Chatalyzer](https://github.com/alexcurylo/chatalyzer)
===========

Chat message string content analyzer.

## Table of Contents

1. [Purpose](#purpose)
2. [Requirements](#requirements)
3. [Usage](#usage)
4. [Author](#author)
5. [License](#license)
6. [Change Log](#change-log)

## Purpose

To display in the form of a JSON string the contents found in a typed chat message string, of the three types

 - __mentions:__ prefixed with '@' and extend to next non-word character.
 - __emoticons:__ at most 15 parenthesized alphanumeric characters.
 - __links:__ as found by [`NSDataDetector`](https://developer.apple.com/library/ios/documentation/Foundation/Reference/NSDataDetector_Class/) along with their title

## Requirements

- Xcode 7.3 or later
- iOS 9.0 or later

## Usage

Run and type (or paste) in your chat string
 
[usage1](images/usage1.jpeg)
 
and it will be parsed as per these samples:
 
> @chris you around?

[usage2](images/usage2.jpeg)
 
> Good morning! (megusta) (coffee)
 
[usage3](images/usage3.jpeg)

> Olympics are starting soon;http://www.nbcolympics.com

[usage4](images/usage4.jpeg)

> @bob @john (success) such a cool feature; https://twitter.com/jdorfman/status/430511497475670016
 
[usage5](images/usage5.jpeg)

## Author

[![web: trollwerks.com](http://img.shields.io/badge/web-www.trollwerks.com-green.svg?style=flat)](http://trollwerks.com) 
[![twitter: @trollwerks](http://img.shields.io/badge/twitter-%40trollwerks-blue.svg?style=flat)](https://twitter.com/trollwerks) 
[![email: alex@trollwerks.com](http://img.shields.io/badge/email-alex%40trollwerks.com-orange.svg?style=flat)](mailto:alex@trollwerks.com) 

## License

The [MIT License](http://opensource.org/licenses/MIT). See the [LICENSE](LICENSE) file for details.
 
## Change Log
 
 * **Version 1.0**: *(2016.04.29)* - Initial Release

