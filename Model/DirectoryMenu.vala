class DirectoryMenu{
    DirectoryNavigator dir_navigator = new DirectoryNavigator();
    public void run(){
        string answer = "";
        dir_navigator.print();
        prin(0, ". exit");
        
        while (answer != "0"){
            answer = (!)stdin.read_line();
            if (answer == "-1"){
                dir_navigator.go_back();
            } else {
                dir_navigator.goto(answer);
            }
            dir_navigator.print();
            prin(0, ". exit");
        }
    }
}