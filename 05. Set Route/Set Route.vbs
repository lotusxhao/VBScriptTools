
Wscript.Echo _
	"Set Route!" & srcCopyFolder & vbNewLine

' Use Shell.Application to run as Administrator
Set objAPP = CreateObject("Shell.Application")
objAPP.ShellExecute "route.exe", "delete 0.0.0.0 mask 0.0.0.0 192.168.1.1 metric 10",, "runas", 0

Set objAPP = Nothing