using Katana;
using Gee;
//управляется из MainWindow, посылает запросы в DirNavigator
public class MainController{

    public MainController(Hdy.Carousel carousel)
    {
        this.carousel = carousel;
    }

    weak Hdy.Carousel carousel;
    DirectoryNavigator DirNav;
    ArrayQueue<Page> pages_collection = new ArrayQueue<Page>();
	DirectoryNavigator dir_iterator = new DirectoryNavigator();


    public async void create_page(){
		var page = new Page (dir_iterator.path, carousel.n_pages + 1);// + 1 тк кк на текущий момент она еще не создана

		page.toggled.connect(page_toggled);

		//  page.show ();
		carousel.add(page);
		carousel.scroll_to(page);
    }

    public async void remove_page(){
		var removing_page = (!)(carousel.get_children().last().data as Page);
		removing_page.toggled.disconnect(page_toggled);
		carousel.remove (removing_page);
		dir_iterator.go_back();
	}
    
    public void create_folder (string folder_name) {
		
		dir_iterator.folder_helper.create_folder(dir_iterator.path, folder_name);
    }
    
    void page_toggled(string label, bool is_active, uint num_in_carousel){
		if(is_active){
			uint diff_max_and_now = carousel.n_pages - (num_in_carousel);
			prin("num in carousele = ", num_in_carousel, " all = ", carousel.n_pages, " diff = ", diff_max_and_now);

            if (diff_max_and_now != 0)
			    delete_last_n_row(diff_max_and_now);
				
				
			dir_iterator.goto(label);
			create_page.begin();
		} 
	}

    inline void delete_last_n_row(uint n)
    {
        for (var i = 0; i < n; i++)
            remove_page.begin();
    }
}