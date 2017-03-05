# Used to test #store_location & #redirect_back_or
class CommentsController < ApplicationController

  def index
    require_login!
    render plain: "All the comments"
  end

  def new
  end

  def create
    require_login!
    render plain: "Comment created"
  end

end
