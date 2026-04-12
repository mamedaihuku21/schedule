require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest

  # ============================================================
  # 未ログイン → ログインページにリダイレクト
  # ============================================================

  test "未ログインで new にアクセスするとリダイレクト" do
    get new_event_url
    assert_redirected_to new_user_session_path
  end

  test "未ログインで create するとリダイレクト" do
    post events_url, params: { event: { title: "x" } }
    assert_redirected_to new_user_session_path
  end

  test "未ログインで edit にアクセスするとリダイレクト" do
    get edit_event_url(events(:meeting))
    assert_redirected_to new_user_session_path
  end

  test "未ログインで update するとリダイレクト" do
    patch event_url(events(:meeting)), params: { event: { title: "x" } }
    assert_redirected_to new_user_session_path
  end

  test "未ログインで detail にアクセスするとリダイレクト" do
    get detail_event_url(events(:meeting))
    assert_redirected_to new_user_session_path
  end

  # ============================================================
  # index
  # ============================================================

  test "未ログインでもカレンダーは表示される" do
    get events_url
    assert_response :success
  end

  test "ログイン済みでカレンダーが表示される" do
    sign_in users(:alice)
    get events_url
    assert_response :success
  end

  # ============================================================
  # day
  # ============================================================

  test "day は未ログインでも表示される" do
    get day_events_url(date: "2026-04-13")
    assert_response :success
  end

  test "ログイン済みで day が表示される" do
    sign_in users(:alice)
    get day_events_url(date: "2026-04-13")
    assert_response :success
  end

  # ============================================================
  # new
  # ============================================================

  test "ログイン済みで new が表示される" do
    sign_in users(:alice)
    get new_event_url
    assert_response :success
  end

  test "date パラメータ付きで new を開くと日付ヘッダーが表示される" do
    sign_in users(:alice)
    get new_event_url(date: "2026-04-13")
    assert_response :success
    assert_match "2026年04月13日", response.body
  end

  # ============================================================
  # create
  # ============================================================

  test "正常な予定を作成するとカレンダーにリダイレクト" do
    sign_in users(:alice)
    assert_difference "Event.count", 1 do
      post events_url, params: {
        event: {
          title:       "新しい予定",
          start_time:  "2026-04-14T10:00",
          end_time:    "2026-04-14T11:00",
          category_id: categories(:alice_work).id
        }
      }
    end
    assert_redirected_to events_path
  end

  test "タイトルなしで作成すると new を再描画" do
    sign_in users(:alice)
    assert_no_difference "Event.count" do
      post events_url, params: {
        event: {
          title:       "",
          start_time:  "2026-04-14T10:00",
          end_time:    "2026-04-14T11:00",
          category_id: categories(:alice_work).id
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "通知ONで作成すると Notification が作られる" do
    sign_in users(:alice)
    assert_difference "Notification.count", 1 do
      post events_url, params: {
        notif_enabled:        "1",
        notif_minutes_before: "10",
        event: {
          title:       "通知あり予定",
          start_time:  "2026-04-14T10:00",
          end_time:    "2026-04-14T11:00",
          category_id: categories(:alice_work).id
        }
      }
    end
  end

  test "通知OFFで作成すると Notification は作られない" do
    sign_in users(:alice)
    assert_no_difference "Notification.count" do
      post events_url, params: {
        event: {
          title:       "通知なし予定",
          start_time:  "2026-04-14T10:00",
          end_time:    "2026-04-14T11:00",
          category_id: categories(:alice_work).id
        }
      }
    end
  end

  # ============================================================
  # edit
  # ============================================================

  test "自分の予定を edit できる" do
    sign_in users(:alice)
    get edit_event_url(events(:meeting))
    assert_response :success
  end

  test "他ユーザーの予定を edit しようとすると 404" do
    sign_in users(:alice)
    get edit_event_url(events(:bob_meeting))
    assert_response :not_found
  end

  # ============================================================
  # update
  # ============================================================

  test "正常な内容で update するとリダイレクト" do
    sign_in users(:alice)
    patch event_url(events(:meeting)), params: {
      event: { title: "更新後タイトル" }
    }
    assert_redirected_to detail_event_path(events(:meeting))
    assert_equal "更新後タイトル", events(:meeting).reload.title
  end

  test "タイトルなしで update すると edit を再描画" do
    sign_in users(:alice)
    patch event_url(events(:meeting)), params: {
      event: { title: "" }
    }
    assert_response :unprocessable_entity
  end

  test "他ユーザーの予定を update しようとすると 404" do
    sign_in users(:alice)
    patch event_url(events(:bob_meeting)), params: {
      event: { title: "改ざん" }
    }
    assert_response :not_found
  end

  # ============================================================
  # destroy
  # ============================================================

  test "自分の予定を削除できる" do
    sign_in users(:alice)
    assert_difference "Event.count", -1 do
      delete event_url(events(:lunch))
    end
    assert_redirected_to day_events_path(date: events(:lunch).start_time.to_date)
  end

  test "予定を削除すると紐づく通知も削除される" do
    sign_in users(:alice)
    assert_difference "Notification.count", -1 do
      delete event_url(events(:meeting))
    end
  end

  test "他ユーザーの予定を削除しようとすると 404" do
    sign_in users(:alice)
    delete event_url(events(:bob_meeting))
    assert_response :not_found
  end

  # ============================================================
  # detail
  # ============================================================

  test "自分の予定の detail が表示される" do
    sign_in users(:alice)
    get detail_event_url(events(:meeting))
    assert_response :success
  end

  test "他ユーザーの予定の detail にアクセスすると 404" do
    sign_in users(:alice)
    get detail_event_url(events(:bob_meeting))
    assert_response :not_found
  end
end
