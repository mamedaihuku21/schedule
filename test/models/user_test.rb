require "test_helper"

class UserTest < ActiveSupport::TestCase
  def valid_user
    User.new(
      email:                 "test@example.com",
      password:              "password",
      password_confirmation: "password",
      user_name:             "テストユーザー"
    )
  end

  # --- 正常系 ---

  test "有効なユーザーは保存できる" do
    assert valid_user.valid?
  end

  # --- user_name ---

  test "user_nameが空だと無効" do
    user = valid_user
    user.user_name = ""
    assert_not user.valid?
    assert_includes user.errors[:user_name], "can't be blank"
  end

  # --- email ---

  test "emailが空だと無効" do
    user = valid_user
    user.email = ""
    assert_not user.valid?
  end

  test "emailの形式が不正だと無効" do
    user = valid_user
    user.email = "not-an-email"
    assert_not user.valid?
  end

  test "emailが重複していると無効" do
    user = valid_user
    user.email = users(:alice).email
    assert_not user.valid?
    assert_includes user.errors[:email], "has already been taken"
  end

  # --- password ---

  test "passwordが5文字以下だと無効" do
    user = valid_user
    user.password = "short"
    user.password_confirmation = "short"
    assert_not user.valid?
  end

  test "passwordが6文字以上なら有効" do
    user = valid_user
    user.password = "123456"
    user.password_confirmation = "123456"
    assert user.valid?
  end

  # --- 関連 ---

  test "ユーザー作成時にデフォルトカテゴリーが3件作られる" do
    user = valid_user
    user.save!
    assert_equal 3, user.categories.count
  end
end
