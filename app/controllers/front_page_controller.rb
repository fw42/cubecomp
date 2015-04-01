class FrontPageController < ApplicationController
  def index
    competitions = Competition
      .where(published: true)
      .preload(:days)
      .sort_by{ |competition| competition.days.min_by(&:date).date }
      .reverse

    @past_competitions = competitions.select{ |competition| competition.days.max_by(&:date).date < Date.today }
    @future_competitions = competitions - @past_competitions
  end
end
