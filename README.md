# 🧠 Getting Started with Snowflake AI

Build a conversational analytics app using Snowflake's **Cortex Analyst**, enabling users to query structured data with natural language.

## 📦 Prerequisites

Before you begin, make sure you have:

- ✅ Git installed
- ✅ Python 3.9–3.11 (optional, for semantic model generator)
- ✅ A Snowflake account with permissions to create:
  - Databases
  - Schemas
  - Tables
  - Stages
  - UDFs and stored procedures

## 🚀 Overview

**Cortex Analyst** is an AI-driven feature in Snowflake that translates natural language into SQL. This guide helps you:

- Set up the Snowflake environment
- Load example revenue data
- Create a semantic model
- Build a Streamlit app for conversational querying

## 🏗️ Step-by-Step Guide

https://quickstarts.snowflake.com/guide/getting_started_with_cortex_analyst/index.html#0


Sure thing! Here's an updated section you can add to your `README.md` to highlight **Cortex Search** and how it's integrated into your app:

---

## 🔎 Cortex Search Integration

**Cortex Search** is a fully managed hybrid search engine in Snowflake that combines **semantic vector search** with **keyword-based search** to deliver fast, high-quality results from your data.

### ✨ What It Does

- Enables **fuzzy search** over structured and unstructured data
- Powers **Retrieval-Augmented Generation (RAG)** for chatbots and AI apps
- Automatically handles **embedding, indexing, and refreshes**
- Supports **metadata filtering** and **semantic reranking** for precision

### 🧠 How It's Used in This App

In this project, Cortex Search is used to:

- Index revenue-related data for fast, natural language search
- Enhance the accuracy of responses in the Streamlit chat interface
- Support multi-turn conversations by retrieving relevant context

### ⚙️ Setup Instructions

To create a Cortex Search Service:

```sql
CREATE VIEW revenue_by_region AS
SELECT 
    rd.SALES_REGION,
    DATE_TRUNC('month', dr.DATE) as month,
    SUM(dr.REVENUE) as total_revenue,
    SUM(dr.COGS) as total_costs,
    SUM(dr.REVENUE - dr.COGS) as gross_profit,
    ROUND(AVG(dr.FORECASTED_REVENUE), 2) as avg_forecasted_revenue,
    COUNT(*) as transaction_count
FROM daily_revenue dr
JOIN region_dim rd ON dr.REGION_ID = rd.REGION_ID
GROUP BY rd.SALES_REGION, DATE_TRUNC('month', dr.DATE)
ORDER BY rd.SALES_REGION, month;


CREATE OR REPLACE CORTEX SEARCH SERVICE revenue_search_service
ON description_column
ATTRIBUTES sales_region, month, total_revenue, gross_profit
WAREHOUSE = cortex_analyst_wh
TARGET_LAG = '1 day'
EMBEDDING_MODEL = 'snowflake-arctic-embed-l-v2.0'
AS (
  SELECT 
    sales_region,
    month,
    total_revenue,
    gross_profit,
    CONCAT('Region: ', sales_region, ', Month: ', month, ', Revenue: ', total_revenue, ', Profit: ', gross_profit) AS description_column
  FROM revenue_by_region
);
```

> Replace `description_column`, `region`, `product`, and `revenue_data_table` with your actual column and table names.

### 📚 Learn More

- [Cortex Search Overview](https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-search/cortex-search-overview)  
- [Create Cortex Search Service](https://docs.snowflake.com/en/sql-reference/sql/create-cortex-search)  
- [Cortex Search Blog](https://www.snowflake.com/en/blog/cortex-search-ai-hybrid-search/)  

---


# 🚀 Quickstart Guide: Snowflake Cortex AISQL

This README walks you through the basics of using Snowflake’s Cortex AISQL functions to generate AI-powered text completions and perform simple sentiment filtering—all directly in SQL.

---

## 📦 Prerequisites

Before you begin, make sure you have:

- A Snowflake account with permission to:
  - Create databases, schemas, and tables  
  - Execute external/AISQL functions  
- The built-in `SNOWFLAKE.CORTEX_USER` role granted to your user  
- Access to a worksheet in Snowsight or any Snowflake SQL client  

---

## 🏗️ Setup

1. Switch to your AI role  
   ```sql
   USE ROLE ACCOUNTADMIN;
   ```

2. Create a training database and schema  
   ```sql
   CREATE DATABASE IF NOT EXISTS AISQL_TRAINING;
   USE SCHEMA AISQL_TRAINING.PUBLIC;
   ```

---

## ✨ Example 1: Generate a Weather Report

Use `AI_COMPLETE` to ask an AI model for a custom weather update.

```sql
SELECT AI_COMPLETE(
  'claude-3-5-sonnet',
  PROMPT(
    'Write a weather report for Montréal, Québec on July 16, 2025. ' ||
    'Include temperature, air quality, and forecast.'
  ),
  OBJECT_CONSTRUCT(
    'temperature', 0.7,
    'max_tokens', 200
  )
) AS weather_report;
```

---

## ✨ Example 2: Sentiment Filtering of Reviews

1. Create a simple `reviews` table and insert sample data  
   ```sql
   CREATE OR REPLACE TABLE reviews (text STRING);

   INSERT INTO reviews VALUES
     ('I love this product!'),
     ('Terrible quality'),
     ('Great value for money');
   ```

2. Filter for **satisfied** customers  
   ```sql
   SELECT text
   FROM reviews
   WHERE AI_FILTER(
     PROMPT('In the following review, does the customer sound satisfied? {0}', text)
   );
   ```

3. Filter for **unhappy** customers  
   ```sql
   SELECT text
   FROM reviews
   WHERE AI_FILTER(
     PROMPT('Is the reviewer unhappy? {0}', text)
   );
   ```

---

## 🔧 Next Steps

- Explore other AISQL functions:
  - `AI_CLASSIFY` for multi-class labeling  
  - `AI_SUMMARIZE_AGG` for document summarization  
  - `AI_EMBED` for similarity searches  
- Tweak model parameters (`temperature`, `max_tokens`) to control creativity and response length  
- Combine AI functions with standard SQL logic to build richer pipelines  

---

## 📚 Resources

- Official AISQL docs:  
  https://docs.snowflake.com/en/user-guide/snowflake-cortex/aisql  
- Model reference guide:  
  https://docs.snowflake.com/en/user-guide/azure-llm-model-catalog  
- Snowflake community examples:  
  https://github.com/Snowflake-Labs  

---

You’re all set! Run these snippets in your Snowflake worksheet and start experimenting with AI-powered SQL today. 😊  
