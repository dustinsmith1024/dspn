# coding: UTF-8
require "httparty"
require 'ostruct'

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

    def sport_news(sport='cities', league=nil)
      #http://api.espn.com/v1/sports/basketball/nba/news?apikey=yours
      if league
        path = "sports/#{sport}/#{league}/news"
      else
        path = "sports/#{sport}/news"
      end
      news = get(path)['headlines']
      puts news
      news.map {|item| item.to_ostruct_recursive }
    end

    def team_news(sport, league, team_id)
      #http://api.espn.com/v1/sports/basketball/nba/teams/2/news?apikey=yours
      path = "sports/#{sport}/#{league}/teams/#{team_id}/news"
      news = get(path)['headlines']
      news.map {|item| item.to_ostruct_recursive }
    end

    def all_team_sports
      [
        {sport: 'basketball', league: 'nba'},
        {sport: 'basketball', league: 'wnba'},
        {sport: 'basketball', league: 'mens-college-basketball'},
        {sport: 'basketball', league: 'womens-college-basketball'},
        {sport: 'baseball', league: 'mlb'},
        {sport: 'football', league: 'nfl'},
        {sport: 'football', league: 'college-football'},
        {sport: 'hockey', league: 'nhl'}
      ]
    end

    def non_team_sports
      [
        {sport: 'cities', league: nil},
        {sport: 'cities', league: 'boston'},
        {sport: 'cities', league: 'chicago'},
        {sport: 'cities', league: 'dallas'},
        {sport: 'cities', league: 'los-angeles'},
        {sport: 'cities', league: 'new-york'},
        {sport: 'espnw', league: nil},
        {sport: 'fantasy', league: nil},
        {sport: 'fantasy', league: 'baseball'},
        {sport: 'fantasy', league: 'basketball'},
        {sport: 'fantasy', league: 'football'},
        {sport: 'fantasy', league: 'hockey'},
        {sport: 'magazine', league: nil},
        {sport: 'action-sports', league: nil},
        {sport: 'action-sports', league: 'bmx'},
        {sport: 'action-sports', league: 'moto-x'},
        {sport: 'action-sports', league: 'skateboarding'},
        {sport: 'action-sports', league: 'skiing'},
        {sport: 'action-sports', league: 'snowboarding'},
        {sport: 'action-sports', league: 'snowmobiling'},
        {sport: 'action-sports', league: 'surfing'},
        {sport: 'action-sports', league: 'rally'},
        {sport: 'baseball', league: 'mlb'},
        {sport: 'basketball', league: 'mens-college-basketball'},
        {sport: 'basketball', league: 'womens-college-basketball'},
        {sport: 'basketball', league: 'nba'},
        {sport: 'basketball', league: 'wnba'},
        {sport: 'boxing', league: nil},
        {sport: 'football', league: 'college-football'},
        {sport: 'football', league: 'nfl'},
        {sport: 'golf', league: nil},
        {sport: 'hockey', league: 'nhl'},
        {sport: 'horse-racing', league: nil},
        {sport: 'mma', league: nil},
        {sport: 'olympics', league: nil},
        {sport: 'racing', league: nil},
        {sport: 'racing', league: 'nascar'},
        {sport: 'soccer', league: nil},
        {sport: 'tennis', league: nil}
        #/sports/soccer/:leagueName  Specific professional soccer league. Use a helper API call for a complete list of supported soccer leagues.       
      ]

    end

    def all_teams
      #http://api.espn.com/v1/sports/teams?apikey=yours
      # Return sports->leagues->teams
      path = "sports/teams"
      sports = get(path)
      sports.to_ostruct_recursive
    end

    def teams(sport, league)
      #http://api.espn.com/v1/sports/basketball/nba/teams?apikey=yours
      path = "sports/#{sport}/#{league}/teams"
      # Go get them all!  Can't figure out how to pass as an option
      self.class.default_params[:limit] = 0
      teams = get(path)['sports'][0]['leagues'][0]['teams']
      teams.map {|item| item.to_ostruct_recursive }
    end


    def athletes(sport, league)
      #http://api.espn.com/v1/sports/basketball/nba/athletes?apikey=yours
      path = "sports/#{sport}/#{league}/athletes"
      athletes = get(path)['sports'][0]['leagues'][0]['athletes']
      athletes.map {|item| item.to_ostruct_recursive }
    end

    def leagues_by_sport(sport, league)
      #http://api.espn.com/v1/sports/basketball/nba/teams?apikey=yours
      path = "sports/#{sport}/#{league}"
      leagues = get(path, {})
      leagues = leagues['sports'][0]['leagues'][0]['groups']
      leagues.map {|item| item.to_ostruct_recursive }
    end

    def teams_by_league(sport, league)
      #http://api.espn.com/v1/sports/basketball/nba/teams?apikey=yours
      path = "sports/#{sport}/#{league}/teams"
      teams = get(path, {groups: 1})
      pp teams
      teams = teams['sports'][0]['leagues'][0]['teams']
      teams.map {|item| item.to_ostruct_recursive }
    end

    def mens_college_basketball_teams
      teams('basketball', 'mens-college-basketball')
    end

    def womens_college_basketball_teams
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
      path = "sports/#{sport}/#{league}/teams/#{team_id}"
      team = get(path)['sports'][0]['leagues'][0]['teams'][0]
      team.to_ostruct_recursive
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

  # NOT USING THESE - CAN PROBABLY DELETE THEM BUT DONT WANT TO YET
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
                self.set_groups(team_hash['groups']))

      #if league.groups
        # Change sub groups (divisions) from hashes to Structs
      #  league.groups = self.set_groups(league.groups)
      #end
      #league
    end

    def self.set_groups(groups)
      if groups
        groups.map do |group|
          League.create(group)
        end
      end
    end

  end

  #class Athlete < OpenStruct.new()
  #  def self.create(athlete_hash)
  #    self.new(athlete_hash)
  #  end
  #end

end


class Hash
  # options:
  #   :exclude => [keys] - keys need to be symbols 
  def to_ostruct_recursive(options = {})
    convert_to_ostruct_recursive(self, options) 
  end
 
  def with_sym_keys
    self.inject({}) { |memo, (k,v)| memo[k.to_sym] = v; memo }
  end

  private
    def convert_to_ostruct_recursive(obj, options)
      result = obj
      if result.is_a? Hash
        #puts result
        result = result.dup.with_sym_keys
        result.each  do |key, val| 
          puts key
          puts val
          result[key] = convert_to_ostruct_recursive(val, options) unless options[:exclude].try(:include?, key)
        end
        result = OpenStruct.new result       
      elsif result.is_a? Array
         result = result.map { |r| convert_to_ostruct_recursive(r, options) }
      end
      return result
    end
end