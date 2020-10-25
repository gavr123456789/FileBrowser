using Katana;
using Gee;
//управляется из MainWindow, посылает запросы в DirNavigator
public class MainController{

    public MainController(Hdy.Carousel carousel)
    {
		this.carousel = carousel;
		dir_nav.open_file.connect((file) => {
			var window = carousel.get_toplevel();
			if(!(window is Window)) error("toplevel of carousel is now window!");

			try {
				Gtk.show_uri_on_window(
					(Window)window,
					file.get_uri(),
					Gdk.CURRENT_TIME
				);
			} catch (Error e) {error(e.message);}
		});
    }

    weak Hdy.Carousel carousel;
    ArrayQueue<Page> pages_collection = new ArrayQueue<Page>();
	DirectoryNavigator dir_nav = new DirectoryNavigator();
	

    public async void create_page(){
		var page = new Page (dir_nav.path, carousel.n_pages + 1);// + 1 тк кк на текущий момент она еще не создана

		page.toggled.connect(page_toggled);

		//  page.show ();
		carousel.add(page);
		carousel.scroll_to(page);
    }

    public async void remove_page(){
		var removing_page = (!)(carousel.get_children().last().data as Page);
		removing_page.toggled.disconnect(page_toggled);
		carousel.remove (removing_page);
		dir_nav.go_back();
	}
    
    public void create_folder (string folder_name) {
		
		dir_nav.folder_helper.create_folder(dir_nav.path, folder_name);
		dir_nav.update();
    }
    
    void page_toggled(File file, bool is_active, uint num_in_carousel){
		if(is_active){
			uint diff_max_and_now = carousel.n_pages - (num_in_carousel);
			prin("num in carousele = ", num_in_carousel, " all = ", carousel.n_pages, " diff = ", diff_max_and_now);

            if (diff_max_and_now != 0)
			    delete_last_n_row(diff_max_and_now);
				
				
			if (dir_nav.goto(file) != false)
				create_page.begin();
		} 
	}

    inline void delete_last_n_row(uint n)
    {
        for (var i = 0; i < n; i++)
            remove_page.begin();
    }
}