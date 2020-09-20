using Gtk;
class RowWidget : Box {
    public ToggleButton toggleBtn = new ToggleButton();
  
    public bool active { get { return toggleBtn.active; } set {toggleBtn.set_active(value);} }
    public string label { 
        get { return toggleBtn.label ?? "Null Error"; } 
        set { toggleBtn.label = value; } 
    }


    construct {
        orientation = Orientation.HORIZONTAL;
        this.add(toggleBtn);
        show_all();
    }
    
}