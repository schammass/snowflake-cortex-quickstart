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
