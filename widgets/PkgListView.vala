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

using Gtk;
using Alpm;

namespace Gtk {
  public class PkgListView : Gtk.TreeView {
    private ListStore store;
    public ScrolledWindow widget;

    public PkgListView() {
      store = new ListStore (Columns.N_COLUMNS, typeof(string), typeof(string), typeof(int), typeof(int));
      this.set_model(store);

      /* name column */
      var cell = new CellRendererText ();
      var column = new TreeViewColumn ();
      column.title = "Name";
      column.pack_start (cell, true);
      column.add_attribute (cell, "text", Columns.NAME);
      column.sort_column_id = Columns.NAME;
      this.append_column (column);

      /* version column */
      cell = new CellRendererText ();
      column = new TreeViewColumn ();
      column.title = "Version";
      column.pack_start (cell, true);
      column.add_attribute (cell, "text", Columns.VERSION);
      this.append_column (column);

      /* size column */
      cell = new CellRendererText ();
      column = new TreeViewColumn ();
      column.title = "Installed size";
      column.pack_start (cell, true);
      column.add_attribute (cell, "text", Columns.ISIZE);
      column.sort_column_id = Columns.ISIZE;
      this.append_column (column);

      /* download size column */
      cell = new CellRendererText ();
      column = new TreeViewColumn ();
      column.title = "Download size";
      column.pack_start (cell, true);
      column.add_attribute (cell, "text", Columns.DSIZE);
      this.append_column (column);

      this.set_headers_visible (true);

      /* set up a container widget */
      widget = new ScrolledWindow(null, null);
      widget.set_policy(PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
      widget.add(this);
    }

    private enum Columns {
      NAME,
      VERSION,
      ISIZE,
      DSIZE,
      N_COLUMNS
    }

    public void display_list(Alpm.List<Package?> l) {
      store.clear();

      foreach(unowned Package? p in l) {
        TreeIter iter;
        store.append(out iter);
	store.set(iter,
		  Columns.NAME, p.name,
		  Columns.VERSION, p.version,
		  Columns.ISIZE, p.size,
		  Columns.DSIZE, p.download_size());
      }
    }
  }
}
