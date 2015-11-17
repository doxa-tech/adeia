# Used to test #authorize!, #load_and_authorize & load_and_authorize!
class ArticlesController < ApplicationController
  load_and_authorize except: [:index, :show, :new]

  def index
    authorize_and_load_records!
  end

  def show
    load_and_authorize!
  end

  def new
    authorize!
    @article = Article.new
  end

  def edit
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
    @article = Article.find(params[:id])
    if @article.update(article_params)
      redirect_to @article, notice: 'Article was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    redirect_to articles_url, notice: 'Article was successfully destroyed.'
  end

  private

    def article_params
      params.require(:article).permit(:title, :content)
    end
end
