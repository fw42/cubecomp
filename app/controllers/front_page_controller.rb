class FrontPageController < ApplicationController
  before_filter :redirect_to_proper_domain_and_protocol

  def index
    competitions = competitions_for_domain
      .preload(:days)
      .sort_by{ |competition| competition.days.min_by(&:date).date }
      .reverse

    @past_competitions = competitions.select{ |competition| competition.days.max_by(&:date).date < Date.today }
    @future_competitions = competitions - @past_competitions
  end

  private

  def competitions_for_domain
    relation = Competition.where(published: true)

    if Competition.custom_domains.key?(request.host)
      relation = relation.where(custom_domain: request.host)
    end

    relation
  end

  def redirect_to_proper_domain_and_protocol
    proper_domain, proper_protocol = proper_domain_and_protocol
    return if proper_domain.nil?
    return if proper_domain == request.host && proper_protocol == request.protocol
    redirect_to "#{proper_protocol}#{proper_domain}#{request.fullpath}"
  end

  def proper_domain_and_protocol
    proper_domain = Cubecomp::Application.config.main_domain
    proper_protocol = Cubecomp::Application.config.main_domain_protocol || request.protocol

    custom_domains = Competition.custom_domains

    if custom_domains.key?(request.host)
      proper_domain = request.host
      proper_protocol = custom_domains[request.host] + "://"
    end

    [ proper_domain, proper_protocol ]
  end
end
