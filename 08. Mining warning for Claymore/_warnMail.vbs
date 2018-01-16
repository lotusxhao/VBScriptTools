
Dim debug, i, totalSpeed, n, warning, warningString, tempLine, arrFileLines(), lowBound
Dim powerScript, mailTo, mailFrom

Dim objFSO, recentFile, matches, objFile, regex

Do While True

'------------------------- 使用者定義區 -------------------------

	' 設定 Total Speed 的門檻值，低於門檻值即寄告警信。
	totalSpeed = 90.0

	' 設定偵測間隔（單位：分鐘，每次偵測會損耗 CPU，建議不要低於 5 分鐘） 
	scanFrequency = 15
	
	' 收件人
	mailTo = "to@gmail.com"
	
	' 寄件人（信箱需開通 SMTP 外寄郵件功能）
	mailFrom = "from@gmail.com"

'------------------------- 使用者定義區 -------------------------


	
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	Set ws = CreateObject ( "Wscript.Shell" )
	Set recentFile = Nothing	

	Set nw = CreateObject("WScript.Network")
	
	i = 0
	n = 10
	warning = 0
	warningString = "偵測到礦機 " & nw.ComputerName & " 的 Total Speed 低於使用者所設置的門檻值 " & totalSpeed & " Mh/s，最近的十筆資料如下：" & vbNewLine & vbNewLine
	debug = 0
	
	powerScript = "powershell.exe Get-Credential –Credential '" & mailFrom & "' | Export-Clixml '.\_mail_password.xml'"

	If ( debug = 1 ) Then
		Wscript.Echo powerScript
	End If

	
	' 將 Mail 帳密編碼儲存到 _mail_password.xml 檔中，不同電腦只需執行一次。
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
			' 比對整個字串中所有符合的項目
			regex.Global = True
			'區分大小寫。
			regex.IgnoreCase = False
			regex.Pattern = " [0-9]{1,9}.[0-9]{3} "
		
			If ( instr ( arrFileLines ( i ), "ETH - Total Speed: " ) <> 0 ) AND ( warning <> 1 ) Then
				Set matches = regex.Execute ( arrFileLines ( i ) ) ' 執行搜索。		
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
		
		warningString = warningString & vbNewLine & "本工具由 oneleo 創作，歡迎轉載並需註明出處，禁止商業使用。" & vbNewLine & "若需修改程式碼，請保留原始授權，歡迎到 https://steemit.com/@oneleo 留言討論"
		
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