using Gee;
namespace Katana{
[GtkTemplate (ui = "/org/gnome/Katana/window.ui")]
public class Window : Hdy.ApplicationWindow {
	[GtkChild] Hdy.Carousel carousel;
	[GtkChild] Gtk.ToggleButton search_button;
	[GtkChild] Gtk.SearchBar searchbar;
	[GtkChild] Gtk.Entry folder_name_entry;
	uint current_page; 
	DirectoryNavigator dir_iterator = new DirectoryNavigator();
	

	public Window (Gtk.Application app) {
		Object (application: app);
	}

	construct {
		create_page ( dir_iterator.get_names() );
	}

	[GtkCallback]
	private void page_changed (Hdy.Carousel carousel, uint index) {
		current_page = index;
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

	void create_page(string[] elem_names){
		var page = new Page (elem_names, dir_iterator.path);

		page.toggled.connect(page_toggled);

		//  page.show ();
		carousel.add(page);
		carousel.scroll_to(page);
	}

	void remove_page(){
		carousel.remove (carousel.get_children().last().data);
		dir_iterator.go_back();
	}

	
	void page_toggled(string label, bool is_active){
		if(is_active){
			uint diff_max_and_now = carousel.n_pages - (current_page + 1);
			if (diff_max_and_now != 0)
				for (var i = 0; i < diff_max_and_now; i++)
					remove_page();
			
			dir_iterator.goto(label);
			create_page(dir_iterator.get_names());
		} 
	}
}

}// no usless extra indent
