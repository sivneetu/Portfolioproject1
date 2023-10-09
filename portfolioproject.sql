SELECT * 
FROM PortfolioProject..Coviddeath
Order By 3,4

--SELECT * 
--FROM PortfolioProject..Covidvaccination
--Order By 3,4

Select location,date,total_cases,new_cases,total_deaths,population
FROM PortfolioProject..Coviddeath

Select location,date,total_cases,total_deaths,(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
FROM PortfolioProject..Coviddeath
WHERE location like '%states%'
order by 1,2

Select location,date,population,total_cases,(CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0))*100 as PercentagePopulation
FROM PortfolioProject..Coviddeath
--WHERE location like '%states%'
order by 1,2
Select location,population,MAX(total_cases)as HighestInfected,MAX((CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)))*100 as PercentagePopulation
FROM PortfolioProject..Coviddeath
--WHERE location like '%states%'
Group By location,population
order by PercentagePopulation desc


--showing contient with highest death count

SELECT continent ,MAX(cast (total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..Coviddeath
Where continent is not NULL
GROUP BY continent 
ORDER BY TotalDeathCount desc;

---show everything across the world
--global numbers
Select SUM(new_cases) as total_cases,SUM(cast (new_deaths as int)) as Total_deaths,SUM(cast (new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..Coviddeath
WHERE continent is not null
--GrOUP BY date
order by 1,2

--Join death and  vaccination
SELECT *
FROM PortfolioProject..Covidvaccination

SELECT * 
FROM PortfolioProject..Coviddeath

SELECT dea.continent,dea.location,dea.date,dea.population,vacc.new_vaccinations,
SUM(CONVERT(int,vacc.new_vaccinations)) over(partition by dea.location Order by dea.location,dea.date) as rollingpeoplevaccinated
FROM
PortfolioProject..Coviddeath dea 
JOIN
PortfolioProject..Covidvaccination vacc 
ON 
dea.location=vacc.location
and dea.date=vacc.date
WHERE dea.continent is not null;

--order by 1,2,3

--use cte


With PopvsVacc (continent,location,date,population,new_vaccinations,rollingpeoplevaccinated)
AS
(
SELECT dea.continent,dea.location,dea.date,dea.population,vacc.new_vaccinations,
SUM(cast(vacc.new_vaccinations as int)) over(partition by dea.location Order by dea.location,dea.date) as rollingpeoplevaccinated
FROM
PortfolioProject..Coviddeath dea 
JOIN
PortfolioProject..Covidvaccination vacc 
ON 
dea.location=vacc.location
and dea.date=vacc.date
WHERE dea.continent is not null
)

Select * rollingpeoplevaccinated/population*100
FROM PopvsVacc;
