with team_seasons AS (
  
  select 
  year,
  team, 
  wins + losses as games_played, 
  wins, 
  losses, 
  round(1.0 * wins / (wins + losses), 3) as win_pct,
  points, points_opp, 
  points - points_opp as point_differential
  from nfl
  where year is 2020
  
),

expected_wins as (
  SELECT distinct
  round(1.0*(points*points)/((points*points)+(points_opp*points_opp)), 3) as expected_win_pct,
  team
  from nfl
  where year is 2020

)

select 
team_seasons.year, 
team_meta.team, 
team_seasons.wins, 
team_seasons.losses, 
team_seasons.points,
team_seasons.points_opp,
team_seasons.win_pct,
expected_wins.expected_win_pct, 
	CASE
    	when win_pct >= expected_win_pct * 1.05 then 'OVERPERFORMED' 
      when win_pct <= expected_win_pct * 0.95 then 'UNDERPERFORMED' 
      else 'ABOUT AS EXPECTED'
    End as performance,
team_meta.conference, 
team_meta.division
from team_seasons
right outer join team_meta on team_meta.team = team_seasons.team
right outer join expected_wins on expected_wins.team = team_seasons.team
where year is 2020
group by team_meta.team
order by conference, division
;

