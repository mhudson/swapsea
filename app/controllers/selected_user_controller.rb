# frozen_string_literal: true

class SelectedUserController < ApplicationController
  load_and_authorize_resource class: false
  layout 'dashboard'

  def index
    @referrer = request.referer

    @switch_users = if selected_user.has_role? :admin
                      User.all.joins(patrol_member: :patrol).includes(:patrol, :club).order(:last_name)
                    elsif (selected_user.has_role? :manager) && selected_user.club.present?
                      User.with_club(selected_user.club).joins(patrol_member: :patrol).includes(:patrol, :club).order(:last_name)
                    else
                      User.where(email: selected_user.email).joins(patrol_member: :patrol).includes(:patrol, :club).order(:last_name)
                    end
  end

  def set
    session[:selected_user_id] = if (params.key?(:uid) && User.exists?(params[:uid])) && ((selected_user.has_role? :admin) || (selected_user.has_role? :manager) || (selected_user.email == User.find(params[:uid]).email))
                                   params[:uid]
                                 else
                                   # cancel impersonate
                                   current_user.id
                                 end

    if params[:referrer].present?
      redirect_to params[:referrer]
    else
      redirect_to dashboard_path
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the allowlist through.
  def selected_user_params
    params.require(:selected_user).permit(:path, :uid)
  end
end
