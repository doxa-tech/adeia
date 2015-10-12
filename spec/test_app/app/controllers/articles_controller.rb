class ArticlesController < ApplicationController
  #before_action :set_article, only: [:show, :edit, :update, :destroy]
  #load_and_authorize

  def index
    @articles = Article.all
    #authorize!
  end

  def show
    #load_and_authorize!
  end

  def new
    #authorize!
    @article = Article.new
  end

  def edit
    #load_and_authorize!
  end

  def create
    @article = Article.new(article_params)
    @article.user = current_user
    if @article.save
      redirect_to @article, notice: 'Article was successfully created.'
    else
      render :new
    end
  end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: 'Article was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_url, notice: 'Article was successfully destroyed.'
  end

  private

    def set_article
      @article = Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :content)
    end
end
