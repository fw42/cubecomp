class FrontPageController < ApplicationController
  before_filter :redirect_to_main_domain

  def index
    competitions = Competition
      .where(published: true)
      .preload(:days)
      .sort_by{ |competition| competition.days.min_by(&:date).date }
      .reverse

    @past_competitions = competitions.select{ |competition| competition.days.max_by(&:date).date < Date.today }
    @future_competitions = competitions - @past_competitions
  end

  private

  def redirect_to_main_domain
    main_domain = Cubecomp::Application.config.main_domain
    main_domain_protocol = Cubecomp::Application.config.main_domain_protocol || request.protocol

    return if main_domain.blank?
    return if main_domain == request.host && main_domain_protocol == request.protocol
    redirect_to "#{main_domain_protocol}#{main_domain}#{request.fullpath}"
  end
end
