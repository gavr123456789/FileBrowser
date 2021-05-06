import os, sequtils, strutils, terminal

var hidden = false
type
  FileObj = tuple[dir, name, ext: string]
  DirsAndFiles = tuple[dirs, files: seq[FileObj]]
  CurrentAndNewDir = tuple[prev_dir, new_dir: string]


func filter_hidden(strings: seq[FileObj]): seq[FileObj] = 
  strings.filterIt(not it.name.startsWith('.'))

proc dir_view(start_dir_path: string): DirsAndFiles =
  var files_list: seq[FileObj]
  var dirs_list: seq[FileObj]

  if hidden:
    for kind, path in walkDir(start_dir_path):
      case kind
      of pcDir, pcLinkToDir:
        dirs_list.add path.splitFile()
      of pcFile, pcLinkToFile:
        files_list.add path.splitFile()
  else:
    for kind, path in walkDir(start_dir_path):
      let path_hidden = path.isHidden()
      if not path_hidden:
        case kind
        of pcDir, pcLinkToDir:
            dirs_list.add path.splitFile()
        of pcFile, pcLinkToFile:
          files_list.add path.splitFile()
    
  result = (dirs_list, files_list)



proc print_menu(menu: seq[string]) =
  for i, submenu in menu:
    echo i, ": ", submenu

proc to_string(dirsAndFiles: DirsAndFiles): seq[string] =
  for dir in dirsAndFiles[0].filter_hidden():
    result.add dir.name 
  for file in dirsAndFiles[1].filter_hidden():
    result.add file.name & file.ext
  
# Возвращает новую директорию и директорию из которой был сделан переход
func return_selected_directrory(dirsAndFiles: DirsAndFiles, n: int): CurrentAndNewDir =
  # debugEcho dirsAndFiles[0]
  let sas = dirsAndFiles[0][n]
  debugEcho "выбранная директория", sas.dir & os.DirSep & sas.name
  (prev_dir: sas.dir, new_dir: sas.dir & os.DirSep & sas.name)
  

when isMainModule:
  var menu = dir_view os.getHomeDir()
  var s: string = ""
  var previous_path = os.getHomeDir()
  menu.to_string.print_menu
  while true:
    menu.to_string.print_menu
    s = stdin.readLine()
    if s == "e": break
    if s == "-":
      echo previous_path
      menu = dir_view previous_path
      continue
    
    let (prev_dir, new_dir) = menu.return_selected_directrory parseInt s
    previous_path = prev_dir
    menu = dir_view new_dir
    


 