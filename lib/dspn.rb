# coding: UTF-8
require "httparty"

#  In application controller do something like this
#
#  def espn
#    Espn::Client.new({api_key: 'yours'})
#  end
#
# Then in your controller do something like
#
#  def show
#    @team = espn.team('nba', params[:id].to_s)
#    @news = espn.team_news(params[:id].to_s)
#    respond_to do |format|
#      format.html # show.html.erb
#      format.json { render json: @post }
#    end
#  end

module Dspn
  class Client
    include HTTParty
    base_uri 'api.espn.com/v1/'
    format :json

    def initialize(options={})
      @api_key = options[:api_key]
    end

    def append_key(path)
      path + "apikey=#{@api_key}"
    end

    def by_date(date)
      # add this to filter by a date
      "&dates=20130313"
    end

    def team_news(team_id)
      #http://api.espn.com/v1/sports/basketball/nba/teams/2/news?apikey=yours
      path = append_key("sports/basketball/nba/teams/#{team_id}/news?insider=no&")
      response = self.class.get(path, {})
      news = response['headlines']
      news.map {|item| NewsItem.create(item)}
    end

    def teams(league_slug)
      #http://api.espn.com/v1/sports/basketball/nba/teams?apikey=yours
      path = append_key("sports/basketball/#{league_slug}/teams?")
      response = self.class.get(path, {})
      teams = response['sports'][0]['leagues'][0]['teams']
      teams.map {|item| Team.create(item)}
    end

    def team(league_slug, team_id)
      #http://api.espn.com/v1/sports/basketball/nba/teams?apikey=yours
      path = append_key("sports/basketball/#{league_slug}/teams/#{team_id}?")
      response = self.class.get(path, {})
      team = response['sports'][0]['leagues'][0]['teams'][0]
      Team.create(team)
    end

    def images
      # Since they only send the smallest image we could hack in the big ones
      # by parsing the URI

      # Or we could have someone test out the images and download them to our server
      # Then serve the images straight of our netowrk....which might suck

      # Doing this in my client right now...need to move it in
    end
  end

  class NewsItem < Struct.new(:headline, :keywords, :lastModified, :audio, :premium, :mobileStory, :links, :type, :related, :id, :story, :title, :linkText, :byline, :source, :description, :images, :categories, :published, :video)

    def self.create(news_hash)

      self.new(news_hash['headline'],
               news_hash['keywords'],
               news_hash['lastModified'],
               news_hash['audio'],
               news_hash['premium'],
               news_hash['mobileStory'],
               news_hash['links'],
               news_hash['type'],
               news_hash['related'],
               news_hash['id'],
               news_hash['story'],
               news_hash['title'],
               news_hash['linkText'],
               news_hash['byline'],
               news_hash['source'],
               news_hash['description'],
               news_hash['images'],
               news_hash['categories'],
               news_hash['published'],
               news_hash['video'])
    end
  end

  class Team < Struct.new(:id, :location, :name, :abbreviation, :color, :links)

    def self.create(team_hash)

      self.new(team_hash['id'],
               team_hash['location'],
               team_hash['name'],
               team_hash['abbreviation'],
               team_hash['color'],
               team_hash['links'])
    end
  end

end
