/* 1. The number of sessions filled by type of temp cover by month. */
SELECT COUNT(fact_sessions.sessionid), fact_sessions.typeofcover, dim_time.Month
FROM fact_sessions
INNER JOIN dim_time ON fact_sessions.timeid = dim_time.timeid
GROUP BY dim_time.month, fact_sessions.typeofcover
ORDER BY dim_time.month;

/* 2. The number of temp care worker requests made by council for each week. */
SELECT COUNT(fact_sessions.temprequestid), dim_local_council.councilname, dim_time.week
FROM fact_sessions
INNER JOIN dim_temp_request ON fact_sessions.temprequestid = dim_temp_request.temprequestid
INNER JOIN dim_local_council ON dim_temp_request.localcouncilid = dim_local_council.localcouncilid
INNER JOIN DIM_TIME ON fact_sessions.timeid = dim_time.timeid
GROUP BY dim_local_council.councilname, dim_time.week
ORDER BY dim_time.week;

/* 3. The number of temp care worker requests filled by county for each month. */
SELECT COUNT(fact_sessions.temprequestid)AS "REQUESTS",dim_local_council.county,dim_time.month
FROM fact_sessions
INNER JOIN dim_temp_request ON fact_sessions.temprequestid = dim_temp_request.temprequestid
INNER JOIN dim_local_council ON dim_temp_request.localcouncilid = dim_local_council.localcouncilid
INNER JOIN DIM_TIME ON fact_sessions.timeid = dim_time.timeid
WHERE NOT fact_sessions.status = 'cancelled'
GROUP BY dim_local_council.county,dim_time.month, fact_sessions.status
ORDER BY dim_time.month;

/* 4. The number of temp care worker requests filled by council each week. */
SELECT COUNT(fact_sessions.temprequestid) AS "REQUESTS",dim_local_council.councilname,dim_time.week
FROM fact_sessions
INNER JOIN dim_temp_request ON fact_sessions.temprequestid = dim_temp_request.temprequestid
INNER JOIN dim_local_council ON dim_temp_request.localcouncilid = dim_local_council.localcouncilid
INNER JOIN DIM_TIME ON fact_sessions.timeid = dim_time.timeid
WHERE NOT fact_sessions.status = 'cancelled'
GROUP BY dim_local_council.councilname, dim_time.week, fact_sessions.status 
ORDER BY dim_time.week;

/* 5. The number of temp care worker requests which were cancelled each month. */
SELECT COUNT(fact_sessions.temprequestid)AS "CANCELLED REQUESTS",dim_time.month,fact_sessions.status
FROM fact_sessions
INNER JOIN dim_temp_request ON fact_sessions.temprequestid = dim_temp_request.temprequestid
INNER JOIN DIM_TIME ON fact_sessions.timeid = dim_time.timeid
WHERE fact_sessions.status = 'cancelled'
GROUP BY dim_time.month, fact_sessions.status 
ORDER BY dim_time.month;

/* BONUS. The average length of a session cover by month. */
CREATE MATERIALIZED VIEW Avg_sessionlength
BUILD IMMEDIATE     
REFRESH ON DEMAND 
ENABLE QUERY REWRITE
AS
SELECT fact_sessions.typeofcover, round(AVG(((se_hour*60+se_minute)-(ss_hour*60+ss_minute)))) AS "LENGTH(MINUTES)", dim_time.month
FROM dim_time
INNER JOIN fact_sessions ON dim_time.timeid = fact_sessions.timeid 
GROUP BY fact_sessions.typeofcover, dim_time.month
ORDER BY dim_time.month;