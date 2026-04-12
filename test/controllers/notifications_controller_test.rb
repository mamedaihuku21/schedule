require "test_helper"

class NotificationsControllerTest < ActionDispatch::IntegrationTest

  test "未ログインでアクセスするとリダイレクト" do
    get notifications_url
    assert_redirected_to new_user_session_path
  end

  test "ログイン済みで JSON が返る" do
    sign_in users(:alice)
    get notifications_url, as: :json
    assert_response :success
    json = JSON.parse(response.body)
    assert_kind_of Array, json
  end

  test "自分の通知だけが返る" do
    sign_in users(:alice)
    get notifications_url, as: :json
    json = JSON.parse(response.body)
    titles = json.map { |n| n["title"] }
    assert_includes titles, events(:meeting).title
    assert_not_includes titles, events(:bob_meeting).title
  end

  test "過去の通知は返らない" do
    sign_in users(:alice)
    # 過去時刻の通知を作る
    past_event = users(:alice).events.create!(
      category:   categories(:alice_work),
      title:      "過去の予定",
      start_time: 2.hours.ago,
      end_time:   1.hour.ago
    )
    past_event.create_notification(notify_at: 2.hours.ago)

    get notifications_url, as: :json
    json = JSON.parse(response.body)
    titles = json.map { |n| n["title"] }
    assert_not_includes titles, "過去の予定"
  end
end
