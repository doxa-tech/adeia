# Used to test #store_location & #redirect_back_or
class CommentsController < ApplicationController

  def index
    require_login!
    render text: "All the comments"
  end

  def new
  end

  def create
    require_login!
    render text: "Comment created"
  end

end
