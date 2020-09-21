using Gtk;
namespace Katana {
	[GtkTemplate (ui = "/org/gnome/Katana/Page.ui")]
	public class Page : ScrolledWindow {
		[GtkChild] ListBox page_content;
		RowWidget? last_toggled_widget;
		string[] file_names = {};

		public signal void toggled(string str, bool is_active);

		public Page(owned string[] names){
			file_names = names;
			if (names.length != 0)
				fill_page.begin(names);
		}

		public async void fill_page(owned string[] names){
			var timer = new Timer();
			var part =  names.length>=4? names.length / 4: 1;
			var counter = 1;
			foreach (var name in names){
				add_new_element(name);
				if (counter == 30){
					show_all();
					Idle.add (fill_page.callback);
					yield;
					//  prin("YIELD");
				}

				++counter;
			}
			prin(Log.METHOD, " ",timer.elapsed());
			show_all();
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
