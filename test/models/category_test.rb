require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  def valid_category
    Category.new(
      user:          users(:alice),
      category_name: "勉強",
      color_code:    "#aabbcc"
    )
  end

  # --- 正常系 ---

  test "有効なカテゴリーは保存できる" do
    assert valid_category.valid?
  end

  # --- category_name ---

  test "category_nameが空だと無効" do
    cat = valid_category
    cat.category_name = ""
    assert_not cat.valid?
    assert_includes cat.errors[:category_name], "can't be blank"
  end

  # --- color_code ---

  test "color_codeが空だと無効" do
    cat = valid_category
    cat.color_code = ""
    assert_not cat.valid?
    assert_includes cat.errors[:color_code], "can't be blank"
  end

  # --- 関連 ---

  test "userがなければ無効" do
    cat = valid_category
    cat.user = nil
    assert_not cat.valid?
  end

  test "予定が紐づいていないカテゴリーは削除できる" do
    cat = valid_category
    cat.save!
    assert_difference "Category.count", -1 do
      cat.destroy
    end
  end

  test "予定が紐づいているカテゴリーはeventも持つ" do
    cat = categories(:alice_work)
    assert cat.events.exists?
  end
end
