# DSPN

A Ruby wrapper for the ESPN API.  Currently it's only supporting the NBA APIs.  I will remove this before its uploaded to Rubygems.

## Dependencies

Currently depends on httparty.

## Use

In IRB:

```
irb(main):007:0> dspn = Dspn::Client.new({api_key: 'your_api_key'})
irb(main):007:0> t = dspn.teams('nba')
irb(main):008:0> t.first.name
=> "Hawks"
```

## In a Rails app:

In application controller do something like this

  def espn
    Espn::Client.new({api_key: 'yours'})
  end

 Then in your controller do something like

  def show
    @team = espn.team('nba', params[:id].to_s)
    @news = espn.team_news(params[:id].to_s)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

# Teams

Returns the teams according to the league slug you send in. 

Can pass in 'nba' or 'mens-college-basketball' right now.



