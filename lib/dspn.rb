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
      key = options[:api_key] || ENV['espn_api_key']
      raise StandardError, "You must specify an API key." if key.nil?
      self.class.default_params :apikey => key, :insider => 'no'
    end

    def team_news(sport, league, team_id)
      #http://api.espn.com/v1/sports/basketball/nba/teams/2/news?apikey=yours
      path = "sports/#{sport}/#{league}/teams/#{team_id}/news"
      news = get(path)['headlines']
      news.map {|item| NewsItem.create(item)}
    end

    def teams(sport, league)
      #http://api.espn.com/v1/sports/basketball/nba/teams?apikey=yours
      path = "sports/#{sport}/#{league}/teams"
      teams = get(path)['sports'][0]['leagues'][0]['teams']
      teams.map {|item| Team.create(item)}
    end

    def leagues_by_sport(sport, league)
      #http://api.espn.com/v1/sports/basketball/nba/teams?apikey=yours
      path = "sports/#{sport}/#{league}"
      leagues = get(path, {})
      pp leagues
      leagues = leagues['sports'][0]['leagues'][0]['groups']
      pp leagues
      #leagues = leagues.each {|item| if item['groups'] map_leaguesLeague.create(item)}
    end

    def map_league(league)
      leagues.map {|item| League.create(item)}
    end

    def teams_by_league(sport, league)
      #http://api.espn.com/v1/sports/basketball/nba/teams?apikey=yours
      path = "sports/#{sport}/#{league}/teams"
      teams = get(path, {groups: 1})
      pp teams
      teams = teams['sports'][0]['leagues'][0]['teams']
      teams.map {|item| Team.create(item)}
    end

    def mens_college_basketball_teams
      # Example we could do this...
      teams('basketball', 'mens-college-basketball')
    end

    def womens_college_basketball_teams
      # Example we could do this...
      teams('basketball', 'womens-college-basketball')
    end

    def nba_teams
      teams('basketball', 'nba')
    end

    def wnba_teams
      teams('basketball', 'wnba')
    end

    def nhl_teams
      teams('hockey', 'nhl')
    end

    def mlb_teams
      teams('baseball', 'mlb')
    end

    def nfl_teams
      teams('football', 'nfl')
    end

    def college_football_teams
      teams('football', 'nfl')
    end

    def team(sport, league, team_id)
      #http://api.espn.com/v1/sports/basketball/nba/teams?apikey=yours
      path = "sports/basketball/#{league}/teams/#{team_id}"
      team = get(path)['sports'][0]['leagues'][0]['teams'][0]
      Team.create(team)
    end

    def get(path, options={})
      response = self.class.get(path, options)
      response
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


  class League < Struct.new(:group_id, :name, :abbreviation, :shortName, :groups)
        #{"name"=>"Eastern",
        #  "abbreviation"=>"e",
        #  "groupId"=>5,
        #  "shortName"=>"E",
    def self.create(team_hash)

      self.new(team_hash['group_id'],
               team_hash['name'],
               team_hash['abbreviation'],
               team_hash['shortName'],
               team_hash['groups'])
    end


  end

end
