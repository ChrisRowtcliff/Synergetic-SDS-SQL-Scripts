SELECT TOP (1)
    c1.Value AS 'sourcedId',
    c2.Value AS 'name',
    'School' AS 'type',
    NULL AS parentSourcedId
FROM dbo.Config AS c1
JOIN dbo.Config AS c2 ON c1.Key1 = c2.Key1 AND c1.Key2 = c2.Key2
WHERE c1.Key1 = 'ExternalSystem'
    AND c1.Key2 = 'MCEETYA'
    AND c1.Key3 = 'SchoolCodeACARA'
    AND c2.Key3 = 'SchoolName'
