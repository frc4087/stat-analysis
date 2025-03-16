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
total_results as (
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
      percentile_endgame_points || '%' AS percentile_endgame_points
  FROM
      team_percentiles
)
(SELECT * FROM total_results WHERE team_number = 4087
AND team_number NOT IN (SELECT team_number FROM total_results ORDER BY total_points DESC LIMIT 10))
UNION ALL
(SELECT * FROM total_results ORDER BY total_points DESC LIMIT 10);
