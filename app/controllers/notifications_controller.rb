class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    notifications = Notification
      .joins(:event)
      .where(events: { user_id: current_user.id })
      .where(notify_at: Time.current..)
      .where(notify_at: ..24.hours.from_now)
      .includes(:event)
      .map { |n| { id: n.id, title: n.event.title, notify_at: (n.notify_at.to_f * 1000).to_i } }
    render json: notifications
  end
end
