class Admin::NewsController < AdminController
  before_action :set_news, only: [:edit, :update, :destroy]

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
      redirect_to admin_competition_news_index_path(current_competition), notice: 'News item was successfully created.'
    else
      render :new
    end
  end

  def update
    if @news.update(news_params)
      redirect_to admin_competition_news_index_path(current_competition), notice: 'News item was successfully updated.'
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
    params.require(:news).permit(
      :locale_id,
      :text,
      :"time(1i)",
      :"time(2i)",
      :"time(3i)",
      :"time(4i)",
      :"time(5i)"
    )
  end
end
