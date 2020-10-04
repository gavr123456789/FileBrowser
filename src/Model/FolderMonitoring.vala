public class FolderMonitoring{

	public signal void something_changed(FileMonitorEvent event, File file);

	public void monitor_dir(string folder_name)
	{
		try {
			File file = File.new_for_path (Environment.get_home_dir ());
			
			FileMonitor monitor = file.monitor (FileMonitorFlags.NONE, null);
			print ("Monitoring: %s\n", file.get_path () ?? "Error get_path");

			monitor.changed.connect ((src, new_name, event) => {
				// is there file rename?
				if (new_name != null) {
					print (@"$event: %s, %s\n", src.get_path () ?? "Error get_path", ((!)new_name).get_path () ?? "Error get_path");
					
				} else {
					something_changed(event, src);
					print ("%s: %s\n", event.to_string (), src.get_path () ?? "Error get_path");
				}
			});
		} catch (Error e) {
			warning(e.message);
		}
    }
}