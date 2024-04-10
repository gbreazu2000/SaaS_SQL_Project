# Revenue Revelations: Uncovering Patterns in SaaS Sales Data

### My Motivation ?

I've always had a knack for digging into data and finding the nuggets that can make a real difference in how a business operates. This project is my way of diving headfirst into the world of SaaS analytics, where I can explore raw datasets and uncover insights that could genuinely impact a company's growth trajectory. I also wanted to explore and sharpen my skills in SaaS evaluation metrics like churn analysis, revenue analysis, and geographical analysis. 

### Purpose and Objectives ?

The objective of this project is to transform raw CSV sales data from AWS products into a structured ERD database, leveraging data engineering principles to create sub-tables and ensure data organization. Following data cleaning, the aim is to explore the dataset and derive meaningful business metrics for evaluation, uncovering valuable insights to inform decision-making.

### Data Source ?

The dataset was obtained from Kaggle (https://www.kaggle.com/datasets/nnthanh101/aws-saas-sales) and contains detailed sales data from a fictitious SaaS company operating in a B2B (business-to-business) model, focusing on sales of AWS products between the years 2020 and 2023. With up to 10,000 rows of information, this comprehensive dataset offers insights into the sales performance and trends of AWS products over a three-year period.

These are the rows from the original CSV file:

- Row id              - Customer
- Order id            - Industry
- Order date          - Segment
- Date Key            - Product
- Contact Name        - License
- Country             - Sales
- City                - Profit
- Region              - Discount
- Subregion           - Quantity
- Customer ID

### Data Modelling Process ?

In the data modeling process, the initial CSV file consisted of a single large table encompassing various aspects of sales data. To emulate a real business environment and enhance organizational efficiency, it was imperative to partition this extensive table into multiple sub-tables. These are the following subtables that I created, allowing for clearer delineation of distinct data entities:

- Orders
- Customers
- Locations
- Sales 

In practical business scenarios, accessing large datasets can be resource-intensive and costly. By breaking down the dataset into smaller, specialized tables, we optimize data retrieval efficiency and minimize unnecessary resource consumption. Each segregated table serves a specific purpose, facilitating streamlined data querying and analysis while ensuring scalability and maintainability of the database structure.

### Business Insights ?

In this project, my analysis was structured into three main categories: Churn Analysis, Revenue Analysis, and Geographical Analysis. 

In exploring churn, I initially examined customer retention rates but found that all 90 customers consistently returned and made purchases each year, indicating minimal churn at the customer level. Recognizing the unique challenges of pay-as-you-go (PAYG) subscription models, I shifted focus to product churn, revealing fluctuations in product usage patterns. Notably, storage and marketing suite products experienced a decline in quantity ordered over time, prompting further investigation into profitability trends across product categories.

Moving to revenue analysis, I delved into various factors influencing profit margins, including customer attributes such as industry and segment. Additionally, I calculated annual percentage growth for each product, identifying steady performers like support, alchemy, and site analytics, contrasted with products such as contactmatcher and Big OI Database, which experienced declining profitability over the three-year period. This analysis provided valuable insights into product performance and opportunities for optimization.

Geographical analysis centered on identifying key regions driving profits, with a focus on countries and cities. Analysis revealed that the United Kingdom, USA, and Canada emerged as top-performing countries in terms of profit margins, with cities like London, New York, and Toronto leading in revenue generation. These findings offer strategic guidance for targeting specific markets and optimizing resource allocation to maximize profitability and drive sustainable growth.

### Conclusive Thoughts ?

In conclusion, while the analysis yielded valuable business insights, certain indicators suggest that the dataset may not fully reflect real-world scenarios, such as the absence of customer churn. Moving forward, enhancing the project with data visualization techniques would not only augment the presentation of findings but also provide non-technical stakeholders with clearer insights. Additionally, sourcing datasets that more accurately mirror genuine business environments will be crucial for generating actionable intelligence and informing strategic decision-making. By incorporating these enhancements and continuing to refine analysis methodologies, the project stands to deliver even greater value in uncovering actionable insights and driving business growth.
