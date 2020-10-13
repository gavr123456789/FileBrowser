using Gee;
namespace Katana{
[GtkTemplate (ui = "/org/gnome/Katana/window.ui")]
public class Window : Hdy.ApplicationWindow {
	[GtkChild] Hdy.Carousel carousel;
	[GtkChild] Gtk.ToggleButton search_button;
	[GtkChild] Gtk.SearchBar searchbar;
	[GtkChild] Gtk.Entry folder_name_entry;
 
	DirectoryNavigator dir_iterator = new DirectoryNavigator();
	

	public Window (Gtk.Application app) {
		Object (application: app);
	}

	construct {
		create_page.begin();
		this.title = dir_iterator.path;
	}

	[GtkCallback]
	private void page_changed (Hdy.Carousel carousel, uint index) {
		//  current_page = index;
	}

	[GtkCallback]
	private void create_folder_clicked (Gtk.Button btn) {
		
		dir_iterator.folder_helper.create_folder(dir_iterator.path, folder_name_entry.text);
	}

	[GtkCallback]
	void on_search_button_toggled () {
		if (search_button.active) {
			searchbar.search_mode_enabled = true;
		} else {
			searchbar.search_mode_enabled = false;
		}
	}

	async void create_page(){
		var page = new Page (dir_iterator.path, carousel.n_pages + 1);// + 1 тк кк на текущий момент она еще не создана

		page.toggled.connect(page_toggled);

		//  page.show ();
		carousel.add(page);
		carousel.scroll_to(page);
	}

	async void remove_page(){
		var removing_page = (!)(carousel.get_children().last().data as Page);
		removing_page.toggled.disconnect(page_toggled);
		carousel.remove (removing_page);
		dir_iterator.go_back();
	}

	void page_toggled(string label, bool is_active, uint num_in_carousel){
		if(is_active){
			uint diff_max_and_now = carousel.n_pages - (num_in_carousel);
			prin("num in carousele = ", num_in_carousel, " all = ", carousel.n_pages, " diff = ", diff_max_and_now);

			if (diff_max_and_now != 0)
				for (var i = 0; i < diff_max_and_now; i++)
					remove_page.begin();
				
				
			dir_iterator.goto(label);
			this.title = dir_iterator.path;
			create_page.begin();
		} 
	}
}

}// no usless extra indent
