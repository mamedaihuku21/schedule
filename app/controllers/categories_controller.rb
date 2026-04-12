class CategoriesController < ApplicationController
  before_action :authenticate_user!

  def destroy
    category = current_user.categories.find(params[:id])
    if category.events.exists?
      redirect_back fallback_location: new_event_path, alert: "予定が紐づいているカテゴリーは削除できません"
    else
      category.destroy
      redirect_back fallback_location: new_event_path, notice: "カテゴリーを削除しました"
    end
  end
end
