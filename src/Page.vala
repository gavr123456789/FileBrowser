using Gtk;
namespace Katana {
	[GtkTemplate (ui = "/org/gnome/Katana/Page.ui")]
	public class Page : ScrolledWindow {
		[GtkChild] ListBox page_content;
		ToggleButton? last_toggled_btn;

		public signal void toggled(string str, bool is_active);

		public Page(string[] names){
			foreach (var name in names){
				add_new_element(name);
			}
		}

		public void add_new_element(owned string name = "noname"){
			var row = new RowWidget() { label = name };
			row.toggleBtn.toggled.connect(untoggle_last);
			page_content.add(row);
		}

		void untoggle_last(ToggleButton src){
			if(last_toggled_btn != src){
				if (last_toggled_btn == null){
					last_toggled_btn = src;
				} else {
					((!)last_toggled_btn).active = false;
					last_toggled_btn = src;
				}
			} 
			toggled(src.label ?? "unknown", src.active);
		}

	

		//  void untoggle(Widget src){
		//  	var row = src as ListBoxRow;
		//  	if (row is ListBoxRow){
		//  		var btn = (!)(((!)row).get_child() as RowWidget); // https://gitlab.gnome.org/GNOME/vala/-/issues/894 PLS
		//  		btn.active = false;
		//  	} else {
		//  		prin(src.get_type().name());
		//  		error("on of page childs isnt a ToggleButton");
		//  	}
		//  }

	}
}
