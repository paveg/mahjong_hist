class HomeController < ApplicationController
  before_action :user_signed_in?, :current_user, :user_session
  
  def index
  end
end
