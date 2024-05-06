select *
from CovidDeaths$

select * 
from CovidVaccinations$



--Data we're using

select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths$
order by location, date

-- Total cases vs total deaths in Germany

select Location, Date, Total_Cases, Total_Deaths,
	round(((Total_deaths/Total_cases)*100), 2) as DeathPct
from CovidDeaths$
where total_deaths is not null and location = 'Germany'
order by location, date

-- Total cases vs Population in Germany

select Location, Date, Total_Cases, Population,
	round(((Total_Cases/Population)*100), 2) as CasePct
from CovidDeaths$
where total_cases is not null and location = 'Germany'
order by CasePct desc


-- Which countries have the highest infection rate

select Location, Population, max(Total_Cases) as MaxInfectionCount,
	round(((max(Total_Cases)/Population)*100), 2) as InfectionRate
from CovidDeaths$
where continent is null and population is not null and location <> 'World'
group by Location, population
order by InfectionRate desc

-- Continent infection rate

select Location, Population, max(Total_Cases) as ContinentInfectionCount,
	round(((max(Total_Cases)/Population)*100), 2) as InfectionRate
from CovidDeaths$
where continent is null and population is not null and location <> 'World'
group by Location, population
order by InfectionRate desc

-- Highest death count per country

select Continent, Location, Population, max(total_deaths) as TotalDeathCount,
	round(((max(total_deaths)/population)*100), 4) as DeathRate
from CovidDeaths$
where continent is not null and population is not null and total_deaths is not null and location <> 'World'
group by location, population, continent
order by continent desc, DeathRate desc

-- Death count per continent

select Location, Population,  max(total_deaths) as TotalDeathCount
from CovidDeaths$
where continent is null and population is not null and total_deaths is not null and location <> 'World'
group by location, population
order by TotalDeathCount desc

-- Death rate per continent

select Location, Population, max(total_deaths) as TotalDeaths,
	round(((max(total_deaths)/population)*100), 4) as ContinentDeathRate
from CovidDeaths$
where continent is null and population is not null and total_deaths is not null and location <> 'World'
group by location, population
order by ContinentDeathRate desc

-- New cases per day

select date, sum(new_cases) as DailyCases
from CovidDeaths$
where continent is not null
group by date
order by date desc

-- Daily death rate

select date, sum(new_cases) as DailyCases, sum(cast(new_deaths as int)) as DailyDeaths, 
	round((sum(cast(new_deaths as int))/sum(new_cases)*100), 2) as DailyDeathPct
from CovidDeaths$
where continent is not null
group by date
order by Date desc



--with PopvsVac (Continent, Location, Date, Population, New_Vaccinations, TotalVaccinated)
--as (
--select death.Continent, death.Location, death.Date, death.Population, vax.new_vaccinations as NewlyVaccinated,
--sum(cast(vax.new_vaccinations as int)) over (partition by death.location order by death.location, death.date) as TotalVaccinated
--from CovidDeaths$ as death
--join CovidVaccinations$ as vax on
--death.location = vax.location and
--death.date = vax.date
--where vax.new_vaccinations is not null and death.continent is not null
--)

--select *, round((TotalVaccinated/Population)*100, 4) as PctVaccinated
--from PopvsVac

-- How many people are vaccinated

select death.Continent, death.Location, death.Date, death.Population, vax.new_vaccinations as NewlyVaccinated,
sum(cast(vax.new_vaccinations as int)) over (partition by death.location order by death.location, death.date) as TotalVaccinated,
(TotalVaccinated/death.population)*100 as PctVaccinated
from CovidDeaths$ as death
join CovidVaccinations$ as vax on
death.location = vax.location and
death.date = vax.date
where vax.new_vaccinations is not null and death.continent is not null
order by death.continent, death.location, death.date 

drop table if exists #PctPopVac
create table #PctPopVac (
Continent varchar(50),
Location varchar(50),
Date datetime,
Population int,
NewVaccinations int,
TotalVaccinated int
)

--insert into #PctPopVac
--select death.Continent, death.Location, death.Date, death.Population, vax.new_vaccinations as NewlyVaccinated,
--	sum(cast(vax.new_vaccinations as int)) over (partition by death.location order by death.location, death.date) as TotalVaccinated
--from CovidDeaths$ as death
--join CovidVaccinations$ as vax on
--death.location = vax.location and
--death.date = vax.date
--where vax.new_vaccinations is not null and death.continent is not null

select death.Continent, death.Location, death.Date, death.Population, vax.new_vaccinations as NewlyVaccinated,
sum(cast(vax.new_vaccinations as int)) over (partition by death.location order by death.location, death.date) as TotalVaccinated,
round(((pct.TotalVaccinated/death.population)*100), 4) as PctVaccinated
from CovidDeaths$ as death
join CovidVaccinations$ as vax on
death.location = vax.location and
death.date = vax.date 
join #PctPopVac as pct on
pct.location = death.location and
pct.date = death.date
where vax.new_vaccinations is not null and death.continent is not null
order by death.continent, death.location, death.date 

-- View to store data

--create view PctPopVac as
--select death.Continent, death.Location, death.Date, death.Population, vax.new_vaccinations as NewlyVaccinated,
--sum(cast(vax.new_vaccinations as int)) over (partition by death.location order by death.location, death.date) as TotalVaccinated
--from CovidDeaths$ as death
--join CovidVaccinations$ as vax on
--death.location = vax.location and
--death.date = vax.date
--where vax.new_vaccinations is not null and death.continent is not null

select *, round(((TotalVaccinated/Population)*100), 4) as PctVaccinated
from PctPopVac
order by continent, location, date 
