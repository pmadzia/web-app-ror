class AdminController < ApplicationController
  before_action :load_selected_users, only: %i[block unblock delete_selected]
  def index
    load_users
  end

  def block
    count = @selected.update_all(status: User.statuses[:blocked])
    respond_with_list "#{helpers.pluralize(count, 'user')} blocked."
  end

  def unblock
    count = @selected.update_all(status: User.statuses[:active])
    respond_with_list "#{helpers.pluralize(count, 'user')} unblocked."
  end

  def delete_selected
    count = @selected.delete_all
    respond_with_list "#{helpers.pluralize(count, 'user')} deleted."
  end

  private

  def load_users
    @q = User.ransack(params[:q])
    @q.sorts = "last_seen_or_epoch desc" if @q.sorts.empty?
    @users = @q.result.order(:id)
  end

  def load_selected_users
    ids = Array(params[:user_ids])
    if ids.empty?
      redirect_to admin_path, alert: "Select at least one user."
    else
      @selected = User.where(id: ids)
    end
  end

  def respond_with_list(message)
    load_users
    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = message
        render turbo_stream: [
          turbo_stream.replace("flash", partial: "shared/flash"),
          turbo_stream.replace("users_list", partial: "admin/users_list",
                              locals: { q: @q, users: @users })
        ]
      end
      format.html { redirect_to admin_path, notice: message }
    end
  end
end
