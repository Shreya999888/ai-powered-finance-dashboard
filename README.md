# AI-Powered Personal Finance Analytics Dashboard

An end-to-end data analytics project that cleans and analyzes 5 years of personal finance transactions using **Python, MySQL and Power BI**, and uses the **OpenAI API** to generate plain-English financial insights.

---

## Problem Statement

Raw transaction data is hard to read and rarely tells people where their money is going. This project answers:

- How do income, expenses and savings change month by month?
- Which categories take the largest share of spending?
- Are there unusual or outlier transactions?
- Can AI turn the numbers into clear, actionable insights?

---

## Dataset

- **Source:** [Mock Personal Finance Data (Kaggle)](https://www.kaggle.com/)
- **Size:** 5 years of synthetic transactions
- **Columns:** date, description, category, amount, income/expense type
- **Note:** The data is synthetic, so no real personal information is used.

---

## Tech Stack

| Tool | Purpose |
|---|---|
| Python (pandas, matplotlib) | Data cleaning, trend and outlier analysis |
| MySQL | Schema design, data import, analytical queries |
| Power BI | Interactive dashboard |
| OpenAI API | AI-generated financial insights |

---

## Project Workflow

1. **Data cleaning** (Python): handled missing values, duplicates and data types
2. **Database setup** (MySQL): created the schema and imported the cleaned data
3. **SQL analysis**: monthly summary, savings rate, category breakdown, window-function trends, outlier detection
4. **Python analysis**: trend analysis and outlier detection
5. **AI insight generator**: summarized results sent to the OpenAI API to produce readable insights
6. **Dashboard** (Power BI): visualized income, expenses, savings and category trends

---

## Project Structure

```
ai-finance-analytics-dashboard/
├── data/
│   └── cleaned_finance_data.csv
├── sql/
│   └── finance_queries.sql
├── python/
│   ├── data_cleaning.py
│   ├── analysis.py
│   └── ai_insights.py
├── powerbi/
│   └── finance_dashboard.pbix
├── images/
│   └── dashboard.png
├── .env.example
├── .gitignore
├── requirements.txt
└── README.md
```

> Rename the files above to match your actual file names.

---

## Key SQL Concepts Used

- Aggregations with `GROUP BY` and conditional `CASE WHEN`
- CTEs (`WITH`)
- Window functions: `LAG()`, `RANK()`, running totals, moving averages
- Z-score based outlier detection
- Views for Power BI (`vw_monthly_summary`, `vw_category_summary`)

---

## Key Insights

> Replace these with your real findings.

- Insight 1: e.g., Category X accounts for Y% of total expenses
- Insight 2: e.g., Savings rate was highest in Month/Year
- Insight 3: e.g., Expenses peaked during Month/Year
- Insight 4: e.g., N outlier transactions were detected above 3 standard deviations

---

## Dashboard Preview

![Dashboard](images/dashboard.png)

---

## How to Run

**1. Clone the repository**
```bash
git clone https://github.com/Shreya999888/ai-finance-analytics-dashboard.git
cd ai-finance-analytics-dashboard
```

**2. Install dependencies**
```bash
pip install -r requirements.txt
```

**3. Set up environment variables**

Copy `.env.example` to `.env` and add your own keys:
```
OPENAI_API_KEY=your_key_here
DB_PASSWORD=your_mysql_password
```

**4. Set up the database**

Run `sql/finance_queries.sql` in MySQL (update the CSV path in the import query first).

**5. Run the Python scripts**
```bash
python python/data_cleaning.py
python python/analysis.py
python python/ai_insights.py
```

**6. Open the dashboard**

Open `powerbi/finance_dashboard.pbix` in Power BI Desktop.

---

## Future Improvements

- Add budget vs actual tracking
- Forecast future expenses using time series models
- Build a simple web app for AI insights

---

## Author

**Shreya Dhumal**
Aspiring Data Analyst | Python • SQL • Power BI • Tableau • Excel

- LinkedIn: [linkedin.com/in/shreya-dhumal-9b6809328](https://linkedin.com/in/shreya-dhumal-9b6809328)
- GitHub: [github.com/Shreya999888](https://github.com/Shreya999888)
- Email: shreyadhumal2304@gmail.com
