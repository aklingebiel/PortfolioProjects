## OVERVIEW
This project analyzes 20 years of NFL team performance (2003–2023) using SQL to uncover scoring trends, group-level patterns, consistency metrics, and long-term changes across the league. The dataset contains season-level information for every NFL team, enabling a complete exploration of offensive and defensive performance using only structured SQL analysis.

The project begins by building core metrics such as win percentage, point differential, Pythagorean expectation, and expected wins. League-wide season rankings are then added using SQL window functions, creating a consistent way to compare teams within each season.

Group-level analysis follows, including division and conference averages and multi-year era comparisons to evaluate how scoring and defensive strength have changed over time. Additional layers of analysis include season-normalized performance metrics that compare each team to league averages, year-to-year consistency measurements, and segmenting teams into offensive, defensive, and point-differential tiers.

Clean summary tables are then prepared for export to Excel, Tableau, or Power BI, where dashboards visualize long-term scoring trends, division strength, expected vs. actual wins, team tiers, and consistency patterns. The project concludes with documentation of methodology, insights, and the SQL techniques used throughout the workflow.

This end-to-end project demonstrates SQL data cleaning, metric creation, window functions, aggregation, segmentation, performance analysis, visualization preparation, and professional documentation — all using a real 20-year dataset.

## CURRENT PROGRESS
Day 1: A 'team_seasons' CTE containing core season-level metrics was built. Performance vs. expected performance columns were created to compare a team's win/loss percentage to expected performance. Using the Pythagorean model, expected performance is calculated based on point totals for a given season. 

Day 2: Assigned league-wide rankings for a selected season using window functions, ordering by wins and points while noting that NFL tiebreakers were not applied.

Day 3:

Day 4:

Day 5:

Day 6:

Day 7:

Day 8:

Day 9:

Day 10:

## NEXT STEPS
[X] Build core team performance metrics using Pythagorean expectation.

[X] Add season rankings using window functions.

[] Analyze division and conference averages to compare group-level scoring and win trends.

[] Build era-based summaries to compare offensive and defensive trends over time.

[] Create season-normalized performance metrics by comparing each team to league averages.

[] Evaluate team consistency using multi-year performance variability.

[] Segment teams into offensive, defensive, and point-differential tiers based on season-level metrics.

[] Prepare clean, analysis-ready tables for visualization.

[] Build dashboards that visualize trends, comparisons, and performance insights.

[] Document project insights, methodology, and technical skills used.



