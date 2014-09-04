class Admin::NewsController < AdminController
  before_action :set_news, only: [:show, :edit, :update, :destroy]

  def index
    @news = current_competition.news.all
  end

  def new
    @competition = current_competition
    @news = current_competition.news.new
  end

  def edit
  end

  def create
    @competition = current_competition
    @news = current_competition.news.new(news_params)

    if @news.save
      redirect_to admin_news_path(@news), notice: 'News item was successfully created.'
    else
      render :new
    end
  end

  def update
    if @news.update(news_params)
      redirect_to admin_news_path(@news), notice: 'News item was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @news.destroy
    redirect_to admin_competition_news_index_url(current_competition), notice: 'News item was successfully destroyed.'
  end

  private

  def set_news
    @news = current_competition.news.find(params[:id])
  end

  def news_params
    params.require(:news).permit(:time, :locale, :text)
  end
end
