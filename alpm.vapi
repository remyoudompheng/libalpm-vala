/*
 * Vala header for libalpm
 *
 *  getright (c) 2011 Rémy Oudompheng <remy@archlinux.org>
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

[CCode (cprefix = "alpm_", cheader_filename="alpm.h,alpm-vala.h")]
namespace Alpm {
  /**
	 * Library
   */
  public int initialize();
  public int release();
  public string version();

  /**
   * Options
   */
  [CCode (cprefix = "alpm_option_")]
  namespace Option {
    public static int set_root(string path);
    public static int set_dbpath(string dbpath);
  }

  /**
   * Databases
   */
  [CCode (cname = "alpm_db_register_local")]
  public DB* register_local();
  [CCode (cname = "alpm_db_register_sync")]
  public DB* register_sync(string treename);

  [CCode (cname = "pmdb_t", cprefix = "alpm_db_")]
  public struct DB {
    public int unregister();
	  public static void unregister_all();
    public string get_name();
    public string get_url();
	  public int setserver(string url);
    public unowned List<Package> get_pkgcache();
  }

  /**
   * Packages
   */
  [CCode (cname = "pmpkg_t", cprefix = "alpm_pkg_",
          free_function = "alpm_pkg_free")]
  [Compact]
  public class Package {
    [CCode (cname = "alpm_pkg_load_file")]
    public static unowned Package? load_file([CCode (array_length = false)] char[] filename, int full);

    public static int checkmd5sum();

    [CCode (cname = "alpm_fetch_pkgurl")]
    public static char[] fetch_pkgurl(uchar[] url);

    public static int vercmp(char[] a, char[] b);
    
    public List<string> compute_requiredby();

    /* getters */
    [CCode (array_length = false)]
    public unowned string get_filename();
    [CCode (array_length = false)]
    public unowned string get_name();
    [CCode (array_length = false)]
    public unowned string get_version();
    [CCode (array_length = false)]
    public unowned string get_desc();
    [CCode (array_length = false)]
    public unowned string get_url();
    public time_t get_builddate();
    public time_t get_installdate();
    [CCode (array_length = false)]
    public unowned string get_packager();
    [CCode (array_length = false)]
    public unowned string get_md5sum();
    [CCode (array_length = false)]
    public unowned string get_arch();
    public size_t get_size();
    public size_t get_isize();

    public unowned Alpm.List<Depend*> get_depends();
  }

  /**
   * Dependencies and conflicts
   */
  [CCode (cname = "pmdepmod_t", cprefix = "PM_DEP_MOD_")]
  public enum DepMod {
    ANY = 1,
    EQ,
    GE,
    LE,
    GT,
    LT
  }

  public Package? find_satisfier(Alpm.List<Package> pkgs, string depstring);

  [CCode (cname = "pmdepend_t", cprefix = "alpm_dep_")]
  public struct Depend {
    public DepMod get_mod();
    public unowned string get_name();
    public unowned string get_version();
    public string compute_string();
  }
}

/* vim: set ts=2 sw=2 noet: */
