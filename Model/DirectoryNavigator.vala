using Gee;
void main(){
    //Tests
    //  var dir_iter = new DirectoryNavigator();
    //  prin(dir_iter);
    //  dir_iter.goto("Projects");
    //  prin(dir_iter.get_full_path());
    //  prin("\n", dir_iter);
    //  dir_iter.goto("qq");
    //  prin(dir_iter.get_full_path());
    //  prin("\n", dir_iter);
    //  dir_iter.go_back();
    //  prin(dir_iter.get_full_path());
    //  prin("\n", dir_iter);
    //File menu
    var menu = new DirectoryMenu();
    menu.run();

}



class DirectoryNavigator{

    public DirectoryNavigator() {
        path.add(Environment.get_home_dir());
        get_files_names();
    }

    ArrayList<string> path = new ArrayList<string>();
    HashSet<string> dirs_search = new HashSet<string>(); // if true then its dir //TODO replace with treeset

    ArrayList<string> dirs = new ArrayList<string>();
    ArrayList<string> files = new ArrayList<string>();

    public int size { get{ return path.size; } }
    void append(string s) { path.add(Path.DIR_SEPARATOR_S + s); }
    void remove()         { path.remove_at(path.size - 1); }


    public bool goto(string dir){
        if(dir in dirs_search){
            append(dir);
            message(@"goto $dir");
            get_files_names();
            return true;
        } else {
            message(@"no such directory");
            return false;
        }
    }
    public void go_back(){
        remove();
        get_files_names();
    }

    string directory{ owned get { return get_full_path(); }}

    
    void get_files_names() {
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
                    //  dirs_search[Filename.display_basename(path)] = false;
                    files.add(Filename.display_basename(path));
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
    }

    public string get_full_path(){
        var builder = new StringBuilder();
        foreach(var a in path){
            builder.append(a);
        }
        var s = builder.str.dup();
        return s;
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

    public string to_string(){
        var builder = new StringBuilder();
        foreach (var file in dirs_search)
            builder.append(file + "\n");
        var s = builder.str;
        return s;
    }
}

[Print] void prin(string s){stdout.printf(s + "\n");}
