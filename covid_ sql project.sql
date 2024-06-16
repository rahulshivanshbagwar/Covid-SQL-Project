SELECT *
FROM [Covid_Portfolio_Project].[dbo].Covid_Deaths
WHERE continent IS NOT NULL
ORDER BY 3,4

--SELECT *
--FROM [Covid_Portfolio_Project].[dbo].Covid_Vaccinations
--ORDER BY 3,4

SELECT Location,date,total_cases,new_cases,total_deaths,population
FROM [Covid_Portfolio_Project].[dbo].Covid_Deaths
WHERE continent IS NOT NULL
ORDER BY 1,2

--comparing total cases vs total deaths
SELECT Location,date,total_cases,total_deaths, (total_deaths/total_cases) 
FROM [Covid_Portfolio_Project].[dbo].Covid_Deaths
WHERE continent IS NOT NULL
ORDER BY 1,2
--error in nvarchar due to incorrect datatypes have to update the data types

--using trycast to convert data types
SELECT Location, [date], total_cases, total_deaths,
       (TRY_CAST(total_deaths AS NUMERIC(10, 2)) / NULLIF(TRY_CAST(total_cases AS NUMERIC(10, 2)), 0)) * 100.0 AS DeathPercentage
FROM [Covid_Portfolio_Project].[dbo].Covid_Deaths
WHERE continent IS NOT NULL
ORDER BY Location, [date];


--looking at the cases in canada and perccentage of dying when contracted
SELECT Location, [date], total_cases, total_deaths,
       (TRY_CAST(total_deaths AS NUMERIC(10, 2)) / NULLIF(TRY_CAST(total_cases AS NUMERIC(10, 2)), 0)) * 100.0 AS DeathPercentage
FROM [Covid_Portfolio_Project].[dbo].Covid_Deaths
WHERE location like '%canada%'
AND continent IS NOT NULL
ORDER BY Location, [date]

--cases vs population comparison in canada 
SELECT Location, [date], total_cases,[population],
       (TRY_CAST(total_cases AS NUMERIC(10, 2)) / population ) * 100.0 AS casePercentage
FROM [Covid_Portfolio_Project].[dbo].Covid_Deaths
WHERE location like '%canada%'
AND continent IS NOT NULL
ORDER BY Location, [date]


--cases vs population in the world
SELECT Location, [date], total_cases,[population],
       (TRY_CAST(total_cases AS NUMERIC(10, 2)) / population ) * 100.0 AS casePercentage
FROM [Covid_Portfolio_Project].[dbo].Covid_Deaths
--WHERE location like '%canada%'
WHERE continent IS NOT NULL
ORDER BY Location, [date]

--looking at countries with highest infection rate compared to population. 
SELECT [location],[population], MAX(total_cases) AS HighestInfectionCount,
       MAX((TRY_CAST(total_cases AS NUMERIC(10, 2)) / population)) * 10.0 AS MaxcasePercentage
FROM [Covid_Portfolio_Project].[dbo].Covid_Deaths
--WHERE location LIKE '%canada%'
WHERE continent IS NOT NULL
GROUP BY [location],[population]
ORDER BY MaxcasePercentage desc

--total deaths as per the location
SELECT [location], MAX(cast(total_deaths as int)) AS ToaldeathCount
FROM [Covid_Portfolio_Project].[dbo].Covid_Deaths
--WHERE location LIKE '%canada%'
WHERE continent IS NOT NULL
GROUP BY [location]
ORDER BY ToaldeathCount desc

--deaths by continent
SELECT continent, MAX(cast(total_deaths as int)) AS ToaldeathCount
FROM [Covid_Portfolio_Project].[dbo].Covid_Deaths
--WHERE location LIKE '%canada%'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY ToaldeathCount desc


--Global Numbers
SELECT [date],SUM(new_cases) as totalcases, SUM(CAST(new_deaths as int)) as total_deaths, 
SUM(CAST(new_deaths as int))/NULLIF(SUM(new_cases),0)*100 AS deathpercentage
FROM [Covid_Portfolio_Project].[dbo].[Covid_Deaths]
WHERE continent IS NOT NULL
GROUP BY [date]
ORDER BY 1,2

--new vactinations based on location
SELECT dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date)
FROM Covid_Portfolio_Project.DBO.Covid_Deaths dea
JOIN Covid_Portfolio_Project.dbo.Covid_Vaccinations vac
	ON dea.location=vac.location
	and dea.date=vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3
--error in converting data type as numbers too big

--error solved by converting to bigint
SELECT dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) as rollingvaccinationcount
FROM Covid_Portfolio_Project.DBO.Covid_Deaths dea
JOIN Covid_Portfolio_Project.dbo.Covid_Vaccinations vac
	ON dea.location=vac.location
	and dea.date=vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3


--using cte table to find percentage vaccinated perr population.
WITH PopVsVac (continent,location,date,population,new_vaccinations,rollingvaccinationcount)
as
(
SELECT dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) as rollingvaccinationcount
FROM Covid_Portfolio_Project.DBO.Covid_Deaths dea
JOIN Covid_Portfolio_Project.dbo.Covid_Vaccinations vac
	ON dea.location=vac.location
	and dea.date=vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
)
SELECT *,(rollingvaccinationcount/population)*100 as percentvacperpop
FROM PopVsVac




--using temp table to find percentage of people vaccinated vs population.
DROP TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rollingvaccinationcount numeric
)
INSERT INTO #PercentPopulationVaccinated

SELECT dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) as rollingvaccinationcount
FROM Covid_Portfolio_Project.DBO.Covid_Deaths dea
JOIN Covid_Portfolio_Project.dbo.Covid_Vaccinations vac
	ON dea.location=vac.location
	and dea.date=vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3


SELECT *, (Rollingvaccinationcount/Population)*100 as percentvaccinatedvspop
FROM #PercentPopulationVaccinated


CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) as rollingvaccinationcount
FROM Covid_Portfolio_Project.DBO.Covid_Deaths dea
JOIN Covid_Portfolio_Project.dbo.Covid_Vaccinations vac
	ON dea.location=vac.location
	and dea.date=vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT *
FROM PercentPopulationVaccinated