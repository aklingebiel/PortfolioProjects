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

with division_season as (
  select 
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

select 
conference,
division,
round(avg(total_points_for), 2),
round(avg(total_points_against), 2),
round(avg(total_wins), 2),
round(avg(total_losses), 2),
era
from division_season
group by conference, division, era
order by conference, division, era;

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

select 
conference,
round(avg(total_points), 2) as avg_points_for,
round(avg(total_points_against), 2) as avg_points_against,
round(avg(total_wins), 2) as avg_wins,
round(avg(total_losses), 2) as avg_losses,
era
from conference_season
group by conference, era
order by era;
