using Gtk;
class RowWidget : ListBoxRow {
    public RowWidget(owned GLib.File file){
        content.file = file;

        this.add(main_box);
        main_box.add(select_btn);
        main_box.add(direction_btn);
        
        main_box.get_style_context().add_class(STYLE_CLASS_LINKED);
        direction_btn.toggled.connect(toggled_handler);
    }

    Content content;

    ToggleButton select_btn = new ToggleButton();
    Box main_box = new Box(Orientation.HORIZONTAL, 0);
    
    public signal void toggled(File file, bool is_active);
  
    public bool active { 
        get { return direction_btn.active; } 
        set { direction_btn.set_active(value); } 
    }
    public string label { 
        get { return select_btn.label ?? "Null Error"; } 
        set { select_btn.label = value;} 
    }

    public FileType file_type {
        get { return content.file.query_file_type(FileQueryInfoFlags.NONE); } 
    }


    private ToggleButton direction_btn = new ToggleButton(){
        always_show_image = true,
        label = "",
        image = new Image.from_icon_name("pan-end-symbolic", IconSize.BUTTON)
    };

    inline void toggled_handler (ToggleButton src){
        if(src.active)
        {
            prin("check file type:", file_type);
            if(file_type == FileType.REGULAR) {
                TimeoutSource time = new TimeoutSource.seconds(1);

                time.set_callback (() => {
                    src.active = false;
                    prin("pint");
                    return false;
                });
                time.attach();
            }
        }
        toggled(content.file, direction_btn.active);
    }
    
}