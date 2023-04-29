select *
from portfolioproject..CovidDeaths
order by 3,4
--select *
--from portfolioproject..CovidVaccinations
--order by 3,4

--data that we are going to be using
select Location, date,total_cases,new_cases,total_deaths,population
from CovidDeaths
order by 1,2
--looking at totalcases vs totaldeath
select Location, date,total_cases,total_deaths,(total_deaths/total_cases)*100
from CovidDeaths
where continent is not null
order by 1,2

--looking at totalcases vs population
select Location, date,population,(total_cases/population)*100
from CovidDeaths
--where location like '%Bolivia%' 
order by 1,2

--looking at countries with highest infection rate
select location,population,max(total_cases),max (total_cases/population)*100 highinfectionrate
from portfolioproject..CovidDeaths
group by Location, population
order by highinfectionrate desc


---lets do things by continent
--showing the continent with the highest deathcount per population

select continent,max(cast(total_deaths as int)) as total_deathcount
from portfolioproject..CovidDeaths
where continent is not null
group by continent
order by total_deathcount desc



--global numbers
select date,sum(new_cases)
from CovidDeaths
where continent is not null
group by date
order by 1,2

--death percentage
select sum(new_cases),sum(cast(new_deaths as int)),sum(cast(new_deaths as int))/sum(new_cases)*100 deathpercent
from portfolioproject..CovidDeaths
where continent is not null
--group by date
order by 1,2


--looking at total population vs vaccination

select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int ,vac.new_vaccinations))over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevac
from portfolioproject..CovidDeaths dea
join
portfolioproject..CovidVaccinations vac

on dea.Location = vac.Location
and dea.date = vac.date
WHERE dea.continent is not null
order by 2,3


--- use cte
with  popvsvac (continent,Location, date, population,new_vaccinations, rollingvac)
as(
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int ,vac.new_vaccinations))over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevac
from portfolioproject..CovidDeaths dea
join
portfolioproject..CovidVaccinations vac

on dea.Location = vac.Location
and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3
)
 select *, (rollingvac/population)*100
 from popvsvac

  

  --TEMP TABLE
  drop table if exists #percentpopvac
  create table #percentpopvac
  (
  continent nvarchar(255),
  location nvarchar(255),
  date datetime,
  population numeric,
  New_vaccinations numeric,
  rollingvac numeric)


  insert into #percentpopvac
  select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int ,vac.new_vaccinations))over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevac
from portfolioproject..CovidDeaths dea
join
portfolioproject..CovidVaccinations vac

on dea.Location = vac.Location
and dea.date = vac.date
WHERE dea.continent is not null
order by 2,3

select *, (rollingvac/population)*100
 from #percentpopvac

 --- creating view to store data for later visualization

 create view percentpopvaccc as
  select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int ,vac.new_vaccinations))over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevac
from portfolioproject..CovidDeaths dea
join
portfolioproject..CovidVaccinations vac
on dea.Location = vac.Location
and dea.date = vac.date
WHERE dea.continent is not null
-- order by 2,3

 create view 
 hdp
 as 
 select continent,max(cast(total_deaths as int)) as total_deathcount
from portfolioproject..CovidDeaths
where continent is not null
group by continent
--order by total_deathcount desc

create view 
toalcases_vs_totaldeath 
as
select Location, date,total_cases,total_deaths,(total_deaths/total_cases)*100 as tdvstc
from portfolioproject..CovidDeaths
where continent is not null

--order by 1,2

--sum of all new cases

create view 
totalnewcases 
as
select date,sum(new_cases) totalnewcases
from CovidDeaths
where continent is not null
group by date
--order by 1,2