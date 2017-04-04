Dim wshShell
Dim hours, minutes, seconds, avermediaDelaySecond, humanDelaySecond
Dim shutdown

hours = 01
minutes = 27
seconds = 23
shutdown = 0

avermediaDelaySecond = 5
humanDelaySecond = 60

wscript.sleep ( 2 * 1000 )

Set wshShell = CreateObject("Wscript.Shell")

wshShell.AppActivate "RECentral"
wscript.sleep ( 250 )
wshShell.SendKeys "{F7}"

wscript.sleep ( ( hours * 60 * 60 * 1000 ) + ( minutes * 60 * 1000 ) + ( seconds * 1000 ) + ( avermediaDelaySecond * 1000 ) + ( humanDelaySecond * 1000 ) )

wshShell.AppActivate "RECentral"
wscript.sleep ( 250 )
wshShell.SendKeys "{F7}"
wscript.sleep ( ( avermediaDelaySecond * 1000 ) )
wshShell.AppActivate "RECentral"
wscript.sleep ( 250 )
wshShell.SendKeys "%{F4}"
wscript.sleep ( ( avermediaDelaySecond * 1000 ) )
wshShell.AppActivate "RECentral"
wscript.sleep ( 250 )
wshShell.SendKeys "%{F4}"
wscript.sleep ( ( avermediaDelaySecond * 1000 ) )

If shutdown = 1 Then
	wshShell.run "shutdown.exe /s /f /t 0", 0, false
End If

Set wshShell = Nothing