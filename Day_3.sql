select
nfl_metrics.team,
round(avg(nfl_metrics.wins), 2) as avg_wins,
round(avg(nfl_metrics.losses), 2) as avg_losses,
round(avg(nfl_metrics.points), 2) as avg_points_for,
round(avg(nfl_metrics.points_opp), 2) as avg_points_against,
round(avg(nfl_metrics.points-nfl_metrics.points_opp), 2) as avg_point_diff,
team_meta.conference,
team_meta.division,
CASE
	when year >= 2003 and year <= 2009 then '2000s'
    when year >= 2010 and year <= 2019 then '2010s'
    when year >= 2020 and year <= 2029 then '2020s'
    else 'UNKNOWN'
end as era
from nfl_metrics
left outer join team_meta on team_meta.team = nfl_metrics.team
group by nfl_metrics.team, conference, division, era
order by conference, division;

select 
round(avg(nfl_metrics.points), 2) as avg_points_for,
round(avg(nfl_metrics.points_opp), 2) as avg_points_against,
round(avg(nfl_metrics.points-nfl_metrics.points_opp), 2) as avg_point_diff, 
round(avg(nfl_metrics.wins), 2) as avg_wins,
team_meta.conference,
CASE
	when year >= 2003 and year <= 2009 then '2000s'
    when year >= 2010 and year <= 2019 then '2010s'
    when year >= 2020 and year <= 2029 then '2020s'
    else 'UNKNOWN'
end as era
from nfl_metrics
left outer join team_meta on team_meta.team = nfl_metrics.team
group by team_meta.conference, era
order by era, avg_wins desc;
