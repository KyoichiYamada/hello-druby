require 'drb/drb'

class CommentServer
  def initialize
    @callbacks = []
  end

  def hello
    'Hello, dRuby!'
  end

  def add_callback(&block)
    @callbacks << block
  end

  def send_comment(text)
    @callbacks.each { |cb| cb.call(text) }
  end

  def get
    self
  end
end

DRb.start_service('druby://127.0.0.1:9292', CommentServer.new)
DRb.thread.join
