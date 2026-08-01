                              -- Customer Churn Root Cause Analysis

Create Database Customer_Churn;
Use Customer_Churn;
Select * from customer_data;

-- Data Exploration – Check Distinct Values
-- Gender-wise customer distribution and percentage contribution
SELECT Gender, Count(Gender) as TotalCount,
Count(Gender) * 1.0 / (Select Count(*) from customer_data )  as Percentage
from customer_data
Group by Gender;

-- Contract-wise customer count and percentage distribution
SELECT Contract, Count(Contract) as TotalCount,
Count(Contract) * 1.0 / (Select Count(*) from customer_data)  as Percentage
from customer_data
Group by Contract;

-- Customer status-wise customer count and revenue contribution
SELECT Customer_Status, Count(Customer_Status) as TotalCount, Sum(Total_Revenue) as TotalRev,
Sum(Total_Revenue) / (Select sum(Total_Revenue) from customer_data) * 100  as RevPercentage
from customer_data
Group by Customer_Status;

-- State-wise customer distribution and ranking by percentage
SELECT State, Count(State) as TotalCount,
Count(State) * 1.0 / (Select Count(*) from customer_data)  as Percentage
from customer_data
Group by State
Order by Percentage desc;

-- Distinct internet service types used by customers
Select distinct Internet_Type
from customer_data;


-- Data Exploration – Column-wise NULL and blank value analysis
SELECT 
    SUM(CASE WHEN Customer_ID IS NULL OR TRIM(Customer_ID) = '' THEN 1 ELSE 0 END) AS Customer_ID_Missing_Count,
    SUM(CASE WHEN TRIM(Gender) = '' OR Gender IS NULL THEN 1 ELSE 0 END) AS Gender_Missing_Count,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Age_Missing_Count,
    SUM(CASE WHEN TRIM(Married) = '' OR Married IS NULL THEN 1 ELSE 0 END) AS Married_Missing_Count,
    SUM(CASE WHEN TRIM(State) = '' OR State IS NULL THEN 1 ELSE 0 END) AS State_Missing_Count,
    SUM(CASE WHEN Number_of_Referrals IS NULL THEN 1 ELSE 0 END) AS Number_of_Referrals_Missing_Count,
    SUM(CASE WHEN Tenure_in_Months IS NULL THEN 1 ELSE 0 END) AS Tenure_in_Months_Missing_Count,
    SUM(CASE WHEN TRIM(Value_Deal) = '' OR Value_Deal IS NULL THEN 1 ELSE 0 END) AS Value_Deal_Missing_Count,
    SUM(CASE WHEN TRIM(Phone_Service) = '' OR Phone_Service IS NULL THEN 1 ELSE 0 END) AS Phone_Service_Missing_Count,
    SUM(CASE WHEN TRIM(Multiple_Lines) = '' OR Multiple_Lines IS NULL THEN 1 ELSE 0 END) AS Multiple_Lines_Missing_Count,
    SUM(CASE WHEN TRIM(Internet_Service) = '' OR Internet_Service IS NULL THEN 1 ELSE 0 END) AS Internet_Service_Missing_Count,
    SUM(CASE WHEN TRIM(Internet_Type) = '' OR Internet_Type IS NULL THEN 1 ELSE 0 END) AS Internet_Type_Missing_Count,
    SUM(CASE WHEN TRIM(Online_Security) = '' OR Online_Security IS NULL THEN 1 ELSE 0 END) AS Online_Security_Missing_Count,
    SUM(CASE WHEN TRIM(Online_Backup) = '' OR Online_Backup IS NULL THEN 1 ELSE 0 END) AS Online_Backup_Missing_Count,
    SUM(CASE WHEN TRIM(Device_Protection_Plan) = '' OR Device_Protection_Plan IS NULL THEN 1 ELSE 0 END) AS Device_Protection_Plan_Missing_Count,
    SUM(CASE WHEN TRIM(Premium_Support) = '' OR Premium_Support IS NULL THEN 1 ELSE 0 END) AS Premium_Support_Missing_Count,
    SUM(CASE WHEN TRIM(Streaming_TV) = '' OR Streaming_TV IS NULL THEN 1 ELSE 0 END) AS Streaming_TV_Missing_Count,
    SUM(CASE WHEN TRIM(Streaming_Movies) = '' OR Streaming_Movies IS NULL THEN 1 ELSE 0 END) AS Streaming_Movies_Missing_Count,
    SUM(CASE WHEN TRIM(Streaming_Music) = '' OR Streaming_Music IS NULL THEN 1 ELSE 0 END) AS Streaming_Music_Missing_Count,
    SUM(CASE WHEN TRIM(Unlimited_Data) = '' OR Unlimited_Data IS NULL THEN 1 ELSE 0 END) AS Unlimited_Data_Missing_Count,
    SUM(CASE WHEN TRIM(Contract) = '' OR Contract IS NULL THEN 1 ELSE 0 END) AS Contract_Missing_Count,
    SUM(CASE WHEN TRIM(Paperless_Billing) = '' OR Paperless_Billing IS NULL THEN 1 ELSE 0 END) AS Paperless_Billing_Missing_Count,
    SUM(CASE WHEN TRIM(Payment_Method) = '' OR Payment_Method IS NULL THEN 1 ELSE 0 END) AS Payment_Method_Missing_Count,
    SUM(CASE WHEN Monthly_Charge IS NULL THEN 1 ELSE 0 END) AS Monthly_Charge_Missing_Count,
    SUM(CASE WHEN Total_Charges IS NULL THEN 1 ELSE 0 END) AS Total_Charges_Missing_Count,
    SUM(CASE WHEN Total_Refunds IS NULL THEN 1 ELSE 0 END) AS Total_Refunds_Missing_Count,
    SUM(CASE WHEN Total_Extra_Data_Charges IS NULL THEN 1 ELSE 0 END) AS Total_Extra_Data_Charges_Missing_Count,
    SUM(CASE WHEN Total_Long_Distance_Charges IS NULL THEN 1 ELSE 0 END) AS Total_Long_Distance_Charges_Missing_Count,
    SUM(CASE WHEN Total_Revenue IS NULL THEN 1 ELSE 0 END) AS Total_Revenue_Missing_Count,
    SUM(CASE WHEN TRIM(Customer_Status) = '' OR Customer_Status IS NULL THEN 1 ELSE 0 END) AS Customer_Status_Missing_Count,
    SUM(CASE WHEN TRIM(Churn_Category) = '' OR Churn_Category IS NULL THEN 1 ELSE 0 END) AS Churn_Category_Missing_Count,
    SUM(CASE WHEN TRIM(Churn_Reason) = '' OR Churn_Reason IS NULL THEN 1 ELSE 0 END) AS Churn_Reason_Missing_Count
FROM customer_data;

-- Remove null and insert the new data into Prod table
CREATE TABLE prod_Churn AS
SELECT 
    Customer_ID,
    Gender,
    Age,
    Married,
    State,
    Number_of_Referrals,
    Tenure_in_Months,
    CASE 
        WHEN Value_Deal IS NULL OR TRIM(Value_Deal) = '' THEN 'None'
        ELSE Value_Deal
    END AS Value_Deal,Phone_Service,
    CASE 
        WHEN Multiple_Lines IS NULL OR TRIM(Multiple_Lines) = '' THEN 'No'
        ELSE Multiple_Lines
    END AS Multiple_Lines,Internet_Service,
    CASE 
        WHEN Internet_Type IS NULL OR TRIM(Internet_Type) = '' THEN 'None'
        ELSE Internet_Type
    END AS Internet_Type,
    CASE 
        WHEN Online_Security IS NULL OR TRIM(Online_Security) = '' THEN 'No'
        ELSE Online_Security
    END AS Online_Security,
    CASE 
        WHEN Online_Backup IS NULL OR TRIM(Online_Backup) = '' THEN 'No'
        ELSE Online_Backup
    END AS Online_Backup,
    CASE 
        WHEN Device_Protection_Plan IS NULL OR TRIM(Device_Protection_Plan) = '' THEN 'No'
        ELSE Device_Protection_Plan
    END AS Device_Protection_Plan,
    CASE 
        WHEN Premium_Support IS NULL OR TRIM(Premium_Support) = '' THEN 'No'
        ELSE Premium_Support
    END AS Premium_Support,
    CASE 
        WHEN Streaming_TV IS NULL OR TRIM(Streaming_TV) = '' THEN 'No'
        ELSE Streaming_TV
    END AS Streaming_TV,
    CASE 
        WHEN Streaming_Movies IS NULL OR TRIM(Streaming_Movies) = '' THEN 'No'
        ELSE Streaming_Movies
    END AS Streaming_Movies,
    CASE 
        WHEN Streaming_Music IS NULL OR TRIM(Streaming_Music) = '' THEN 'No'
        ELSE Streaming_Music
    END AS Streaming_Music,
    CASE 
        WHEN Unlimited_Data IS NULL OR TRIM(Unlimited_Data) = '' THEN 'No'
        ELSE Unlimited_Data
    END AS Unlimited_Data,Contract,Paperless_Billing,Payment_Method,Monthly_Charge,Total_Charges,Total_Refunds,Total_Extra_Data_Charges,
    Total_Long_Distance_Charges,Total_Revenue,Customer_Status,
    CASE 
        WHEN Churn_Category IS NULL OR TRIM(Churn_Category) = '' THEN 'Others'
        ELSE Churn_Category
    END AS Churn_Category,
    CASE 
        WHEN Churn_Reason IS NULL OR TRIM(Churn_Reason) = '' THEN 'Others'
        ELSE Churn_Reason
    END AS Churn_Reason
FROM customer_data;

Select * from prod_churn;


-- Create View for Power BI
Create View vw_churndata as
	select * from prod_Churn where Customer_Status In ('Churned', 'Stayed');


Create View vw_JoinData as
	select * from prod_Churn where Customer_Status = 'Joined';

Select * from vw_churndata;
Select * from vw_JoinData;