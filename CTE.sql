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
  
)

select * 
from team_seasons
order by year, team
limit 96;

