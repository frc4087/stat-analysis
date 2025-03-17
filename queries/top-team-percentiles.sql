WITH team_percentiles AS (
    SELECT
        CAST(num AS VARCHAR) AS team_number,
        team AS team_name,
        total_points,
        auto_points,
        teleop_points,
        endgame_points,
        -- Calculate percentile ranks for each category
        ROUND(PERCENT_RANK() OVER (ORDER BY total_points) * 100, 1) AS percentile_total_points,
        ROUND(PERCENT_RANK() OVER (ORDER BY auto_points) * 100, 1) AS percentile_auto_points,
        ROUND(PERCENT_RANK() OVER (ORDER BY teleop_points) * 100, 1) AS percentile_teleop_points,
        ROUND(PERCENT_RANK() OVER (ORDER BY endgame_points) * 100, 1) AS percentile_endgame_points
    FROM
        data
),
formatted_results AS (
    SELECT
        team_number,
        team_name,
        total_points,
        percentile_total_points || '%' AS percentile_total_points,
        auto_points,
        percentile_auto_points || '%' AS percentile_auto_points,
        teleop_points,
        percentile_teleop_points || '%' AS percentile_teleop_points,
        endgame_points,
        percentile_endgame_points || '%' AS percentile_endgame_points,
        RANK() OVER (ORDER BY total_points DESC) AS rank_by_total
    FROM
        team_percentiles
)
SELECT
  formatted_results.rank_by_total as "rank",
  team_number,
  team_name,
  total_points,
  percentile_total_points,
  auto_points,
  percentile_auto_points,
  teleop_points,
  percentile_teleop_points,
  endgame_points,
  percentile_endgame_points
FROM formatted_results
WHERE team_number = '4087' OR rank_by_total <= 10
ORDER BY
    CASE WHEN team_number = '4087' THEN 1 ELSE 0 END,
    rank_by_total;
