-- Update team names

select team
from nfl
where team like 'wash%' or team like 'Las%' or team like 'Los%' 
order by team; 

update nfl
set team = 'Washington Commanders'
where team in ('Washington Commanders', 'Washington Redskins', 'Washington Football Team');

update nfl
set team = 'Los Angeles Rams'
where team in ('St. Louis Rams');

update nfl
set team = 'Los Angeles Chargers'
where team like (' Los Angeles Chargers');

update nfl
set team = 'Las Vegas Raiders'
where team in ('Oakland Raiders')

-- Create CTE for division totals
	
with division_season as (
  select 
  team_meta.team,
  team_meta.conference,
  team_meta.division,
  	CASE
		when year >= 2003 and year <= 2009 then '2000s'
   		when year >= 2010 and year <= 2019 then '2010s'
    	when year >= 2020 and year <= 2029 then '2020s'
    else 'UNKNOWN'
  	end as era,
  nfl_metrics.year,
  sum(nfl_metrics.points) as total_points_for,
  sum(nfl_metrics.points_opp) as total_points_against,
  sum(nfl_metrics.wins) as total_wins,
  sum(nfl_metrics.losses) as total_losses
  from nfl_metrics
  left outer join team_meta on team_meta.team = nfl_metrics.team
  group by team_meta.conference, team_meta.division, era, year
)

-- Create query to find division averages
	
select 
conference,
division,
sum(total_points_for) as total_points_for_era,
sum(total_points_against) as total_points_against_era,
round(avg(total_points_for), 2) as avg_points_for,
round(avg(total_points_against), 2) as avg_points_against,
round(avg(total_wins), 2) as avg_wins_division_year,
round(avg(total_losses), 2) as avg_losses_division_year,
round(avg(total_wins) / 4, 2) as avg_wins_team_year,
round(avg(total_losses) / 4, 2) as avg_losses_team_year,
era
from division_season
group by conference, division, era
order by conference, division, era;

-- Create CTE for conference totals

with conference_season as (
  select 
  team_meta.conference,
  	CASE
		when year >= 2003 and year <= 2009 then '2000s'
   		when year >= 2010 and year <= 2019 then '2010s'
    	when year >= 2020 and year <= 2029 then '2020s'
    else 'UNKNOWN'
  	end as era,
  nfl_metrics.year,
  sum(nfl_metrics.wins) as total_wins,
  sum(nfl_metrics.losses) as total_losses,
  sum(nfl_metrics.points) as total_points,
  sum(nfl_metrics.points_opp) as total_points_against
  from nfl_metrics
  left OUTER join team_meta on team_meta.team = nfl_metrics.team
  group by conference, era, year
)

-- Create query to find conference averages
	
select 
conference,
round(avg(total_points), 2) as avg_points_for_year,
round(avg(total_points_against), 2) as avg_points_against_year,
round(avg(total_wins), 2) as avg_wins_year,
round(avg(total_losses), 2) as avg_losses_year,
era
from conference_season
group by conference, era
order by era;
