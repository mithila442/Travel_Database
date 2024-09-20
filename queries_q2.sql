-- 2. (a) This query offers a detailed view of customer booking trends and expenditure per booking on a quarterly timeframe. 
-- Essential for predicting financial trends and planning budgets, it helps in recognizing the busiest and quietest periods and the typical customer spending, which are key factors in shaping pricing and promotional strategies.
    SELECT TO_CHAR(Payments.HappenedAt, 'Q') AS Quarter, COUNT(*) AS Number_of_Bookings, AVG(Payments.Amount) AS Average_Spending
    FROM Payments
    GROUP BY TO_CHAR(Payments.HappenedAt, 'Q');

-- 2. (b) This query delves into the popularity and total duration of stays linked with each travel package. 
-- It's crucial for assessing which travel packages are most favored and the typical length of stay, providing insights that are beneficial for refining existing packages and crafting new ones that meet customer preferences.
    SELECT P.Package_ID, COUNT(P.Package_ID) AS Number_of_packages, SUM(P.Stay_duration) AS Total_Stay_Duration
    FROM Packages_name P
    JOIN Itinerary I ON I.Package_ID = P.Package_ID
    GROUP BY P.Package_ID
    ORDER BY Number_of_Packages DESC, Total_Stay_Duration DESC;

--2. (c) This query provides insights into the frequency of flights and travel packages provided by different airlines. 
-- It's instrumental in understanding which airlines have the most extensive offerings, aiding in strategic airline partnerships and gaining insights into customer preferences for flights included in travel packages.
    SELECT F.Airways, COUNT(DISTINCT F.Flight_Reference) AS Flights_Offered, COUNT(DISTINCT PF.Package_ID) AS Packages_Offered
    FROM Flights F
    JOIN Packages_Flights PF ON F.Flight_Reference = PF.Flight_Reference
    GROUP BY F.Airways
    ORDER BY Packages_Offered DESC;

--2. (d) This query is key for identifying revenue distribution across different regions. 
-- It helps in spotting the most profitable branches and countries, guiding where to focus investments and resources. 
-- Additionally, it's useful for analyzing regional markets, influencing expansion or consolidation decisions.
    SELECT Branch.City, Branch.Country, SUM(Payments.Amount) AS Total_Revenue
    FROM Payments
    JOIN Branch ON Payments.Branch_ID = Branch.Branch_ID
    GROUP BY Branch.City, Branch.Country
    ORDER BY Total_Revenue DESC;

--2. (e) This query aims to single out branches experiencing high refund instances, a vital indicator of customer contentment and operational effectiveness. 
--  Identifying these branches allows for an investigation into the causes, improving customer relations, and fine-tuning operational procedures to decrease refund rates, thereby boosting overall business profitability.
    SELECT B.Branch_ID, B.City, SUM(R.Refund_amount) AS Total_Refunds
    FROM Branch B
    JOIN Refunds R ON B.Branch_ID = R.Branch_ID
    GROUP BY B.Branch_ID, B.City
    ORDER BY Total_Refunds DESC;