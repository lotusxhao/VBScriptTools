
Wscript.Echo _
	"Shutdown and Change to another OS!" & srcCopyFolder & vbNewLine

Set ws = CreateObject("Wscript.Shell")

' Use Shell.Application to run as Administrator
Set objAPP = CreateObject("Shell.Application")

' OS_01, you should change your own OS ID following between "{" and "}".
'objAPP.ShellExecute "bcdedit.exe", "/default {xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx}",, "runas", 0

' OS_02, you should change your own OS ID following between "{" and "}".
objAPP.ShellExecute "bcdedit.exe", "/default {xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx}",, "runas", 0

Set objAPP = Nothing

ws.run "shutdown.exe /s /f /t 0", 0, false

Set ws = Nothing