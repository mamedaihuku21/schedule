require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  def valid_notification
    Notification.new(
      event:     events(:lunch),
      notify_at: Time.zone.parse("2026-04-13 11:55")
    )
  end

  # --- 正常系 ---

  test "有効な通知は保存できる" do
    assert valid_notification.valid?
  end

  # --- 関連 ---

  test "eventがなければ無効" do
    notif = valid_notification
    notif.event = nil
    assert_not notif.valid?
  end

  test "予定に紐づく通知を取得できる" do
    notif = notifications(:meeting_notif)
    assert_equal events(:meeting), notif.event
  end

  test "予定を削除すると通知も削除される" do
    event = events(:meeting)
    assert_difference "Notification.count", -1 do
      event.destroy
    end
  end
end
