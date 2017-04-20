
Call Main()

Sub Main()

	'On Error Resume Next

	Dim debug, objFSO, objFile, objFolder
	Dim fileDate, fileFolderPath
	Dim fileYear, fileMonth, fileDay, fileWeekDayName, fileHour, fileMinute, fileSecond	
	Dim newFolder, newPath
	
	debug = 0
	
	Set objFSO = CreateObject ( "Scripting.FileSystemObject" )
	
	'fileFolderPath = "Q:\Users\Cookie\Downloads\20151217-20151217 PC_vbsTest\"
	fileFolderPath = ".\Destination\"
	
	Set objFolder = objFSO.GetFolder ( fileFolderPath )
	
	Set colFiles = objFolder.Files
	
	For Each objFile in colFiles

		'Wscript.Echo objFile.Name

	'Set objFile = objFSO.GetFile ( "C:\Users\Cookie\Downloads\Service Update Announcement.mp4" )
		
		If ( debug = 1 ) Then
		
		'https://msdn.microsoft.com/en-us/library/ea5ht6ax(v=vs.84).aspx
		
			Wscript.Echo _
				"Attributes: " & objFile.Attributes & vbNewLine & _
				"DateCreated: " & objFile.DateCreated & vbNewLine & _
				"DateLastAccessed: " & objFile.DateLastAccessed & vbNewLine & _
				"DateLastModified: " & objFile.DateLastModified & vbNewLine & _
				"Drive: " & objFile.Drive & vbNewLine & _
				"Name: " & objFile.Name & vbNewLine & _
				"ParentFolder: " & objFile.ParentFolder & vbNewLine & _
				"Path: " & objFile.Path & vbNewLine & _
				"ShortName: " & objFile.ShortName & vbNewLine & _
				"ShortPath: " & objFile.ShortPath & vbNewLine & _
				"Size: " & objFile.Size & vbNewLine & _
				"Type: " & objFile.Type & vbNewLine
			
		End If
		
		fileYear = Right ( "0000" & Year ( objFile.DateLastModified ), 4 )
		fileMonth = Right ( "00" & Month ( objFile.DateLastModified ), 2 )
		fileDay = Right ( "00" & Day ( objFile.DateLastModified ), 2 )
		fileWeekDayName = Right ( " " & WeekDayName ( WeekDay ( objFile.DateLastModified ) ), 1 )
		fileHour = Right ( "00" & Hour ( objFile.DateLastModified ), 2 )
		fileMinute = Right ( "00" & Minute ( objFile.DateLastModified ), 2 )
		fileSecond = Right ( "00" & Second ( objFile.DateLastModified ), 2 )
		
		newFolder = objFile.ParentFolder & "\" & fileYear & "-" & fileMonth & "-" & fileDay & " (" & fileWeekDayName & ")"
		
		newPath = objFile.ParentFolder & "\" & fileYear & "-" & fileMonth & "-" & fileDay & " (" & fileWeekDayName & ")\" & objFile.Name
		
		If ( debug = 1 ) Then		
				
			'https://www.w3schools.com/asp/asp_ref_vbscript_functions.asp#date
			'https://www.w3schools.com/asp/func_right.asp

			Wscript.Echo _
				"Modified CDate: " & CDate ( objFile.DateLastModified ) & vbNewLine & _
				"Modified DateValue: " & DateValue ( objFile.DateLastModified ) & vbNewLine & _
				"Modified Day: " & Day ( objFile.DateLastModified ) & vbNewLine & _
				"Modified FormatDateTime: " & FormatDateTime ( objFile.DateLastModified ) & vbNewLine & _
				"Modified Hour: " & Hour ( objFile.DateLastModified ) & vbNewLine & _
				"Modified IsDate: " & IsDate ( objFile.DateLastModified ) & vbNewLine & _
				"Modified Minute: " & Minute ( objFile.DateLastModified ) & vbNewLine & _
				"Modified Month: " & Month ( objFile.DateLastModified ) & vbNewLine & _
				"Modified Second: " & Second ( objFile.DateLastModified ) & vbNewLine & _
				"Modified TimeValue: " & TimeValue ( objFile.DateLastModified ) & vbNewLine & _
				"Modified Weekday: " & Weekday ( objFile.DateLastModified ) & vbNewLine & _
				"Modified Year: " & Year ( objFile.DateLastModified )& vbNewLine & vbNewLine & _
				"fileYear: " & fileYear & vbNewLine & _
				"fileMonth: " & fileMonth & vbNewLine & _
				"fileDay: " & fileDay & vbNewLine & _
				"fileWeekDayName: " & fileWeekDayName & vbNewLine & _
				"fileHour: " & fileHour & vbNewLine & _
				"fileMinute: " & fileMinute & vbNewLine & _
				"fileSecond: " & fileSecond & vbNewLine & vbNewLine & _
				"newFolder: " & newFolder & vbNewLine & vbNewLine & _
				"folderexists: " & objFSO.folderexists ( srcCFolderPath ) & vbNewLine & _
				"oldPath: " & objFile.Path & vbNewLine & vbNewLine & _
				"newPath: " & newPath & vbNewLine			
		End If

		If objFSO.folderexists ( newFolder ) = False Then

			objFSO.CreateFolder newFolder

		End If
		
		objFSO.MoveFile objFile.Path, newPath
	
	Next

	Set colFiles = Nothing
	Set objFolder = Nothing
	Set objFSO = Nothing
	
End Sub