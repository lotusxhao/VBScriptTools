
Dim debug, i, totalSpeed, n, warning, warningString, tempLine, arrFileLines(), lowBound
Dim powerScript, mailTo, mailFrom

Dim objFSO, recentFile, matches, objFile, regex

Do While True

'------------------------- �ϥΪ̩w�q�� -------------------------

	' �]�w Total Speed �����e�ȡA�C����e�ȧY�H�iĵ�H�C
	totalSpeed = 90.0

	' �]�w�������j�]���G�����A�C�������|�l�� CPU�A��ĳ���n�C�� 5 �����^ 
	scanFrequency = 15
	
	' ����H
	mailTo = "to@gmail.com"
	
	' �H��H�]�H�c�ݶ}�q SMTP �~�H�l��\��^
	mailFrom = "from@gmail.com"

'------------------------- �ϥΪ̩w�q�� -------------------------


	
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	Set ws = CreateObject ( "Wscript.Shell" )
	Set recentFile = Nothing	

	Set nw = CreateObject("WScript.Network")
	
	i = 0
	n = 10
	warning = 0
	warningString = "�������q�� " & nw.ComputerName & " �� Total Speed �C��ϥΪ̩ҳ]�m�����e�� " & totalSpeed & " Mh/s�A�̪񪺤Q����Ʀp�U�G" & vbNewLine & vbNewLine
	debug = 0
	
	powerScript = "powershell.exe Get-Credential �VCredential '" & mailFrom & "' | Export-Clixml '.\_mail_password.xml'"

	If ( debug = 1 ) Then
		Wscript.Echo powerScript
	End If

	
	' �N Mail �b�K�s�X�x�s�� _mail_password.xml �ɤ��A���P�q���u�ݰ���@���C
	If NOT ( objFSO.FileExists ( ".\_mail_password.xml" ) ) Then
	  ' TRUE = Wait for completion
	  ws.Run ( powerScript ), 0, TRUE
	End If
	
	For Each f in objFSO.GetFolder(".\").Files
		If Right ( LCase ( f.Name ), 8) = "_log.txt" Then
			If (recentFile is Nothing) Then
				Set recentFile = f
			ElseIf (f.DateLastModified > recentFile.DateLastModified) Then
				Set recentFile = f
			End If
		End If
	Next

	If recentFile is Nothing Then

		If ( debug = 1 ) Then
			WScript.Echo "no recent files"
		End If
	Else
		
		If ( debug = 1 ) Then
			Wscript.Echo "recently file = " & recentFile.Name
		End If

		objFSO.CopyFile ".\" & recentFile.Name, ".\_temp.txt", TRUE 

		' 1 = ForReading
		Set objFile = objFSO.OpenTextFile ( ".\_temp.txt", 1 )

		Do Until objFile.AtEndOfStream
			tempLine = objFile.ReadLine
			If ( instr ( tempLine, "GPU0 t=" ) <> 0 ) OR ( instr ( tempLine, "ETH - Total Speed: " ) <> 0 ) OR ( instr ( tempLine, "ETH: GPU0 " ) <> 0 ) Then
				 Redim Preserve arrFileLines ( i )
				 arrFileLines ( i ) = tempLine
				 i = i + 1
			End If
		Loop

		objFile.Close

		If Ubound(arrFileLines) < 10 Then
			lowBound = LBound(arrFileLines)
		Else
			lowBound = Ubound(arrFileLines) - 10
		End If
		
		If ( debug = 1 ) Then
			WScript.Echo "up bound = " & Ubound(arrFileLines) & vbNewLine & "low bound = " & lowBound
		End If
		
		For i = Ubound(arrFileLines) to lowBound Step -1
		
		If ( debug = 1 ) Then
			Wscript.Echo "i = " & i
		End If
		
			Set regex = CreateObject("VBScript.RegExp")
			' ����Ӧr�ꤤ�Ҧ��ŦX������
			regex.Global = True
			'�Ϥ��j�p�g�C
			regex.IgnoreCase = False
			regex.Pattern = " [0-9]{1,9}.[0-9]{3} "
		
			If ( instr ( arrFileLines ( i ), "ETH - Total Speed: " ) <> 0 ) AND ( warning <> 1 ) Then
				Set matches = regex.Execute ( arrFileLines ( i ) ) ' ����j���C		
					If CDbl ( matches(0) ) < CDbl ( totalSpeed ) Then
						warning = 1
					End If
				Set matches = Nothing		
			End If
			
			If ( warning = 1 ) AND ( n > 0 ) Then
				warningString = warningString & arrFileLines ( i ) & vbNewLine
				n = n - 1
				
				If ( debug = 1 ) Then
					Wscript.Echo "n = " & n & vbNewLine & "i = " & i & vbNewLine & "arrFileLines ( i ) = " & vbNewLine & arrFileLines ( i )
				End If
				
			ElseIf ( n = 0 ) Then
				Exit For
			End If
		Next
		
		warningString = warningString & vbNewLine & "���u��� oneleo �Ч@�A�w������ûݵ����X�B�A�T��ӷ~�ϥΡC" & vbNewLine & "�Y�ݭק�{���X�A�ЫO�d��l���v�A�w��� https://steemit.com/@oneleo �d���Q��"
		
		If ( debug = 1 ) Then
			Wscript.Echo warningString
		End If

		If ( warning = 1 ) Then
			powerScript = "powershell.exe -Command ""Send-MailMessage -To '" & mailTo & "' -Subject '[Auto mail] Mining Warning' -Body '" & warningString & "' -SmtpServer 'smtp.gmail.com' -From '" & mailFrom & "' -Port 587 -UseSsl -Credential ( Import-Clixml .\_mail_password.xml ) -Encoding UTF8"""

			If ( debug = 1 ) Then
				Wscript.Echo powerScript
			End If

			ws.Run ( powerScript ), 0, TRUE
		End If

	End If

	Erase arrFileLines
	Set objFile = Nothing
	Set nw = Nothing
	Set recentFile = Nothing
	Set ws = Nothing
	Set objFSO = Nothing
	Set regex = Nothing
	
	If debug = 1 Then
		wscript.sleep ( 1 * 1000 )
	Else
		wscript.sleep ( scanFrequency * 60 * 1000 )
	End If
	
Loop