using Gee;
namespace Katana{
[GtkTemplate (ui = "/org/gnome/Katana/window.ui")]
public class Window : Hdy.ApplicationWindow {
	[GtkChild] Hdy.Carousel carousel;
	
	[GtkChild] Gtk.ToggleButton search_button;
	[GtkChild] Gtk.ToggleButton create_folder;
	[GtkChild] Gtk.ToggleButton create_file;
	
	[GtkChild] Gtk.Entry folder_name_entry;
	[GtkChild] Gtk.Entry file_format_entry;
	[GtkChild] Gtk.Entry file_name_entry;

	[GtkChild] Gtk.SearchBar searchbar;

	[GtkChild] Gtk.InfoBar selectedbar;
	[GtkChild] Gtk.Label infobar_label;
	[GtkChild] Gtk.Image infobar_icon;
 
	MainController main_controller;

	public Window (Gtk.Application app) {
		Object (application: app);
	}

	construct {
		main_controller = new MainController(carousel, selectedbar);
		main_controller.create_page.begin();
	}

	[GtkCallback]
	private void page_changed (Hdy.Carousel carousel, uint index) {
		//  current_page = index;
	}

	[GtkCallback]
	private void create_folder_clicked (Gtk.Widget btn) {
		main_controller.create_folder(folder_name_entry.text);
		folder_name_entry.text = "";
		create_folder.active = false;
	}

	[GtkCallback]
	private void create_file_clicked (Gtk.Widget btn) {
		string format = 
		file_format_entry.text.has_prefix(".")?
		 file_format_entry.text:
		 "." + file_format_entry.text;
		
		main_controller.create_file(file_name_entry.text + format);
		file_name_entry.text   = "";
		file_format_entry.text = "";
		create_file.active = false;
	}

	[GtkCallback]
	void on_search_button_toggled () {
		if (search_button.active) {
			searchbar.search_mode_enabled = true;
		} else {
			searchbar.search_mode_enabled = false;
		}
	}

	//INFOBAR REGION

	public void showinfobar (Gtk.MessageType type, string message) {
		selectedbar.set_message_type (type);
		infobar_label.set_label (message);

		string icon = "";
		switch (type) {
			case INFO:
				icon = "dialog-information-symbolic";
				break;
			case WARNING:
				icon = "dialog-warning-symbolic";
				break;
			case QUESTION:
				icon = "dialog-question-symbolic";
				break;
			case ERROR:
				icon = "dialog-error-symbolic";
				break;
			case OTHER:
			default:
				icon = "missing-image-symbolic";
				break;
		}

		infobar_icon.set_from_icon_name (icon, LARGE_TOOLBAR);
		selectedbar.set_revealed (true);

		// Timeout
		//  Timeout.add_seconds (1, () => {
		//  	this.hideinfobar ();
		//  	return false;
		//  });
	}

	[GtkCallback]
	void test_button_clicked (Gtk.Button src) {
		showinfobar (QUESTION, "Question?");
	}

	[GtkCallback]
	void infobar_close (Gtk.InfoBar src, int response_id) {
		prin("sas!");
		selectedbar.set_revealed (false);
		infobar_label.set_label ("");
	}
}

}// no usless extra indent
