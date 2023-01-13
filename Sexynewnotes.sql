-- select data to be used
select  location, date, total_cases,new_cases,total_deaths,population 
from coviddts
order by 1,2; 
-- Looking at Total Cses vs Total Deaths
-- shows the likelihood of dying if infected with covid-19 in your country
select  location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from coviddts
where location = 'Africa'
order by 1,2; 

-- Total cases vs Population
select location,date,total_cases, population, (total_cases/population)*100 as PopulationPercentage
from coviddts
where location = 'Africa'
order by 1,2;

-- countries with highest infection rate compared to population 

select location,population,max(total_cases) as HighestInfectionCount, max(total_cases/population)*100 as PercentPopulationInfected
from coviddts
group  by location,population
order by PercentPopulationInfected desc;

-- Countries with Highest Number of Deaths 

select location, max(total_deaths ) as TotalDeathsCount
from coviddts
group by location 
order by TotalDeathsCount desc;

-- continents  with the highest datacount per population.
select continent, max(total_deaths) as TotalDeathCount
from coviddts
where continent is not null 
group by continent 
order by TotalDeathCount desc ;
-- GLOBAL NUMBERS 
select  max(new_cases) as TotalCases , max(new_deaths) as TotalDeaths,sum(new_deaths)/sum(new_cases)*100 as DeathPercentage
from coviddts
where continent is not null
-- group by date 
order by 1,2;

SELECT 
    *
FROM
    coviddts cd
        JOIN
    covidvaccines cv ON cd.location = cv.location
        AND cd.date = cv.date ; 

-- Total Population and Total Vaccination 

select cd.continent , cd.location , cd.date , cd.population , cv.new_vaccinations,
 sum(cv.new_vaccinations) over (partition by cd.location order by cd.location , cd.date) as RollingPeopleVaccinated 
from coviddts cd 
join covidvaccines cv
on  cd.location = cv.location 
and cd.date = cv.date 
where cd.continent is not null 
order by 2,3 ; 

-- viiews to store data for visualizations 

create view PercentPopulationVaccinated as
select cd.continent , cd.location , cd.date , cd.population , cv.new_vaccinations,
 sum(cv.new_vaccinations) over (partition by cd.location order by cd.location , cd.date) as RollingPeopleVaccinated 
from coviddts cd 
join covidvaccines cv
on  cd.location = cv.location 
and cd.date = cv.date 
where cd.continent is not null; 



