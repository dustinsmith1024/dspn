require 'dspn'

describe Dspn::Client do

	before(:all) do
		@api_key = '8hu4nra8956f8kymyq955j33' || ENV['espn_api_key']
		# These actually hit the api
		@dspn = Dspn::Client.new({api_key: @api_key})
	end

	before(:each) do
		sleep 1 # Timeout issues with actually hitting the service...
	end

	it "#teams first item should be the hawks" do
		teams = @dspn.teams('basketball', 'nba')
		teams.first.id.should eq(1)
		teams.first.name.should eq('Hawks')
	end

	it "#team_by_leagues first item should be the hawks", :run => false do
		teams = @dspn.teams_by_league('basketball', 'nba')
		teams.first.id.should eq(1)
		teams.first.name.should eq('Hawks')
	end

	it "#team_by_leagues first item should be the hawks", :run => true do
		teams = @dspn.leagues_by_sport('basketball', 'nba')
		teams.first.id.should eq(1)
		teams.first.name.should eq('Hawks')
	end

	it "#teams should return a list of Dspn::Team objects" do
		teams = @dspn.nba_teams # Example of using the helpers
		teams.should be_kind_of(Array)
		teams.each do |team|
			team.should be_instance_of(Dspn::Team)
		end
	end

	it "#team with id 1 should return team 1" do
		team = @dspn.team('basketball', 'nba', '1')
		team.id.should eq(1)
		team.name.should eq('Hawks')
		team.should be_instance_of(Dspn::Team)
	end

	it "#team_news with id 1 should return team 1s news" do
		news = @dspn.team_news('basketball', 'nba', '1')
		news.should be_instance_of(Array)
		news.each do |item|
			item.should be_instance_of(Dspn::NewsItem)
		end
	end

	it "#mens-college-basketball returns a list of teams" do
		teams = @dspn.teams('basketball', 'mens-college-basketball')
		teams.should be_kind_of(Array)
		teams.each do |team|
			team.should be_instance_of(Dspn::Team)
		end
	end

	it "#mens-college-basketball returns a list of teams" do
		teams = @dspn.teams('basketball', 'mens-college-basketball')
		sleep 1
		college_teams = @dspn.mens_college_basketball_teams()
		teams.should eq(college_teams)
	end

	it "#womens-college-basketball returns a list of teams" do
		teams = @dspn.womens_college_basketball_teams
		teams.should be_kind_of(Array)
		teams.each do |team|
			team.should be_instance_of(Dspn::Team)
		end
	end

	it "#nfl returns a list of teams" do
		teams = @dspn.nfl_teams
		teams.should be_kind_of(Array)
		teams.each do |team|
			team.should be_instance_of(Dspn::Team)
		end
	end

	it "#mlb_teams returns a list of teams" do
		teams = @dspn.mlb_teams
		teams.should be_kind_of(Array)
		teams.each do |team|
			team.should be_instance_of(Dspn::Team)
		end
	end

	it "#college_football_teams returns a list of teams" do
		teams = @dspn.college_football_teams
		teams.should be_kind_of(Array)
		teams.each do |team|
			team.should be_instance_of(Dspn::Team)
		end
	end

	it "#wnba returns a list of teams" do
		teams = @dspn.wnba_teams
		teams.should be_kind_of(Array)
		teams.each do |team|
			team.should be_instance_of(Dspn::Team)
		end
	end


end