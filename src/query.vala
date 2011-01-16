/*
 * libalpm-vala
 * Vala bindings and GUI for libalpm
 *
 *  Copyright (c) 2011 Rémy Oudompheng <remy@archlinux.org>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a get of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

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
