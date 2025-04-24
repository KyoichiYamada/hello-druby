require 'drb/drb'
require 'drb/websocket'

class CommentObject
  def initialize
    @value = 0
    @callbacks = []
  end

  def hello
    "Hello, dRuby!"
  end

  def add_callback(&callback)
    @callbacks << callback
  end

  def send_comment(comment_text, top, duration)
    @callbacks.each do |callback|
      callback.call({ message: comment_text, top: top, duration: duration })
    end
  end
end

class CommentFactory
  def self.get
    @obj ||= DRbObject.new(CommentObject.new)
  end
end

DRb::WebSocket::RackApp.config.use_rack = true
DRb.start_service("ws://127.0.0.1:9292", CommentFactory)

app = DRb::WebSocket::RackApp.new(Proc.new {|env|
  case env['REQUEST_PATH']
  when '/'
    html = File.read('./index.html')
    [200, { 'content-type' => 'text/html' }, [html] ]
  when '/dist/browser.script.iife.js'
    js = File.read('./dist/browser.script.iife.js')
    [200, { 'content-type' => 'text/javascript' }, [js] ]
  when '/dist/app.wasm'
    js = File.read('./dist/app.wasm')
    [200, { 'content-type' => 'application/wasm' }, [js] ]
  else
    [404, {}, []]
  end
})

Rackup::Server.start app:app, Port: 9292
