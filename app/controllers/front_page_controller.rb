class FrontPageController < ApplicationController
  def index
    @competitions = Competition
      .where(published: true)
      .preload(:days)
      .sort_by{ |competition| competition.days.min_by(&:date) }
  end
end
