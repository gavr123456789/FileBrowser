using Gee;
namespace Infinitepaginator {
	[GtkTemplate (ui = "/org/gnome/Katana/window.ui")]
	public class Window : Hdy.ApplicationWindow {

		[GtkChild]
		private Hdy.Carousel carousel;
		DirectoryNavigator dir_iterator = new DirectoryNavigator();
		

		public Window (Gtk.Application app) {
			Object (application: app);
		}

		construct {
			carousel.add (create_page_widget ( dir_iterator.get_files_names(  ) ) );
		}

		[GtkCallback]
		private void page_changed_cb (Hdy.Carousel carousel, uint index) {
			//  position += ((int) index - N_PAGES);

			//  for (; index < N_PAGES; index++) {
			//  	carousel.remove (carousel.get_children ().last ().data);
			//  	carousel.prepend (create_page (position - (int) index - 1));
			//  }

			//  for (; index > N_PAGES; index--) {
			//  	carousel.remove (carousel.get_children ().first ().data);
			//  	carousel.add (create_page (position - (int) index + 2 * N_PAGES + 1));
			//  }
		}

		void create_page(string[] elem_names){
			carousel.add(create_page_widget(elem_names));
		}

		void remove_page(){
			carousel.remove (carousel.get_children().last().data);
			dir_iterator.go_back();
		}

		Gtk.Widget create_page_widget (string[] elem_names) {	
			var page = new Page (elem_names);

			page.toggled.connect((label, is_active) =>{
				if(is_active){
					dir_iterator.goto(label);
					create_page(dir_iterator.get_names());

				} else {
					dir_iterator.go_back();
					remove_page();
				}
			});

			page.show ();
			return page;
		}
	}
}
