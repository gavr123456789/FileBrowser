import os, sequtils, strutils, terminal

var hidden = false
type
  StructUnit = tuple[dir, name, ext: string]
  DirsAndUnites = tuple[dirs, files: seq[StructUnit]]
  CurrentAndNewDir = tuple[prev_dir, new_dir: string]


func filter_hidden_files(files: seq[StructUnit]): seq[StructUnit] = 
  files.filterIt(not it.name.startsWith('.'))

proc dir_view(start_dir_path: string): DirsAndUnites =
  var files_list: seq[StructUnit]
  var dirs_list: seq[StructUnit]

  if hidden:
    for kind, path in walkDir(start_dir_path):
      case kind
      of pcDir, pcLinkToDir:
        dirs_list.add path.splitFile()
      of pcFile, pcLinkToFile:
        files_list.add path.splitFile()
  else:
    for kind, path in walkDir(start_dir_path):
      if not path.isHidden():
        case kind
        of pcDir, pcLinkToDir:
            dirs_list.add path.splitFile()
        of pcFile, pcLinkToFile:
          files_list.add path.splitFile()
    
  result = (dirs_list, files_list)

proc print_menu(menu: seq[string]) =
  for i, submenu in menu:
    echo i, ": ", submenu

proc to_string(dirsAndFiles: DirsAndUnites): seq[string] =
  for dir in dirsAndFiles[0].filter_hidden_files():
    result.add dir.name 
  for file in dirsAndFiles[1].filter_hidden_files():
    result.add file.name & file.ext
  
# Возвращает новую директорию и директорию из которой был сделан переход
func goto_selected_dir(dirsAndFiles: DirsAndUnites, n: int): CurrentAndNewDir =
  let unit = dirsAndFiles.dirs[n]
  debugEcho "выбранная директория: ", unit.dir & os.DirSep & unit.name
  (prev_dir: unit.dir, new_dir: unit.dir & os.DirSep & unit.name)


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
    
    let (prev_state, new_state) = menu.goto_selected_dir parseInt s
    previous_path = prev_state
    menu = dir_view new_state
    


 