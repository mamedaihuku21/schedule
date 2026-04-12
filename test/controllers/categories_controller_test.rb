require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest

  test "未ログインで削除しようとするとリダイレクト" do
    delete category_url(categories(:alice_work))
    assert_redirected_to new_user_session_path
  end

  test "予定が紐づいていないカテゴリーは削除できる" do
    sign_in users(:alice)
    empty_cat = users(:alice).categories.create!(category_name: "空カテゴリー", color_code: "#aabbcc")
    assert_difference "Category.count", -1 do
      delete category_url(empty_cat)
    end
  end

  test "予定が紐づいているカテゴリーは削除できない" do
    sign_in users(:alice)
    assert_no_difference "Category.count" do
      delete category_url(categories(:alice_work))
    end
    assert_equal "予定が紐づいているカテゴリーは削除できません", flash[:alert]
  end

  test "他ユーザーのカテゴリーを削除しようとすると 404" do
    sign_in users(:alice)
    delete category_url(categories(:bob_work))
    assert_response :not_found
  end
end
