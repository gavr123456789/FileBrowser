using Gee;

public class DirectoryNavigator{

    public DirectoryNavigator() {
        get_files_names();
    }

    public PathHelper path_helper = new PathHelper();
    public FolderHelper folder_helper = new FolderHelper();
    public FileHelper file_helper = new FileHelper();
    public string path { owned get { return path_helper.get_full(); }}

    HashSet<string> dirs_search = new HashSet<string>(); 
    ArrayList<string> dirs = new ArrayList<string>();
    ArrayList<string> files = new ArrayList<string>();


    public bool goto(string dir){
        if(dir in dirs_search){
            path_helper.append(dir);
            message(@"goto $dir");
            prin(Log.METHOD," ", dir);
            get_files_names();
            return true;
        } else {
            prin(path_helper);
            error(@"no such directory: $dir");
        }
    }

    public void go_back(){
        path_helper.remove();
        get_files_names();
    }

    //Updates dirs and files with dirs and files in current dir
    public void get_files_names() {
        //  var timer = new Timer();
        try {
            Dir dir = Dir.open (path, 0);
            string? name = null;
            dirs_search.clear();
            dirs.clear();
            files.clear();
    
            while ((name = dir.read_name ()) != null) {
                string path = Path.build_filename (path, name);
                if (FileUtils.test (path, FileTest.IS_REGULAR)) {
                    files.add(Filename.display_basename(path) + " REGULAR ");
                }
    
                if (FileUtils.test (path, FileTest.IS_SYMLINK)) {
                }
    
                if (FileUtils.test (path, FileTest.IS_DIR)) {
                    dirs.add(Filename.display_basename(path));
                    dirs_search.add(Filename.display_basename(path));
                }
                if (FileUtils.test (path, FileTest.IS_EXECUTABLE)) {
                }
            }
        } catch (FileError err) {
            stderr.printf (err.message);
        }
        //  prin(Log.METHOD, " ",timer.elapsed());
    }

    public void print(){
        prin("\033[1;34m");
        int i;
        for (i = 0; i < dirs.size; i++){
            prin(i, ". ", dirs[i]);
        }
        prin("\033[0m");
        for (int j = 0; j < files.size; j++){
            prin(i + j, ". ", files[j]);
        }
    }

    public string[] get_names(){
        string[] names = {};
        int i;

        for (i = 0; i < dirs.size; i++)
            names += dirs[i];
        for (int j = 0; j < files.size; j++)
            names += files[j];
        return names;
    }

    public string to_string(){
        var builder = new StringBuilder();
        foreach (var file in dirs_search)
            builder.append(file + "\n");
        var s = builder.str;
        return s;
    }
}


public class PathHelper {
    public PathHelper(){
        path.add(Environment.get_home_dir());
    }
    ArrayList<string> path = new ArrayList<string>();
    public void append(string s) { path.add(Path.DIR_SEPARATOR_S + s); }
    public void remove()         { path.remove_at(path.size - 1); }
    public int size { get{ return path.size; } }

    public inline string get_full(){
        var builder = new StringBuilder();
        foreach(var a in path){
            builder.append(a);
        }
        return builder.str;
    }
    public string to_string(){
        return get_full();
    }
}

[Compact]
public class FolderHelper{
    public void create_folder(owned string path, owned string folder_name){
        prin(Path.build_path(Path.DIR_SEPARATOR_S, path, folder_name));
        var builded_path = Path.build_path(Path.DIR_SEPARATOR_S, path, folder_name);
        var result = DirUtils.create_with_parents(builded_path, 0755);
        prin(result == 0? "folder created":"failed");
    }
}

[Compact]
public class FileHelper {
    public void delete_file(string path, string file_name){
        message(@"removing $(Path.build_path(path,file_name))");
        FileUtils.remove(Path.build_path(path, file_name));
    }
}



[Print] public void prin(string s){stdout.printf(s + "\n");}