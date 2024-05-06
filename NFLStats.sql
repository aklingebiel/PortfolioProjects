select *
from nfl


select Year, Team, Wins, Losses, g as GamesPlayed, round(((wins/g)*100), 3) as WinPct,
	pass_cmp, pass_att, pass_yds,	
		round(((pass_cmp/pass_att) * 100), 3) as PassCmpPct,
		round(((pass_cmp/pass_yds) * 100), 3) as PassYdsPerCmp
from nfl
where losses <> 0 and wins <> 0 and year like '202%'
order by team 

--which team is most successful in the 2020s

select Team, sum(Wins) as Wins, sum(Losses) as Losses, sum(g) as TotalGames,
	round(((sum(wins)/sum(g)) * 100), 3) as WinPct2020s
from NFL
where year like '202%'
group by team
order by WinPct2020s desc

-- update team names

alter table NFL 
add teamNameCorrected nvarchar(50)

update NFL
set teamNameCorrected = 
case 
when team like '%Washington%' then 'Washington Commanders'
when team like '%Chargers%' then 'Los Angeles Chargers'
when team like '%Rams%' then 'Los Angeles Rams'
when team like '%Raiders%' then 'Las Vegas Raiders'
end

update new
set teamNameCorrected = isnull(new.teamNameCorrected, old.team)
from NFL as old
join NFL as new on
old.team = new.team

update old
set team = new.teamNameCorrected
from NFL as old
join NFL as new on
old.team = new.team

alter table NFL
drop column teamNameCorrected

-- Create a view

create view NFLStats as
select *
from NFL

-- Using data from the view

select  Team, sum(fumbles_lost) as FUM, sum(pass_int) as INT, (sum(fumbles_lost)+sum(pass_int)) as Turnovers
from NFLStats
group by team
order by turnovers desc