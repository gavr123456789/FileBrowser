using Gtk;
using Gee;
namespace Katana {
	[GtkTemplate (ui = "/org/gnome/Katana/Page.ui")]
	public class Page : ScrolledWindow {
		[GtkChild] ListBox page_content;
		RowWidget? last_toggled_widget;
		ArrayQueue<string> file_names_list = new ArrayQueue<string>();

		public signal void toggled(string str, bool is_active);

		public Page(owned string[] names){
			page_content.set_header_func(set_header_func);
			//  file_names = names;

			foreach (var file_name in names)
				file_names_list.add((owned)file_name);
			
			// Lazy loading
			this.vadjustment.value_changed.connect (() => {
				double max_value = (this.vadjustment.upper - this.vadjustment.page_size) * 0.8;
				if (this.vadjustment.value >= max_value) {
					fill_page.begin();
				}
			});
			this.vadjustment.changed.connect (() => {
				while (need_more()) {
					fill_page.begin();
				}
			});
		}

		void set_header_func (Gtk.ListBoxRow row, Gtk.ListBoxRow? row_before) {
			row.set_header (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));
		}

		public async void fill_page(){
			var timer = new Timer();
			int max = file_names_list.size >= 30? 30: file_names_list.size;
			
			for (var i = 0; i < max; ++i){
				add_new_element(file_names_list.poll());
			}
			prin(Log.METHOD, " ",timer.elapsed());
			prin("Items left: ", file_names_list.size);

			show_all();
		}

		public void add_new_element(owned string name){
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

		//For lazy load
		bool need_more() {
			if(file_names_list.size != 0){
				int natural_height;
				page_content.get_preferred_height (null, out natural_height);
				//  prin(this.vadjustment.page_size, " ", natural_height);
				if (this.vadjustment.page_size > natural_height) {
					return true;
				}
			}
			return false;
		}
	}
}
