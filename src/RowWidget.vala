using Gtk;
class RowWidget : ListBoxRow {
    private ToggleButton direction_btn = new ToggleButton(){
        always_show_image = true,
        label = "",
        image = new Image.from_icon_name("pan-end-symbolic", IconSize.BUTTON)
    };
    private ToggleButton select_btn = new ToggleButton();
    private Box main_box = new Box(Orientation.HORIZONTAL, 0);
    
    public signal void toggled(string file_name, bool is_active);
  
    public bool active { 
        get { return direction_btn.active; } 
        set {direction_btn.set_active(value);} 
    }
    public string label { 
        get { return select_btn.label ?? "Null Error"; } 
        set { select_btn.label = value; } 
    }


    construct {
        this.add(main_box);
        main_box.add(select_btn);
        main_box.add(direction_btn);
        
        main_box.get_style_context().add_class(STYLE_CLASS_LINKED);
        direction_btn.toggled.connect(toggled_handler);
    }

    inline void toggled_handler (ToggleButton src){
        toggled((!)select_btn.label, direction_btn.active);
    }
    
}