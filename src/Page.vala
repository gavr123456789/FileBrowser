using Gtk;
namespace Katana {
	[GtkTemplate (ui = "/org/gnome/Katana/Page.ui")]
	public class Page : ScrolledWindow {
		[GtkChild] Box page_content;

		
		RowWidget? last_toggled_widget;

		public signal void toggled(string str, bool is_active);

		public Page(string[] names){
			foreach (var name in names){
				add_new_element(name);
			}
		}

		public void add_new_element(owned string name = "noname"){
			var row = new RowWidget() { label = name };
			row.toggled.connect(untoggle_last);
			page_content.add(row);
		}

		void untoggle_last(RowWidget src, string label, bool active){
			if(last_toggled_widget != src){
				if (last_toggled_widget == null){
					last_toggled_widget = src;
				} else {
					((!)last_toggled_widget).active = false;
					last_toggled_widget = src;
				}
			} 
			toggled(label, active);
		}

	}
}
