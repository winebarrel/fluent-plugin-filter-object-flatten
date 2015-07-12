# fluent-plugin-filter-object-flatten

Filter Plugin to convert the hash record to records of key-value pairs.

see [ObjectFlatten](https://github.com/winebarrel/object_flatten) gem.

[![Gem Version](https://badge.fury.io/rb/fluent-plugin-filter-object-flatten.svg)](http://badge.fury.io/rb/fluent-plugin-filter-object-flatten)
[![Build Status](https://travis-ci.org/winebarrel/fluent-plugin-filter-object-flatten.svg?branch=master)](https://travis-ci.org/winebarrel/fluent-plugin-filter-object-flatten)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fluent-plugin-filter-object-flatten'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install object_flatten


```apache
<filter>
  type fluent-plugin-filter-object-flatten
  #separator .
</filter>
```

## Usage

```sh
$ cat fluent.conf
<source>
  @type forward
  @id forward_input
</source>

<filter>
  type object_flatten
</filter>

<match **>
  @type stdout
  @id stdout_output
</match>

$ fluentd -c fluent.conf
```

```sh
$ echo '{"foo":"bar", "bar":"zoo"})' | fluentd test.object
#=> 2015-01-01 23:34:45 +0900 test.object: {"foo":"bar"}
#=> 2015-01-01 23:34:45 +0900 test.object: {"bar":"zoo"}

$ echo '{"foo":["bar", "zoo"]})' | fluentd test.object
#=> 2015-01-01 23:34:45 +0900 test.object: {"foo":"bar"}
#=> 2015-01-01 23:34:45 +0900 test.object: {"foo":"zoo"}

$ echo '{"foo":{"bar1":"zoo", "bar2":"baz"}})' | fluentd test.object
#=> 2015-01-01 23:34:45 +0900 test.object: {"foo.bar1":"zoo"}
#=> 2015-01-01 23:34:45 +0900 test.object: {"foo.bar2":"baz"}

$ echo '{"foo1":{"bar1":"zoo", "bar2":"baz"}, "foo2":{"bar":["zoo", "baz"], "zoo":"baz"}}' | fluentd test.object
#=> 2015-01-01 23:34:45 +0900 test.object: {"foo1.bar1":"zoo"}
#=> 2015-01-01 23:34:45 +0900 test.object: {"foo1.bar2":"baz"}
#=> 2015-01-01 23:34:45 +0900 test.object: {"foo2.bar":"zoo"}
#=> 2015-01-01 23:34:45 +0900 test.object: {"foo2.bar":"baz"}
#=> 2015-01-01 23:34:45 +0900 test.object: {"foo2.zoo":"baz"}
```
