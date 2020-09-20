
int main (string[] args) {
	var app = new Gtk.Application ("org.gnome.Katana", ApplicationFlags.FLAGS_NONE);

	app.startup.connect (() => {
		Hdy.init ();
	});

	app.activate.connect (() => {
		var win = app.active_window;
		win = new Katana.Window (app);
		win.present ();
	});

	return app.run (args);
}
