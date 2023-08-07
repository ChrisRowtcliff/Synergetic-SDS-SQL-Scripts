SELECT
    [Id] AS 'userSourcedId',
    Config.[Value] AS 'orgSourcedId',
    'Student' AS 'role',
    CAST(FileSemesters.FileYear AS varchar) + 'S' + CAST(FileSemesters.FileSemester AS varchar) AS 'sessionSourcedId',
    CASE WHEN LEN(CAST([StudentYearLevel] AS varchar)) < 2 THEN '0' + CAST([StudentYearLevel] AS varchar) ELSE CAST([StudentYearLevel] AS varchar) END AS 'grade',
    '' AS isPrimary,
    '' AS roleStartDate,
    '' AS roleEndDate
FROM vStudents
LEFT JOIN FileSemesters ON FileSemesters.FileSemester = vStudents.FileSemester AND FileSemesters.FileYear = vStudents.FileYear AND FileSemesters.SystemCurrentFlag = 1
LEFT JOIN Config ON Config.Key1 = 'ExternalSystem' AND Config.Key2 = 'MCEETYA' AND Config.Key3 = 'SchoolCodeACARA'
WHERE FileSemesters.SystemCurrentFlag = 1
    AND LEN([StudentOccupEmail]) > 0 AND StudentYearLevel >= 4 

UNION ALL

SELECT
    vStaff.[StaffId] AS 'userSourcedId',
    Config.[Value] AS 'orgSourcedId',
    'Teacher' AS 'role',
    CAST(FileSemesters.FileYear AS varchar) + 'S' + CAST(FileSemesters.FileSemester AS varchar) AS 'sessionSourceId',
    NULL AS 'grade',
    '' AS isPrimary,
    '' AS roleStartDate,
    '' AS roleEndDate
FROM vStaff
LEFT JOIN FileSemesters ON FileSemesters.SystemCurrentFlag = 1
LEFT JOIN Config ON Config.Key1 = 'ExternalSystem' AND Config.Key2 = 'MCEETYA' AND Config.Key3 = 'SchoolCodeACARA'
WHERE vStaff.ActiveFlag = 1
    AND EXISTS (
        SELECT 1
        FROM vStudentClasses
        INNER JOIN FileSemesters ON FileSemesters.FileYear = vStudentClasses.FileYear AND FileSemesters.FileSemester = vStudentClasses.FileSemester AND FileSemesters.SystemCurrentFlag = 1
        WHERE vStudentClasses.StudentYearLevel >= 4 AND vStudentClasses.StaffID = vStaff.StaffID
    )
    AND LEN(StaffOccupEmail) > 0;
