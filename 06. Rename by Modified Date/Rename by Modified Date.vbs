
Call Main()

Sub Main()

	'On Error Resume Next

	Dim debug, objFSO, objFile, objFolder
	Dim fileDate, fileFolderPath
	Dim fileYear, fileMonth, fileDay, fileWeekDayName, fileHour, fileMinute, fileSecond	
	Dim newFileName
	
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
		
		'newPath = objFile.ParentFolder & "\" & Left ( objFile.Name, 8 ) & "[" & fileYear & fileMonth & fileDay & "][" & fileWeekDayName & "][" & fileHour & fileMinute & "]" & Mid ( objFile.Name, 9 )
		newPath = objFile.ParentFolder & "\" & "[" & fileYear & fileMonth & fileDay & "][" & fileWeekDayName & "][" & fileHour & fileMinute & "]" & objFile.Name
		
		If ( debug = 1 ) Then
		
			Wscript.Echo _
				"fileYear: " & fileYear & vbNewLine & _
				"fileMonth: " & fileMonth & vbNewLine & _
				"fileDay: " & fileDay & vbNewLine & _
				"fileWeekDayName: " & fileWeekDayName & vbNewLine & _
				"fileHour: " & fileHour & vbNewLine & _
				"fileMinute: " & fileMinute & vbNewLine & _
				"fileSecond: " & fileSecond & vbNewLine & _
				"newPath: " & newPath & vbNewLine			
		End If
	
		objFSO.MoveFile objFile.Path, newPath
	
	Next

	Set colFiles = Nothing
	Set objFolder = Nothing
	Set objFSO = Nothing
	
End Sub