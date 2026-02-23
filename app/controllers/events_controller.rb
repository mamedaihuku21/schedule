class EventsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
  end

  def show
  end

  def new
    @event = Event.new
    @categories = current_user.categories
  end

  def create
    if params[:new_category_name].present?
      category = current_user.categories.create!(
        category_name: params[:new_category_name],
        color_code:    params[:new_category_color].presence || "#4aa8d8"
      )
      @event = current_user.events.build(event_params.merge(category_id: category.id))
    else
      @event = current_user.events.build(event_params)
    end
    @event.temporary = false
    if @event.save
      redirect_to events_path, notice: "予定を追加しました"
    else
      @categories = current_user.categories
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def detail
  end

  private

  def event_params
    params.require(:event).permit(:title, :memo, :start_time, :end_time, :category_id)
  end
end
