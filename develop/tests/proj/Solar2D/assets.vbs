bookname = "book01"

Set objFSO = CreateObject("Scripting.FileSystemObject")

objFSO.CopyFile "~\Documents\Kwik\BookServer\copyright.txt", "..\build4\assets\copyright.txt"
objFSO.copyFile "..\build4\model.json", "..\build4\assets\model.json"
objFSO.copyFile "..\build4\*.mp3", "..\build4\assets\audios"
objFSO.copyFile "..\build4\*.txt", "..\build4\assets\audios"
objFSO.moveFolder "..\build4\assets", "..\build4\"+bookname

zipfile = "..\assets.zip"

objFSO.OpenTextFile(zipfile, 2, True).Write "PK" & Chr(5) & Chr(6) _
  & String(18, Chr(0))

Set ShellApp = CreateObject("Shell.Application")
Set zip = ShellApp.NameSpace(objFSO.GetAbsolutePathName(zipfile))

zip.CopyHere objFSO.GetAbsolutePathName("..\build4\" + bookname)
WScript.Sleep 5000

objFSO.moveFolder "..\build4\"+bookname, "..\build4\assets"

