require 'drb/drb'

# 通信を待ち受ける URI
SERVER_URI="druby://localhost:8787"

class TimeServer

  def get_current_time
    return Time.now
  end

end

# サーバ側でリクエストを受け付けるオブジェクト
FRONT_OBJECT=TimeServer.new

# サーバを起動する
DRb.start_service(SERVER_URI, FRONT_OBJECT, :safe_level => 1)
# DRb のスレッドが終了するのを待つ
DRb.thread.join
