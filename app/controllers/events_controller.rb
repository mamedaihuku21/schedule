class EventsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :detail]

  def index
    @year  = (params[:year]  || Date.today.year).to_i
    @month = (params[:month] || Date.today.month).to_i
    @first_day = Date.new(@year, @month, 1)

    if user_signed_in?
      events = current_user.events
                           .includes(:category)
                           .where(start_time: @first_day.beginning_of_month..@first_day.end_of_month)
      @events_by_date = events.group_by { |e| e.start_time.to_date }
    else
      @events_by_date = {}
    end
  end

  def show
  end

  def day
    @date = Date.parse(params[:date])
    if user_signed_in?
      @events = current_user.events
                            .includes(:category)
                            .where(start_time: @date.beginning_of_day..@date.end_of_day)
                            .order(:start_time)
      @chart_events = @events
    else
      @events = []
      @chart_events = []
    end
  end

  def new
    @event = Event.new
    @categories = current_user.categories
    @date_specified = params[:date].present?
    @chart_date = @date_specified ? Date.parse(params[:date]) : Date.today
    @chart_events = current_user.events
                                .includes(:category)
                                .where(start_time: @chart_date.beginning_of_day..@chart_date.end_of_day)
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
    if @event.save
      redirect_to events_path, notice: "予定を追加しました"
    else
      @categories = current_user.categories
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @event = current_user.events.find(params[:id])
    @categories = current_user.categories
    chart_date = @event.start_time.to_date
    @chart_events = current_user.events
                                .includes(:category)
                                .where(start_time: chart_date.beginning_of_day..chart_date.end_of_day)
  end

  def update
    @event = current_user.events.find(params[:id])
    if params[:new_category_name].present?
      category = current_user.categories.create!(
        category_name: params[:new_category_name],
        color_code:    params[:new_category_color].presence || "#4aa8d8"
      )
      result = @event.update(event_params.merge(category_id: category.id))
    else
      result = @event.update(event_params)
    end
    if result
      redirect_to detail_event_path(@event), notice: "予定を更新しました"
    else
      @categories = current_user.categories
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event = current_user.events.find(params[:id])
    date = @event.start_time.to_date
    @event.destroy
    redirect_to day_events_path(date: date), notice: "予定を削除しました"
  end

  def detail
    @event = current_user.events.includes(:category).find(params[:id])
    chart_date = @event.start_time.to_date
    @chart_events = current_user.events
                                .includes(:category)
                                .where(start_time: chart_date.beginning_of_day..chart_date.end_of_day)
  end

  private

  def event_params
    params.require(:event).permit(:title, :memo, :start_time, :end_time, :category_id)
  end
end
