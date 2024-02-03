# sql-analyses
Sharing curious SQL analyses and algorithms I've built that could help folks out

## Context

Data-driven decision-making requires trusting how the analyses are performed. While there are many tools that have pre-built calculations from platforms, like Stripe for retention:
1. If you have relevant data (e.g., multiple revenue streams) that don't pass through that platform, you won't be able to take them into account
2. You depend on the black box on how they run their calculations

I've decided to start sharing some SQL queries I've built that have helped me gain control of the process.

## Context for analyses in the repo

#### **[retention-curve-regression][regression-sql]** (Standard SQL)
_If you were to summarize your retention cohort analyses in one curve, how would you go about it? Do you have early indications that your retention curves are stabilizing?_

I've always felt that using a weighted average of each month was a weird approach. You end up overindexing later months with fewer datapoints. For instance, if M12 only has one datapoint, I feel wrong saying that my expected M12 retention of other cohorts is that value. It also doesn't help you get any idea on how to extrapolate for future months.

Fitting an exponential curve feels more appropriate (`y = a + b*exp(c*age)`). There are Python libraries to do this easily, but I didn't want this analysis to be static, downloading the data every time I wanted to run the analysis. 

So if you are used to having real-time dashboards using SQL, with tools like Metabase or Looker, this SQL query adapts the non-linear regression algorithm to fit that exponential curve to a SQL environment. So every time there's new data, the regression is recalculated automatically.

You can then actually plot the trendline retention curve and also calculate the expected lifetime of your users with the equation, all using your real-time data. No need to download it anymore.

Here's an illustrative example of what the trendline looks like when running with some [sample data][sample-retention-data] from Profitwell (chart generated in Metabase).

<img width="600" alt="image" src="https://github.com/bnovarini/sql-analyses/assets/49925472/f58162d0-8b7f-4d83-9e15-091aa5af5f8d">

#### **More analyses to be shared soon**

## License

MIT

**Hope this helps. Feel free to contribute and help optimize these queries!**

[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

   [regression-sql]:https://github.com/bnovarini/sql-analyses/blob/main/retention-curve-regression.sql
   [sample-retention-data]:https://demo.profitwell.com/app/trends/cohorts
