require "test_helper"

class EventTest < ActiveSupport::TestCase
  def valid_event
    Event.new(
      user:       users(:alice),
      category:   categories(:alice_work),
      title:      "テスト予定",
      start_time: Time.zone.parse("2026-04-14 10:00"),
      end_time:   Time.zone.parse("2026-04-14 11:00"),
      memo:       ""
    )
  end

  # --- 正常系 ---

  test "有効な予定は保存できる" do
    assert valid_event.valid?
  end

  test "memoは空でも有効" do
    event = valid_event
    event.memo = nil
    assert event.valid?
  end

  # --- title ---

  test "titleが空だと無効" do
    event = valid_event
    event.title = ""
    assert_not event.valid?
    assert_includes event.errors[:title], "can't be blank"
  end

  # --- start_time ---

  test "start_timeが空だと無効" do
    event = valid_event
    event.start_time = nil
    assert_not event.valid?
    assert_includes event.errors[:start_time], "can't be blank"
  end

  # --- end_time ---

  test "end_timeが空だと無効" do
    event = valid_event
    event.end_time = nil
    assert_not event.valid?
    assert_includes event.errors[:end_time], "can't be blank"
  end

  # --- 関連 ---

  test "userがなければ無効" do
    event = valid_event
    event.user = nil
    assert_not event.valid?
  end

  test "categoryがなければ無効" do
    event = valid_event
    event.category = nil
    assert_not event.valid?
  end

  test "通知を持てる" do
    event = events(:meeting)
    assert_not_nil event.notification
  end

  test "通知を持たない予定も有効" do
    event = events(:lunch)
    assert_nil event.notification
    assert event.valid?
  end
end
