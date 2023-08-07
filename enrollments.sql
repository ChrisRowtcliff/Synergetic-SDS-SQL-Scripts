SELECT
    CAST(vc1.FileYear AS varchar) + '_' + REPLACE(vc1.ClassCode, ' ', '') AS classSourcedId,
    vc1.StudentId AS 'userSourcedId',
    'Student' as 'role'
FROM vStudentClasses vc1
LEFT JOIN FileSemesters fs1 ON fs1.FileSemester = vc1.FileSemester AND fs1.FileYear = vc1.FileYear
WHERE vc1.StudentYearLevel >= 4 AND fs1.SystemCurrentFlag = 1 AND vc1.StopDate IS NULL

UNION ALL

SELECT
    CAST(vc2.FileYear AS varchar) + '_' + REPLACE(vc2.ClassCode, ' ', '')  AS classSourcedId,
    vc2.StaffID AS 'userSourcedId',
    'Teacher' as 'role'
FROM vSubjectClassesStaff vc2
LEFT JOIN FileSemesters fs2 ON fs2.FileSemester = vc2.FileSemester AND fs2.FileYear = vc2.FileYear
INNER JOIN uvADAllusers au ON ISNUMERIC(au.EmployeeID) = 1 AND au.employeeId = vc2.StaffID AND au.Type = 'STAFF'
WHERE fs2.SystemCurrentFlag = 1 AND vc2.StaffID IS NOT NULL AND vc2.FileType = 'A' 
  AND EXISTS (
    SELECT 1
    FROM vStudentClasses vc3
    WHERE vc3.StudentYearLevel >= 4 AND vc3.ClassCode = vc2.ClassCode
);
