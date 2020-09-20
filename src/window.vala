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

		page.toggled.connect((label, is_active) =>{
			if(is_active){
				prin(current_page+1, " ", carousel.n_pages);
				if (current_page+1 < carousel.n_pages){
					for (var i = 0; i < carousel.n_pages - current_page+1; i++){
						remove_page();
					}
				}
				dir_iterator.goto(label);
				create_page(dir_iterator.get_names());
			} else {

				dir_iterator.go_back();
				remove_page();
			}
		});

		page.show ();
		carousel.add(page);
		carousel.scroll_to(page);
	}

	void remove_page(){
		carousel.remove (carousel.get_children().last().data);
		dir_iterator.go_back();
	}
}

}
