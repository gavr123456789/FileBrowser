using Gee;
namespace Katana{
[GtkTemplate (ui = "/org/gnome/Katana/window.ui")]
public class Window : Hdy.ApplicationWindow {
	[GtkChild] Hdy.Carousel carousel;
	[GtkChild] Gtk.ToggleButton search_button;
	[GtkChild] Gtk.ToggleButton create_folder;
	[GtkChild] Gtk.SearchBar searchbar;
	[GtkChild] Gtk.Entry folder_name_entry;
 
	MainController main_controller;

	public Window (Gtk.Application app) {
		Object (application: app);
	}

	construct {
		main_controller = new MainController(carousel);
		main_controller.create_page.begin();
	}

	[GtkCallback]
	private void page_changed (Hdy.Carousel carousel, uint index) {
		//  current_page = index;
	}

	[GtkCallback]
	private void create_folder_clicked (Gtk.Button btn) {
		main_controller.create_folder(folder_name_entry.text);
		folder_name_entry.text = "";
		create_folder.active = false;
	}

	[GtkCallback]
	void on_search_button_toggled () {
		if (search_button.active) {
			searchbar.search_mode_enabled = true;
		} else {
			searchbar.search_mode_enabled = false;
		}
	}

}

}// no usless extra indent
