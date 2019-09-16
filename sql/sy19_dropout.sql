-- CPS schools with d/o >= 25% during SY19
SELECT profile.school_id, profile.community, dropout.*
FROM cps_sy1819_cca AS profile
JOIN cps_dropout_rate_2011_2019 AS dropout
ON profile.school_id = dropout.school_id
WHERE dropout.dropout_rate >= 25 AND dropout.school_year = 2019;
