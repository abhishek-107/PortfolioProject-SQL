SELECT TOP 5 *
FROM Internationaldebtstats.dbo.international_debt$

--Finding the number of distinct countries.


SELECT 
    COUNT(DISTINCT(country_name)) AS total_distinct_countries
FROM international_debt$;

--Finding out the distinct debt indicators.

SELECT DISTINCT(indicator_code) AS distinct_debt_indicators
FROM international_debt$
ORDER BY distinct_debt_indicators

--Totalling the amount of debt owed by countries.

SELECT 
    ROUND(SUM(debt/1000000), 2) AS total_debt
FROM international_debt$;

--Finding country with highest debt.

SELECT TOP 1 
    country_name, 
    SUM(debt) AS total_debt
FROM international_debt$
GROUP BY country_name
ORDER BY total_debt DESC;

--Average amount of debt across indicators.

SELECT TOP 10
    indicator_code,
    indicator_name,
    AVG(debt) AS average_debt
FROM international_debt$
GROUP BY indicator_code, indicator_name
ORDER BY average_debt DESC;

--Finding the country with highest amount of principal repayments.

SELECT 
    country_name, 
    indicator_name
FROM international_debt$
WHERE debt = (SELECT 
                 MAX(debt)
             FROM international_debt$
             WHERE indicator_code = 'DT.AMT.DLXF.CD');

--Finding the most common debt indicators

SELECT TOP 20
indicator_code, COUNT(indicator_code) AS indicator_count
FROM international_debt$
GROUP BY indicator_code
ORDER BY indicator_count DESC, indicator_code DESC;