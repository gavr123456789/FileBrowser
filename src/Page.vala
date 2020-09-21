using Gtk;
using Gee;
namespace Katana {
	[GtkTemplate (ui = "/org/gnome/Katana/Page.ui")]
	public class Page : ScrolledWindow {
		[GtkChild] ListBox page_content;
		RowWidget? last_toggled_widget;
		//  string[] file_names = {};
		//  ArrayQueue<string> file_names_list = new ArrayQueue<string>();

		public signal void toggled(string str, bool is_active);

		public Page(owned string[] names){
			page_content.set_header_func(set_header_func);
			//  file_names = names;

			//  foreach (var file_name in names)
			//  	file_names_list.add(file_name);
			
			if (names.length != 0)
				fill_page.begin(names);
		}

		void set_header_func (Gtk.ListBoxRow row, Gtk.ListBoxRow? row_before) {
			row.set_header (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));
		}

		public async void fill_page(owned string[] names){
			var timer = new Timer();
			var counter = 1;
			foreach (var name in names){
				add_new_element(name);
				if (counter == 30){
					show_all();
					Idle.add (fill_page.callback);
					yield;
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


			//Future lazy load?
		//  bool need_more() {
		//  	int natural_height;
		//  	page_content.get_preferred_height (null, out natural_height);
		//  	if (this.vadjustment.page_size > natural_height) {
		//  		return true;
		//  	}
		//  	return false;
		//  }
		//  void complete_packages_list (owned string[] names) {
		//  	if (file_names_list.size != 0) {
		//  		uint i = 0;
		//  		// display the next 20 packages
		//  		while (i < 20) {

		//  			var file = file_names_list.poll();
		//  			add_new_element (file);
		//  			i++;
		//  		}
		//  	}
		//  	show_all();
		//  }
}
