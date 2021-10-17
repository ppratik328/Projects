select *
from PortfolioProject..CovidDeaths$
Order by 3,4

select *
from PortfolioProject..CovidDeaths$
where continent is not null
Order by 3,4


--select *
--from PortfolioProject..CovidVaccinations$
--Order by 3,4

Select Location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths$
Order by 1,2

-- Death percentage
-- likelihood of dying in a country

Select Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathPercentage
from PortfolioProject..CovidDeaths$
where location like '%india%'
Order by 1,2

Select Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathPercentage
from PortfolioProject..CovidDeaths$
where location like '%states%'
Order by 1,2

-- population covid percentage

Select Location,date,total_cases,population,(total_cases/population)*100 as covidPercentage
from PortfolioProject..CovidDeaths$
where location like '%states%'
Order by 1,2

Select Location,date,total_cases,population,(total_cases/population)*100 as covidPercentage
from PortfolioProject..CovidDeaths$
where location like '%india%'
Order by 1,2


--highest population infection by countries

Select Location,MAX(total_cases) as HighestInfection,population,MAX((total_cases/population)*100 )as covidPercentage
from PortfolioProject..CovidDeaths$
where continent is not null
group by Location,population
Order by covidPercentage desc

-- covid deathRate per population

Select Location,MAX(total_deaths) as HighestInfectionDeaths,population,MAX((total_deaths/population)*100 )as covidDeathsPercentage
from PortfolioProject..CovidDeaths$
where continent is not null
group by Location,population
Order by covidDeathsPercentage desc

--continents

Select continent,MAX(total_deaths) as HighestInfectionDeaths
from PortfolioProject..CovidDeaths$
where continent is not null
group by continent
Order by HighestInfectionDeaths desc


select date , sum(new_cases) as totalCases,sum(cast(new_deaths as int)) as totalDeaths,sum(cast(new_deaths as int))/sum(new_cases) *100 as deathRate
from PortfolioProject..CovidDeaths$
where continent is not null
group by date
order by 1,2

--join

select * 
from PortfolioProject..CovidDeaths$ as dts
join PortfolioProject..CovidVaccinations$ as vac
On dts.location=vac.location and dts.date=vac.date 


--vaccinated population

select dts.continent,dts.location,dts.date, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as bigint)) over (partition by dts.location 
								         order by dts.location,dts.date) as TotalVaccinatedCumilitative
from PortfolioProject..CovidDeaths$ as dts
join PortfolioProject..CovidVaccinations$ as vac
On dts.location=vac.location and dts.date=vac.date 
where dts.continent is not null
	  and vac.new_vaccinations is not null
order by 2,3


--use of CTE

with popVaccinated(continent,location,date,population,newVaccination,ToatalVaccinatedCumilitative)
as(
select dts.continent,dts.location,dts.date,dts.population ,vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as bigint)) over (partition by dts.location 
								         order by dts.location,dts.date) as TotalVaccinatedCumilitative
from PortfolioProject..CovidDeaths$ as dts
join PortfolioProject..CovidVaccinations$ as vac
On dts.location=vac.location and dts.date=vac.date 
where dts.continent is not null
	  and vac.new_vaccinations is not null
)
select*,ToatalVaccinatedCumilitative/population*100 as vaccPercentage
from popVaccinated


--view

CREATE VIEW PercentageVaccinated as
select dts.continent,dts.location,dts.date,dts.population ,vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as bigint)) over (partition by dts.location 
								         order by dts.location,dts.date) as TotalVaccinatedCumilitative
from PortfolioProject..CovidDeaths$ as dts
join PortfolioProject..CovidVaccinations$ as vac
On dts.location=vac.location and dts.date=vac.date 
where dts.continent is not null
	 

select *
from PercentageVaccinated

--