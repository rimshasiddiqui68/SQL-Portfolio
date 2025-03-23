## World Layoffs Data cleaning Process 
**`When cleaning the data followings steps are to be followed`**

1. **Check for Duplicates** – Identify and remove any duplicate records.
2. **Standardize and Fix Errors** – Ensure consistency in formatting and correct any data inaccuracies.
3. **Handle Missing Values** – Assess null values and apply appropriate strategies (e.g., filling, removing, or imputing data).
4. **Remove Unnecessary Data** – Drop any columns or rows that are not relevant to the analysis.

**1. lets Check the Duplicates and remove them**
```sql
Select *
FROM (
    SELECT *, 
           ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, 
                              percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
    FROM layoffs_staging
) As cte 
WHERE row_num > 1 ;
```
**Result Set :**

![image](https://github.com/user-attachments/assets/495bf745-84d5-4a0b-b388-f999998c2320)
these are the ones we want to delete where the row number is > 1 or 2or greater essentially.

Since the **DELETE** statement works only on table rows, we first need to create a table that includes a **row_num** column. Once the table is created, we can use the **DELETE** statement to remove rows where `row_num > 1`.
```sql
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  ` row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

Insert the Data from layoffs_staging
```sql
insert into layoffs_staging2
    SELECT *, 
           ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, 
                              percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
    FROM layoffs_staging;
```
Now that we have this we can delete rows were row_num is greater than 2
```sql
DELETE from layoffs_staging2
WHERE ` row_num`> 1;
```

**2. Standardizing the data**
```sql
SELECT * 
FROM world_layoffs.layoffs_staging2;
```
There are some empty spaces in Comapy column , We need to trim the values in the company column to remove trailing spaces.
```sql
UPDATE layoffs_staging2
SET company = TRIM(company);
```

```sql
SELECT * from  layoffs_staging2
WHERE industry like 'Crypto%' ;
```
**Result Set :**

| Company                | Location       | Industry        |
|------------------------|---------------|----------------|
| Immutable             | Sydney        | Crypto         |
| Blockchain.com        | London        | Crypto         |
| Gemini               | New York City | CryptoCurrency |
| Unstoppable Domains  | SF Bay Area   | Crypto Currency |
| OpenSea              | New York City | Crypto         |
| Ignite               | SF Bay Area   | Crypto         |
| Bullish              | Hong Kong     | Crypto         |

<br>
As here the Crypto has multiple different variations. We need to standardize that - let's say all to Crypto

```sql
UPDATE layoffs_staging2
SET industry = "Crypto"
WHERE industry like 'Crypto%';
```
-- now that's taken care of:

```sql
SELECT DISTINCT industry
FROM world_layoffs.layoffs_staging2
ORDER BY industry;
```
**Result Set :**

| Industry      |
|--------------|
| Aerospace    |
| Construction |
| Consumer     |
| Crypto       |
| Data         |
| Education    |
| Energy       |
| Fin-Tech     |
| Finance      |
| Fitness      |
| Food         |
| Hardware     |
| Healthcare   |
| HR           |

<br>

We have some "United States" and some "United States." with a period at the end. To maintain consistency, we need to standardize the formatting across all entries.

```sql
UPDATE layoffs_staging2
SET country = "United States"
WHERE country like '%States.';
```
-- now that's taken care of:

```sql
SELECT DISTINCT country
FROM layoffs_staging2;
```

**Result Set :**

| Country         |
|---------------|
| United States |
| Ireland       |
| Canada        |
| Brazil        |
| Australia     |
| Sweden        |
| India         |
| Germany       |
| Singapore     |
| Pakistan      |
| Denmark       |
| Indonesia     |
| Finland       |
| Nigeria       |

<br>

If we look at the Date column the Data type is in Text format we need to change it to Date format
| Date       |
|------------|
| 3/6/2023  |
| 3/6/2023  |
| 3/6/2023  |
| 3/6/2023  |

<br>
First we need to change the format of dates , we can use str to date to update this field

```sql
UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y');
```

Now that's taken care of

```sql
Select date from layoffs_staging2;
```

**Result Set :**

| Date       |
|------------|
| 2022-07-25 |
| 2022-11-17 |
| 2023-01-27 |
| 2022-07-13 |
| 2022-08-04 |

<br>

Now we can Change it's Datatype from String to Date
```sql
Alter table layoffs_staging2
modify column `date` date;
```
**3. Handeling Null values**
```sql
Select * from layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
```
There are some null values in total_laid_off and same as percentage_laid_off, as this data is all about Total laid off we can delete this data as it's of no use.

```sql
DELETE  from layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
```
Now there are no null values.

```sql
Select*
from layoffs_staging2
WHERE industry IS NULL
OR industry =  '' ;
```
There are some Null values in Industry column
```sql
Select*
from layoffs_staging
WHERE company = "Carvana";
```

| Company  | Location | Industry       |
|----------|---------|---------------|
| Carvana  | Phoenix | Transportation |
| Carvana  | Phoenix | Transportation |
| Carvana  | Phoenix | NULL          |
<br>
It looks like Carvana belongs to the Transportation industry, but the industry field is not populated in some rows.
This is likely the case for other companies as well.
To ensure consistency, we can write a query that automatically updates missing industry values by checking for other rows with the same company name.
This approach eliminates the need for manual corrections, making it efficient even for large datasets.

```sql
UPDATE layoffs_staging2 T1
join layoffs_staging2 t2
on t1.company = t2.company 
AND 
t1.location = t2.location
 SET t1.industry = t2.industry
 WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL ;
```
**3. Removing unwanted columns**
```sql
ALTER TABLE  layoffs_staging2   
DROP COLUMN ` row_num` ;
```
We can drop this column as it is not needed.

**The data is now clean, standardized, and ready for further Analysis. 🚀**


