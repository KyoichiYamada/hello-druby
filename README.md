# hello-druby

## Example
```ruby
ruby example/server.rb
# 別ウィンドウを開く
ruby example/client.rb
# -> 2025-04-23 22:07:36 +0900
```

## How to run

- Install rackup gem and bundle install

```
gem install rackup
bundle install
```

- Build ruby.wasm

```
bundle exec rbwasm build -o dist/ruby.wasm
```

- Pack source codes

```
bundle exec rbwasm pack dist/ruby.wasm --dir ./src::/src -o dist/app.wasm
```

- Run rack application

```
rackup
```

Open the following URL on a browser and see developer console. http://localhost:9292