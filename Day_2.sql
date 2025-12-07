-- Division Rank

Select 
nfl_metrics.year,
nfl_metrics.team,
nfl_metrics.wins,
nfl_metrics.losses,
round(nfl_metrics.win_pct, 3) as win_pct,
team_meta.conference,
team_meta.division,
row_number() over (partition by conference, division order by win_pct desc, division) as division_rank
from nfl_metrics
inner join team_meta on team_meta.team = nfl_metrics.team
where year is 2022
group by nfl_metrics.team, conference, division
order by conference, division;

-- Conference Rank

Select 
nfl_metrics.year,
nfl_metrics.team,
nfl_metrics.wins,
nfl_metrics.losses,
round(nfl_metrics.win_pct, 3) as win_pct,
team_meta.conference,
team_meta.division,
row_number() over (partition by conference order by wins desc, points) as conference_rank
from nfl_metrics
inner join team_meta on team_meta.team = nfl_metrics.team
where year is 2022
group by nfl_metrics.team, conference
order by conference;

-- NFL Rank

select 
nfl_metrics.year, 
nfl_metrics.team, 
nfl_metrics.wins,
nfl_metrics.losses,
round(nfl_metrics.win_pct, 3) as win_pct,
team_meta.conference,
team_meta.division,
row_number() over (order by wins desc) as rank
from nfl_metrics
inner join team_meta on team_meta.team = nfl_metrics.team
where year is 2022;
