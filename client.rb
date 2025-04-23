require 'drb/drb'

# 接続先の URI
SERVER_URI="druby://localhost:8787"

# DRbサーバを起動する
# この例には必要ないが、front オブジェクト以外の
# リモートオブジェクトのメソッドを呼び出す時には必要
DRb.start_service
# リモートオブジェクトの取得
timeserver = DRbObject.new_with_uri(SERVER_URI)
# リモートメソッドの呼び出し
puts timeserver.get_current_time

