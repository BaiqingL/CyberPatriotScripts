strFileName = "C:\scripts\center\test.txt"
Set objWMIService = GetObject("winmgmts:")
Set objFileSecuritySettings = _
objWMIService.Get("Win32_LogicalFileSecuritySetting='" & strFileName & "'")
intRetVal = objFileSecuritySettings.GetSecurityDescriptor(objSD)

If intRetVal = 0 Then
WScript.Echo "Owner: " & objSD.Owner.Domain & "\" & objSD.Owner.Name
Else
WScript.Echo "Couldn't retrieve security descriptor."
End If
