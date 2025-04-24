require 'js'
require 'wasm_drb'

factory = DRb::DRbObject.new_with_uri 'ws://127.0.0.1:9292'
DRb.start_service("ws://127.0.0.1:9292/callback")

remote = factory.get.await

hello = remote.hello.await
hello_el = JS.global[:document].getElementById('hello')
hello_el[:innerText] = hello

input_el = JS.global[:document].getElementById('comment-input')
send_button = JS.global[:document].getElementById('send-button')
comments_container = JS.global[:document].getElementById('comments-container')

send_button.addEventListener('click') do
  comment_text = input_el[:value].to_s
  random_top = rand(90)
  random_duration = [2, 5, 10, 15].sample
  if comment_text && comment_text != ''
    remote.send_comment(comment_text, random_top, random_duration)
    input_el[:value] = ''
  end
end

remote.add_callback do |text|
  comment_div = JS.global[:document].createElement('p')
  comment_div[:className] = 'floating-comment'
  comment_div[:innerText] = text[:message]
  comment_div[:style][:top] = "#{text[:top]}%"
  comment_div[:style][:animation] = "floatLeft #{text[:duration]}s linear forwards"
  comments_container.appendChild(comment_div)

  comment_div.addEventListener('animationend') do
    comments_container.removeChild(comment_div)
  end
end
