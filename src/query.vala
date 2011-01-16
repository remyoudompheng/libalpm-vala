using Alpm;
using Gtk;

static int main(string[] args) {
  Alpm.initialize();
  Option.set_root("/");
  Option.set_dbpath("/var/lib/pacman");

  Gtk.init(ref args);

  DB* db = register_local();

  /* main widget */
  var view = new PkgListView();
  view.display_list(db.get_pkgcache());

  /* main window */
  Window win = new Window();
  win.add(view.widget);
  win.destroy.connect(Gtk.main_quit);
  win.show_all();

  Gtk.main();

  Alpm.release();

  return 0;
}
