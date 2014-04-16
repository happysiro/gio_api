# GioApi
GIO APIを利用するためのGemです。

GIO APIについては下記を参照してください。

[API Reference](http://manual.iij.jp/gp/gpapi/index.html)

これを利用するには、API Keyの作成が必須です。

## Installation

Add this line to your application's Gemfile:

    gem 'gio_api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gio_api

## Usage
.gio\_access\_keyというファイルを作り、access\_keyを書いてください

    Dummy Accsess Key

.gio\_secret\_keyというファイルを作り、secret\_keyを書いてください

    Dummy Secret Key

そして、下記のようにして、呼び出してください。

    gio_hosting_api = Gio::HostingApi.new
    gio_hosting_api.read_access_key_file
    gio_hosting_api.read_secret_key_file

## CLI Usage
下記のような書式で呼び出せます。

    bin/gioapi.rb attach_fw_Lb --access-key-file-path=/root/.gio_access_key --secret-key-file-path=/root/.gio_secret_key --gp-service-code=gp13969370 --gc-service-code=gc14029400 --gl-service-code=gl14020094

attach\_fw\_lb以外の場合でも、[API Reference](http://manual.iij.jp/gp/gpapi/index.html)を参照し、必要なリクエストパラメータを「小文字ハイフンつなぎ」の形式に書き換えて、呼び出せば何とかなります。
