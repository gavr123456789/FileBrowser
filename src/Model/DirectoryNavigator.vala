using Gee;

public class DirectoryNavigator{

    public DirectoryNavigator() {
        get_files_names();
    }

    PathHelper path = new PathHelper();

    HashSet<string> dirs_search = new HashSet<string>(); 
    ArrayList<string> dirs = new ArrayList<string>();
    ArrayList<string> files = new ArrayList<string>();

    public bool goto(string dir){
        if(dir in dirs_search){
            path.append(dir);
            message(@"goto $dir");
            get_files_names();
            return true;
        } else {
            prin(path);
            error(@"no such directory: $dir");
            //  return false;
        }
    }
    public void go_back(){
        path.remove();
        get_files_names();
    }

    string directory { owned get { return path.get_full(); }}

    //Updates dirs and files with dirs and files in current dir
    public string[] get_files_names() {
        try {
            Dir dir = Dir.open (directory, 0);
            string? name = null;
            dirs_search.clear();
            dirs.clear();
            files.clear();
    
            while ((name = dir.read_name ()) != null) {
                string path = Path.build_filename (directory, name);
                string type = "";
    
                if (FileUtils.test (path, FileTest.IS_REGULAR)) {
                    type += "| REGULAR ";
                    files.add(Filename.display_basename(path) + " REGULAR ");
                }
    
                if (FileUtils.test (path, FileTest.IS_SYMLINK)) {
                    type += "| SYMLINK ";
                }
    
                if (FileUtils.test (path, FileTest.IS_DIR)) {
                    type += "| DIR ";
                    dirs.add(Filename.display_basename(path));
                    dirs_search.add(Filename.display_basename(path));
                }
    
                if (FileUtils.test (path, FileTest.IS_EXECUTABLE)) {
                    type += "| EXECUTABLE ";
                }
            }
        } catch (FileError err) {
            stderr.printf (err.message);
        }

        return this.get_names();
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
        for (i = 0; i < dirs.size; i++){
            names += dirs[i];
        }
        for (int j = 0; j < files.size; j++){
            names += files[j];
        }
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

class PathHelper {
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



[Print] public void prin(string s){stdout.printf(s + "\n");}