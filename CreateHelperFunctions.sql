-- Returns 1 if two day strings share at least one common day
CREATE FUNCTION dbo.fn_DaysOverlap
(
    @days1 VARCHAR(100),
    @days2 VARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM STRING_SPLIT(@days1, '/') d1
        INNER JOIN STRING_SPLIT(@days2, '/') d2
            ON d1.value = d2.value
    )
        RETURN 1;
    RETURN 0;
END;