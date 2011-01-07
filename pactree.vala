/*
 *  pactree.c - a simple dependency tree viewer
 *
 *  Copyright (c) 2010 Pacman Development Team <pacman-dev@archlinux.org>
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
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

using Alpm;
using Alpm.Option;

/* output */
const string PROVIDES = " provides";
const string UNRESOLVABLE = " [unresolvable]";
const string BRANCH_TIP1 = "|--";
const string BRANCH_TIP2 = "+--";
const int INDENT_SIZE = 3;

/* color */
const string BRANCH1_COLOR = "\033[0;33m"; /* yellow */
const string BRANCH2_COLOR = "\033[0;37m"; /* white */
const string LEAF1_COLOR   = "\033[1;32m"; /* bold green */
const string LEAF2_COLOR   = "\033[0;32m"; /* green */
const string COLOR_OFF     = "\033[0m";

/* globals */
DB* db_local;
Alpm.List walked;
Alpm.List provisions;

/* options */
bool color;
bool graphviz;
bool linear;
int max_depth;
bool reverse;
bool unique;
string dbpath;

const OptionEntry[] options = {
  { "dbpath", 'b', OptionFlags.FILENAME, OptionArg.STRING, out dbpath, "set an alternate database location", "path" },
  { "color", 'c', 0, OptionArg.NONE, out color, "colorize output", null },
  { "depth", 'd', 0, OptionArg.INT, out max_depth, "limit the depth of recursion", "number" },
  { "graph", 'g', 0, OptionArg.NONE, out graphviz, "generate output for graphviz", null },
  { "linear", 'l', 0, OptionArg.NONE, out linear, "enable linear output", null },
  { "reverse", 'r', 0, OptionArg.NONE, out reverse, "show reverse dependencies with no duplicates", null },
  { "unique", 'u', 0, OptionArg.NONE, out unique, "show dependencies ", null },
  { null }
};

static void local_init() {
  int ret;
  ret = initialize();          assert(ret == 0);
  ret = set_root("/");         assert(ret == 0);
  ret = set_dbpath("/var/lib/pacman"); assert(ret == 0);
  db_local = register_local(); assert(db_local != null);
}

static int main (string[] args) {
  /* initialize options */
  color = false;
  graphviz = false;
  linear = false;
  max_depth = -1;
  reverse = false;
  unique = false;
  dbpath = null;

  var opts = new OptionContext("");
  opts.set_help_enabled(true);
  opts.add_main_entries(options, null);
  if (!opts.parse(ref args))
  {
    stderr.puts(opts.get_help(false, null));
    return 1;
  }

  return 0;
}
