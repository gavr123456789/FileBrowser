using Gtk;
namespace Infinitepaginator {
	[GtkTemplate (ui = "/org/gnome/Katana/Page.ui")]
	public class Page : ScrolledWindow {
		[GtkChild] ListBox page_content;

		public signal void toggled(string str, bool is_active);
	
		

		public Page(string[] names){
			
			foreach (var name in names){
				add_new_element(name);
			}
			
		}

		public void add_new_element(owned string name = "noname"){
			var row = new RowWidget() { label = name };
			row.toggleBtn.toggled.connect( src => {
				toggled(src.label ?? "unknown", src.active);
			});
			page_content.add(row);
			
		}

	}
	//  class PageContent : ListBox {
	//  	public signal void toggled(string str, bool is_active);
	
		

	//  	public PageContent(string[] names){
			
	//  		foreach (var name in names){
	//  			add_new_element(name);
	//  		}
			
	//  	}

	//  	public void add_new_element(owned string name = "noname"){
	//  		var row = new RowWidget() { label = name };
	//  		row.toggleBtn.toggled.connect( src => {
	//  			toggled(src.label, src.active);
	//  		});
	//  		this.add(row);
			
	//  	}

	//  }
}
