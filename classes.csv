SELECT DISTINCT 
    CAST(vc.FileYear AS varchar) + '_' + REPLACE(vc.ClassCode, ' ', '') AS 'sourcedId', 
    cfg.Value AS 'orgSourcedId', 
    REPLACE(REPLACE(REPLACE(vc.ClassDescription + ' (' + vc.ClassCode + ')', '&', 'and'), ':', '-'), '  ', ' ') AS 'title', 
    CAST(vc.FileYear AS varchar) + 'S' + CAST(vc.FileSemester AS varchar) AS 'sessionSourcedId', 
    '' AS courseSourceID
FROM dbo.vStudentClasses vc
LEFT JOIN dbo.FileSemesters fs ON fs.FileSemester = vc.FileSemester AND fs.FileYear = vc.FileYear
LEFT JOIN dbo.Config cfg ON cfg.Key1 = 'ExternalSystem' AND cfg.Key2 = 'MCEETYA' AND cfg.Key3 = 'SchoolCodeACARA'
WHERE vc.StudentYearLevel >= 4 AND fs.SystemCurrentFlag = 1 AND vc.StopDate IS NULL;
