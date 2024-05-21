
--Data consists of the deaths in covid globally

SELECT *
FROM CovidDataAnalysis..CovidDeaths
where continent is not null
ORDER BY 3,4

--Data consists of the vaccinations globally 

--SELECT * 
--FROM CovidDataAnalysis..CovidVaccinations
--ORDER BY 3,4

--What percentage of people died in Pakistan
--SELECT Location, date, population, total_cases, total_deaths, (CAST(total_deaths as numeric)/CAST(total_cases as numeric))*100 as PercentPopulationInfected
--  FROM CovidDataAnalysis..CovidDeaths
--where location like '%Pakis%'
--order by 1,2


-- Lookming at countries with the Higest Infection rate compared to population

Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX ((CAST(total_cases as float)/Population ))*100 as PercentPopulationInfected
From CovidDataAnalysis..CovidDeaths
Group by location, population
Order by PercentPopulationInfected desc


--Showing the countries with the highest death count per population
 Select Location, MAX(Total_deaths) as TOTALDEATHCOUNT
From CovidDataAnalysis..CovidDeaths
where continent is null
Group by location
Order by TOTALDEATHCOUNT desc





-- showing the continent with the highest death count per population
   Select continent, MAX(cast(Total_deaths as int)) as TOTALDEATHCOUNT 
From CovidDataAnalysis..CovidDeaths
where continent is not null
Group by continent
Order by TOTALDEATHCOUNT desc

-- GLOBAL NUMBERS

SELECT 
     
    SUM(CAST(new_cases AS int)) AS TotalCases, 
    SUM(CAST(new_deaths AS int)) AS TotalDeaths,
    CASE 
        WHEN SUM(CAST(new_cases AS int)) = 0 THEN 0
        ELSE SUM(CAST(new_deaths AS int)) * 100.0 / SUM(CAST(new_cases AS int))
    END AS DeathPercentage
FROM CovidDataAnalysis..CovidDeaths
where continent is not null
--GROUP BY date
Order by 1,2


Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
,SUM(CAST(vac.new_vaccinations as numeric)) Over (Partition by dea.location order by dea.location) 

from CovidDataAnalysis..CovidDeaths dea 
join CovidDataAnalysis..CovidVaccinations vac

	on dea.location = vac.location
	and dea.date = vac.date

	where dea.continent is not null
	order by 2,3


With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
,SUM(CAST(vac.new_vaccinations as numeric)) Over (Partition by dea.location order by dea.location) 

from CovidDataAnalysis..CovidDeaths dea 
join CovidDataAnalysis..CovidVaccinations vac

	on dea.location = vac.location
	and dea.date = vac.date

	where dea.continent is not null
	--order by 2,3
	)

	Select *, (RollingPeopleVaccinated/population)*100
	from PopvsVac
 


 --Creating view to store data for later visulization 
 --view for death count by continent

  create view TotalDeathCountByContinents as
  Select continent, MAX(cast(Total_deaths as int)) as TOTALDEATHCOUNT 
From CovidDataAnalysis..CovidDeaths
where continent is not null
Group by continent
--Order by TOTALDEATHCOUNT desc
 

 --view for total death count by location 

 create view TotalDeathCountByLocation as
 Select Location, MAX(Total_deaths) as TOTALDEATHCOUNT
From CovidDataAnalysis..CovidDeaths
where continent is null
Group by location
--Order by TOTALDEATHCOUNT desc

Select * 
--from TotalDeathCountByLocation
from TotalDeathCountByContinents

 
