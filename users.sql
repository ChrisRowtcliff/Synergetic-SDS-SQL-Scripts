SELECT
    [Id] AS 'sourcedId',
    '' AS familyName,
    '' AS givenName,
    [StudentNetworkLogin] + '@school.edu.au' AS 'username',
    [StudentOccupEmail] AS 'email',
    [StudentNetworkLogin] + '@school.edu.au' AS 'activeDirectoryMatchId',
    '' AS 'password',
    '' AS phone,
    '' AS sms
FROM vStudents
INNER JOIN FileSemesters ON FileSemesters.FileSemester = vStudents.FileSemester AND FileSemesters.FileYear = vStudents.FileYear
WHERE FileSemesters.SystemCurrentFlag = 1 AND LEN([StudentOccupEmail]) > 0 AND vStudents.StudentYearLevel >= 4

UNION ALL

SELECT DISTINCT
    vStaff.[StaffId] AS 'sourcedId',
    vstaff.[staffsurname] AS familyName,
    vstaff.[StaffGiven1] AS givenName,
    [NetworkLogin] + '@school.edu.au' AS 'username',
    [StaffOccupEmail] AS 'email',
    [NetworkLogin] + '@school.edu.au' AS 'activeDirectoryMatchId',
    '' AS 'password',
    vStaff.StaffExtension AS phone,
    '' AS sms
FROM vSubjectClassesStaff
INNER JOIN Community ON Community.ID = vSubjectClassesStaff.StaffID
INNER JOIN FileSemesters ON FileSemesters.FileSemester = vSubjectClassesStaff.FileSemester AND FileSemesters.FileYear = vSubjectClassesStaff.FileYear
INNER JOIN vStaff ON vStaff.StaffID = vSubjectClassesStaff.StaffID
WHERE FileSemesters.SystemCurrentFlag = 1 AND vSubjectClassesStaff.StaffID IS NOT NULL AND vSubjectClassesStaff.FileType = 'A' AND EXISTS (
    SELECT 1
    FROM vStudentClasses
    WHERE vStudentClasses.StudentYearLevel >= 4 AND vStudentClasses.ClassCode = vSubjectClassesStaff.ClassCode
);
