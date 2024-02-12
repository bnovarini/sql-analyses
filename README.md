# Compilation of helpful SQL scripts
Sharing curious SQL scripts and algorithms I've built that could speed up data analysis for founders and data folks, especially those working with SaaS

## Context

Data-driven decision-making requires trusting how the analyses are performed. While there are many platforms that have pre-built calculations, like Stripe, Firebase, Amplitude, and many others:
1. If you have relevant data that don't pass through that platform (e.g., multiple revenue streams, backend events you don't track via Firebase, etc), you won't be able to take them into account
2. You depend on the black box on how they run their calculations. Maybe you want to do an analysis for a particular set of users. Maybe you want to filter based on specific criteria accessible only via your database. You're stuck.

I've decided to start sharing some SQL queries I've built that have helped me gain control of the process.

## Context for analyses in the repo

#### **[pareto][pareto-analysis]** (Standard SQL)
Create a visual pareto chart of the data, helpful when trying to communicate with stakeholders.
You can always use approx_quantiles (Standard SQL) or percentile_disc (POSTGRES) to get specific values, but a chart can convey more information in one look (e.g., how fast does the curve increase, when does it reach a saturation point, etc.)

<img width="600" alt="Pareto analysis example" src="https://github.com/bnovarini/sql-analyses/assets/49925472/1f8fd603-f90d-4d6c-85ac-a661e2c497d8">

#### **[rolling-windows][rolling-windows]** (Standard SQL)
There are always ways to use window functions, but here's another approach to do rolling window analyses (30-day rolling, 7-day rolling, etc.)

#### **[cohort-retention-analysis][cohort-retention-analysis]** (Standard SQL)
Assuming you already track your user revenue (or any activity) with [Metabase][metabase] or and equivalent tool, this script helps you display the data in the format of a retention chart or table.

_If you use Postgres, I **don't** recommend trying to pivot the table like is shown in the end, because there is no shortcut like there is in Standard SQL_

#### **[retention-curve-regression][regression-sql]** (Standard SQL)
_If you were to summarize your retention cohort analyses in one curve, how would you go about it? Do you have early indications that your retention curves are stabilizing?_

Doing a weighted average always felt wrong to me. If you only had one cohort with M12 data, would you confidently average that one datapoint and say that was your expected M12 data for all cohorts? It also doesn't help you on finding a methodology to extrapolate for future months.

Fitting an exponential curve feels more appropriate ($`y = a + b e^{cx}`$). In fact, that's exactly what retention should feel like: a geometric progression with a certain hidden coefficient `q` that is multiplied again and again and again, usually `q < 1`, and that hopefully that doesn't go to zero. 

There are Python libraries to do this easily, but for those of us who like our analyses always fresh (e.g., refreshing a dashboard on Metabase) those libs don't do the job. So if you are used to having real-time dashboards using SQL, with tools like Metabase or Looker, this SQL query adapts the non-linear regression algorithm to fit the exponential curve $`y = a + b e^{cx}`$. Every time there's new data, the regression is recalculated automatically by just refreshing your dashboard.

Here's an image of what the trendline looks like when running with some [sample data][sample-retention-data] from Profitwell (chart generated in Metabase).

<img width="600" alt="Retention curve regression example" src="https://github.com/bnovarini/sql-analyses/assets/49925472/f58162d0-8b7f-4d83-9e15-091aa5af5f8d">

#### **More analyses to be shared soon**

## License

MIT

**Hope this helps. Feel free to contribute and help optimize these queries!**

[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

   [regression-sql]:https://github.com/bnovarini/sql-analyses/blob/main/retention-curve-regression.sql
   [sample-retention-data]:https://demo.profitwell.com/app/trends/cohorts
   [cohort-retention-analysis]:https://github.com/bnovarini/sql-analyses/blob/main/cohort-retention-analysis.sql
   [metabase]:https://www.metabase.com/
   [rolling-windows]:https://github.com/bnovarini/sql-analyses/blob/main/rolling-windows.sql
   [pareto-analysis]:https://github.com/bnovarini/sql-analyses/blob/main/pareto.sql
