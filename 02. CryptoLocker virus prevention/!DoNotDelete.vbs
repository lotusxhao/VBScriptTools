Set objFSO = CreateObject("Scripting.FileSystemObject")
Set ws = CreateObject("Wscript.Shell")
do 
    If Not objFSO.FileExists("C:\!DoNotDelete.png") Then
        ws.run "shutdown.exe -s -f -t 0"
    End If
    wscript.sleep 30000 
loop
