select sum(cast(new_cases as int)) as totalCases,sum(CAST(new_deaths as int)) as totalDeaths, 
sum(CAST(new_deaths as int))*100/sum(CAST(new_cases as int)) as deathPercentage
from PortfolioProject..CovidDeaths$
where continent is null
order by 1,2

select location,sum(CAST(new_deaths as int)) as totalDeaths
from PortfolioProject..CovidDeaths$
where continent is null 
group by location
order by 1,2



select location,sum(CAST(new_deaths as int)) as totalDeaths
from PortfolioProject..CovidDeaths$
where continent is null 
and location not in ( 'European Union', 'international','World')
group by location
order by 1,2


select location, population, MAX(total_cases) as highest, MAX(total_cases/population)*100 as percentPopulationInfected
from PortfolioProject..CovidDeaths$
where continent is not null
group by location,population
order by 3 desc

select location, population,date, MAX(total_cases) as highest, MAX(total_cases/population)*100 as percentPopulationInfected
from PortfolioProject..CovidDeaths$
where continent is not null
group by location,population,date
order by percentPopulationInfected desc