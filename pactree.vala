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
string provides;
string unresolvable;
string branch_tip1;
string branch_tip2;
int indent_size;

/* color */
string branch1_color;
string branch2_color;
string leaf1_color;
string leaf2_color;
string color_off;

/* globals */
DB* db_local;
unowned Alpm.List<string> walked;
unowned Alpm.List<string> provisions;

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
  { "reverse", 'r', 0, OptionArg.NONE, out reverse, "show reverse dependencies with no duplicates (implies -l)", null },
  { "unique", 'u', 0, OptionArg.NONE, out unique, "show dependencies ", null },
  { null }
};

static void init_options() {
  /* globals */
  walked = Alpm.List<string>.new();
  provisions = Alpm.List<string>.new();

  /* initialize options */
  color = false;
  graphviz = false;
  linear = false;
  max_depth = -1;
  reverse = false;
  unique = false;
  dbpath = null;

  /* output */
  provides = " provides";
  unresolvable = " [unresolvable]";
  branch_tip1 = "|--";
  branch_tip2 = "+--";
  indent_size = 3;

  /* color */
  branch1_color = "\033[0;33m"; /* yellow */
  branch2_color = "\033[0;37m"; /* white */
  leaf1_color   = "\033[1;32m"; /* bold green */
  leaf2_color   = "\033[0;32m"; /* green */
  color_off     = "\033[0m";
}

static int parse_options(ref unowned string[] args) {
  var opts = new OptionContext("");
  opts.set_help_enabled(true);
  opts.add_main_entries(options, null);

  try {
    bool b = opts.parse(ref args);
    if (!b)
      {
	stderr.puts(opts.get_help(false, null));
	return 1;
      }

  }
  catch (OptionError e)
  {
    stderr.puts("Unable to parse options : " + e.message + "\n");
    return 1;
  }
  /* there must be (at least) one argument left */
  if (args.length == 1) return 1;
  /* reverse implies linear */
  if (reverse) linear = true;

  /* no color */
  if (!color) {
    branch1_color = branch2_color = "";
    leaf1_color = leaf2_color = "";
    color_off = "";
  }

  /* linear */
  if (linear) {
    provides = "";
    branch_tip1 = branch_tip2 = "";
    indent_size = 0;
  }
  return 0;
}

static void local_init() {
  int ret;
  ret = initialize();          assert(ret == 0);
  ret = set_root("/");         assert(ret == 0);
  ret = set_dbpath("/var/lib/pacman"); assert(ret == 0);
  db_local = register_local(); assert(db_local != null);
}

static int main (string[] args) {
  init_options();
  int ret = parse_options(ref args);
  if (ret != 0) return ret;

  local_init();
  string target_name = args[1];

  Package? pkg = find_satisfier(db_local.get_pkgcache(), target_name);
  if (pkg == null) {
    stderr.printf("Error: package '%s' not found\n", target_name);
    release();
    return 1;
  }

  /* begin writing */
  print_start(pkg.get_name(), target_name);
  if(reverse)
    walk_reverse_deps(pkg, 1);
  else
    walk_deps(pkg, 1);

  print_end();
  /* cleanup */
  release();
  return 0;
}

static void print_text(string? pkg, string? provision, int depth)
{
  int indent_sz = (depth + 1) * indent_size;

  if ((pkg == null) && (provision == null)) return;

  if (pkg == null) {
    /* we failed to resolve provision */
    stdout.printf("%s%*s%s%s%s%s%s\n", branch1_color, indent_sz, branch_tip1,
		  leaf1_color, provision, branch1_color, unresolvable, color_off);
  } else if ((provision != null) && (provision != pkg)) {
    /* pkg provides provision */
    stdout.printf("%s%*s%s%s%s%s %s%s%s\n", branch2_color, indent_sz, branch_tip2,
				leaf1_color, pkg, leaf2_color, provides, leaf1_color, provision,
				color_off);
  } else {
    /* pkg is a normal package */
    stdout.printf("%s%*s%s%s%s\n", branch1_color, indent_sz, branch_tip1, leaf1_color,
	   pkg, color_off);
  }
}

/**
 * walk dependencies in reverse, showing packages which require the target
 */
static void walk_reverse_deps(Package pkg, int depth) {
  if((max_depth >= 0) && (depth > max_depth)) return;

  walked = walked.add(pkg.get_name());
  var required_by = pkg.compute_requiredby();

  for(unowned Alpm.List<string> i = required_by; i != null; i = i.next()) {
    string pkgname = i.getdata();
    if (walked.find_str(pkgname) != null) {
      /* if we've already seen this package, don't print in "unique" output
       * and don't recurse */
      if (!unique) print(pkg.get_name(), pkgname, null, depth);
    } else {
      print(pkg.get_name(), pkgname, null, depth);
      walk_reverse_deps(db_local.get_pkg(pkgname), depth + 1);
    }
  }
}

/**
 * walk dependencies, showing dependencies of the target
 */
static void walk_deps(Package pkg, int depth)
{
  if((max_depth >= 0) && (depth > max_depth)) return;

  walked = walked.add(pkg.get_name());

  for(unowned Alpm.List<Depend*> i = pkg.get_depends(); i != null; i = i.next()) {
    Depend* depend = i.getdata();
    Package? provider = find_satisfier(db_local.get_pkgcache(), depend->get_name());

    if(provider != null) {
      string provname = provider.get_name();

      if(walked.find_str(provname) != null) {
	/* if we've already seen this package, don't print in "unique" output
	 * and don't recurse */
	if(!unique) {
	  print(pkg.get_name(), provname, depend->get_name(), depth);
	}
      } else {
	print(pkg.get_name(), provname, depend->get_name(), depth);
	walk_deps(provider, depth + 1);
      }
    } else {
      /* unresolvable package */
      print(pkg.get_name(), null, depend->get_name(), depth);
    }
  }
}

static void print_graph(string parentname, string? pkgname, string? depname)
{
  if(depname != null) {
    stdout.printf("\"%s\" -> \"%s\" [color=chocolate4];\n", parentname, depname);
    if((pkgname != null) && (depname != pkgname) && (provisions.find_str(depname) != null)) {
      stdout.printf("\"%s\" -> \"%s\" [arrowhead=none, color=grey];\n", depname, pkgname);
      provisions = provisions.add(depname);
    }
  } else if(pkgname != null) {
    stdout.printf("\"%s\" -> \"%s\" [color=chocolate4];\n", parentname, pkgname);
  }
}

/* parent depends on dep which is satisfied by pkg */
static void print(string? parentname, string? pkgname, string? depname, int depth)
{
  if(graphviz) {
    print_graph(parentname, pkgname, depname);
  } else {
    print_text(pkgname, depname, depth);
  }
}

static void print_start(string pkgname, string provname)
{
  if(graphviz) {
    stdout.printf("digraph G { START [color=red, style=filled];\n" +
		  "node [style=filled, color=green];\n" +
		  " \"START\" -> \"%s\";\n", pkgname);
  } else {
    print_text(pkgname, provname, 0);
  }
}

static void print_end()
{
  if(graphviz) {
    /* close graph output */
    stdout.printf("}\n");
  }
}
