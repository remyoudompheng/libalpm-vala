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

[CCode (cprefix = "alpm_list_", cheader_filename = "alpm_list.h,alpm-util.h")]
[Compact]
namespace Alpm {
  [CCode (cname = "alpm_list_t", type_parameters = "G",
          free_function = "alpm_list_free_all")]
  [Compact]
  public class List<G> {
    [CCode (cname = "alpm_list_new")]
    public static List new();
    public delegate int Compare(G a, G b);

    /* item mutators */
    [ReturnsModifiedPointer ()]
    public void add(G data);
    public List<G> copy();

    /* item accessors */
    public unowned List<G> first();
    public unowned List<G> nth(int n);
    public unowned List<G>? next();
    public unowned G getdata();

    /* misc */
    public int count();
    public unowned string? find_str(string needle);

    /* iterator */
    public Iterator<G> iterator();

    [CCode (cname = "alpm_list_iterator_t", cprefix = "alpm_list_iterator_")]
    public struct Iterator<G> {
      public unowned G? next_value();
    }
  } 
}

/* vim: set ts=2 sw=2 noet: */
