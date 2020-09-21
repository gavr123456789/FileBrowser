using Gtk;
class RowWidget : Box {
    public ToggleButton direction_btn = new ToggleButton(){
        always_show_image = true,
        label = "",
        image = new Image.from_icon_name("pan-end-symbolic", IconSize.BUTTON)
    };
    public ToggleButton select_btn = new ToggleButton();

    
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
        orientation = Orientation.HORIZONTAL;
        
        this.add(select_btn);
        this.add(direction_btn);

        
        get_style_context().add_class(STYLE_CLASS_LINKED);

        direction_btn.toggled.connect((src)=> {
            toggled((!)select_btn.label, direction_btn.active);
        });

        show_all();
    }
    
}