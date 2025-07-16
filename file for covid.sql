create database Portfolio;
show table status;
select * from portfolio.`covid deaths`order by 3,4;
#select * from portfolio.`covid vaca` order by 1,2;
-- select the data we need 
SELECT 
    location, date, total_cases, total_deaths, population
FROM
    portfolio.`covid deaths`
ORDER BY 1 , 2;
-- looking at Total deaths vs Total cases
SELECT 
    location, date, total_cases, total_deaths, population,(total_cases/total_deaths) as death_percentage
FROM
    portfolio.`covid deaths`
   -- where location=`Afghanistan`
ORDER BY 1 , 2;
-- Total cases vs population
SELECT 
    location, date, total_cases, total_deaths, population,(total_cases/population)*100 as cases_percentage
FROM
    portfolio.`covid deaths`
-- where location=`Andorra`
ORDER BY 1 , 2;
-- Looking at countries with Highest Infection Rate Compared to Population.
SELECT 
    location,
    date,
    population,
    max(total_cases)  as Highestnfectionrate,
    MAX(total_cases / population) * 100 AS populationpercentageinfaction
FROM
    portfolio.`covid deaths`
    group by location,population,date
    order by populationpercentageinfaction desc;

select max(total_cases)from portfolio.`covid deaths`;
-- showing countries with Highest Death count per population 
select max(total_deaths) as TotalDeathCount,location
from  portfolio.`covid deaths` group by location;
-- Let's breaks things down by continent
select max(total_deaths) as TotalDeathCount,location
from  portfolio.`covid deaths` group by location order by TOtalDeathCount;
-- Global Numbers
SELECT 
    location,
    population,
    date,
    total_deaths,
    total_cases,
    (total_deaths / total_cases) AS DeathPercetage
FROM
    portfolio.`covid deaths`; 
    -- WHERE
   -- loction LIKE '% Albania %'
   select * from portfolio.`covid deaths` dea join portfolio.`covid vaca` vac
   on dea.location = vac.location
   and dea.date = vac.date;
   
   -- Looking at Total population vs Vaccinations
    SELECT 
    dea.date,
    dea.continent,
    dea.location,
    dea.population,
    vac.new_vaccinations,
    sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,dea.date) as Rollingpeoplevaccinated
FROM
    portfolio.`covid deaths` dea
        JOIN
    portfolio.`covid vaca` vac ON dea.location = vac.location
        AND dea.date = vac.date
        order by 2,3;
        
        
-- TEMP Table
drop table if exists percentage_population_vaccinated ;
CREATE TABLE percentage_population_vaccinated (continent text,location text,date text,population double,new_vaccinations text,Rollingpeoplevaccinated numeric);
INSERT into percentage_population_vaccinated  
SELECT dea.date,
    dea.continent,
    dea.location,
    dea.population,
    vac.new_vaccinations,
    sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,dea.date) as Rollingpeoplevaccinated
FROM
    portfolio.`covid deaths` dea
        JOIN
    portfolio.`covid vaca` vac ON dea.location = vac.location
        AND dea.date = vac.date
        order by 2,3;
        
select *,(Rollingpeoplevaccinated/population)*100 from percentage_population_vaccinated ;


-- create view for store data for later visualization

create view  percentage_population_vaccinated_1 as SELECT dea.date,
    dea.continent,
    dea.location,
    dea.population,
    vac.new_vaccinations,
    sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,dea.date) as Rollingpeoplevaccinated
FROM
    portfolio.`covid deaths` dea
        JOIN
    portfolio.`covid vaca` vac ON dea.location = vac.location
        AND dea.date = vac.date
        order by 2,3;
        
select *,(Rollingpeoplevaccinated/population)*100 from percentage_population_vaccinated ;

select * from percentage_population_vaccinated ;



