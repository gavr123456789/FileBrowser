using Gee;
namespace Katana{
[GtkTemplate (ui = "/org/gnome/Katana/window.ui")]
public class Window : Hdy.ApplicationWindow {

	[GtkChild]
	Hdy.Carousel carousel;
	uint current_page; 
	DirectoryNavigator dir_iterator = new DirectoryNavigator();
	

	public Window (Gtk.Application app) {
		Object (application: app);
	}

	construct {
		create_page ( dir_iterator.get_files_names() );
	}

	[GtkCallback]
	private void page_changed (Hdy.Carousel carousel, uint index) {
		current_page = index;
	}

	[GtkCallback]
	private void dbg_button_clicked1 (Gtk.Button btn) {
		btn.set_label("remove page");
		remove_page();
	}

	[GtkCallback]
	private void dbg_button_clicked2 (Gtk.Button btn) {
		
	}	

	void create_page(string[] elem_names){
		var page = new Page (elem_names);

		page.toggled.connect(page_toggled);

		page.show ();
		carousel.add(page);
		carousel.scroll_to(page);
	}

	void remove_page(){
		carousel.remove (carousel.get_children().last().data);
		dir_iterator.go_back();
	}

	
	void page_toggled(string label, bool is_active){
		if(is_active){
			//  prin(current_page+1, " ", carousel.n_pages);
			uint diff_max_and_now = carousel.n_pages - (current_page + 1);
			if (diff_max_and_now != 0){
				for (var i = 0; i < diff_max_and_now; i++){
					//  prin("removing page ", i, " of ", diff_max_and_now);
					remove_page();
				}
			}
			dir_iterator.goto(label);
			create_page(dir_iterator.get_names());
		} else {

			//  dir_iterator.go_back();
			//  remove_page();
		}
	}
}

}
