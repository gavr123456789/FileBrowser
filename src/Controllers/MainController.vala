using Katana;
using Gee;
//управляется из MainWindow, посылает запросы в DirNavigator
public class MainController{

    public MainController(Hdy.Carousel carousel, Gtk.InfoBar infobar)
    {
		this.carousel = carousel;
		this.infobar = infobar;
		//opening files in associated programm
		dir_nav.open_file.connect(open_file);

		
    }

	weak Hdy.Carousel carousel;
	weak Gtk.InfoBar infobar;
	DirectoryNavigator dir_nav = new DirectoryNavigator();
	SelectedFiles selected_files = new SelectedFiles();

	public async void create_page()
	{
		var page = new Page (dir_nav.path, carousel.n_pages + 1);// + 1 тк кк на текущий момент она еще не создана

		page.toggled.connect(page_toggled);
		page.selected.connect(page_selected);

		carousel.add(page);
		carousel.scroll_to(page);
    }

	public async void remove_page()
	{
		var removing_page = (!)(carousel.get_children().last().data as Page);
		removing_page.toggled.disconnect(page_toggled);
		carousel.remove (removing_page);
		dir_nav.go_back();
	}
    
	public void create_folder (string folder_name) 
	{
		dir_nav.folder_helper.create_folder(dir_nav.path, folder_name);
		dir_nav.update();
	}

	public void create_file (string file_name) 
	{
		dir_nav.file_helper.create_file(dir_nav.path, file_name);
		dir_nav.update();
	}

	private void open_file (File file){
		var window = carousel.get_toplevel();
		if(!(window is Window)) error("toplevel of carousel is now window!");

		try {
			Gtk.show_uri_on_window(
				(Window)window,
				file.get_uri(),
				Gdk.CURRENT_TIME
			);
		} catch (Error e) {error(e.message);}
	}
	
    
	void page_toggled(File file, bool is_active, uint num_in_carousel)
	{
		if(is_active){
           	delete_last_rows_if_needed(num_in_carousel);
				
			if (dir_nav.goto(file) == true)
				create_page.begin();
			else {
				
			}
		} 
	}

	void page_selected(RowWidget row_widget, bool is_active, uint num_in_carousel)
	{
		if(is_active){
			selected_files.selected_rows.add(row_widget);
		} 
	}

    inline void delete_last_rows_if_needed(uint num_in_carousel)
    {
		uint diff_max_and_now = carousel.n_pages - (num_in_carousel);
		prin("num in carousele = ", num_in_carousel, " all = ", carousel.n_pages, " diff = ", diff_max_and_now);
		if (diff_max_and_now != 0)
			for (var i = 0; i < diff_max_and_now; i++)
				remove_page.begin();
    }
}