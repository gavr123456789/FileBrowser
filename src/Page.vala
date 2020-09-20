using Gtk;
namespace Katana {
	[GtkTemplate (ui = "/org/gnome/Katana/Page.ui")]
	public class Page : ScrolledWindow {
		[GtkChild] ListBox page_content;

		public signal void toggled(string str, bool is_active);

		public Page(string[] names){
			foreach (var name in names){
				add_new_element(name);
			}
		}

		public void add_new_element(owned string name = "noname"){
			var row = new RowWidget() { label = name };
			row.toggleBtn.toggled.connect(any_toggled);
			page_content.add(row);
			
		}

		void any_toggled(ToggleButton src){
			
			toggled(src.label ?? "unknown", src.active);

		}

	}
}
