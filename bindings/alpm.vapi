/*
 * Vala header for libalpm
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

[CCode (cprefix = "alpm_", cheader_filename="alpm.h,alpm-util.h")]
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
    public unowned string get_root();
    public int set_root(string path);

    public unowned string get_dbpath();
    public int set_dbpath(string dbpath);

    public unowned Alpm.List<string> get_cachedirs();
    public int add_cachedir(string cachedir);
    public void set_cachedirs(Alpm.List<string> cachedirs);
    public int remove_cachedir(string cachedir);

    public unowned string get_logfile();
    public int set_logfile(string logfile);

    public unowned string get_lockfile();
    /* no set_lockfile, path is determined from dbpath */

    public unowned DB* get_localdb();
    public unowned Alpm.List<DB> get_syncdbs();
  }

  /**
   * Install reasons -- ie, why the package was installed
   */
  [CCode (cname = "pmpkgreason_t", cprefix = "PM_PKG_REASON_")]
  public enum PkgReason {
    EXPLICIT = 0,
    DEPEND = 1
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

    public unowned string get_name();
    public unowned string get_url();

    public int setserver(string url);

    public int update([CCode (instance_pos = 1.1)] int level);

    public unowned Package? get_pkg(string name);
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
    public PkgReason get_reason();
    public unowned Alpm.List<string> get_licenses();
    public unowned Alpm.List<string> get_groups();
    public unowned Alpm.List<Depend*> get_depends();
    public unowned Alpm.List<string> get_optdepends();
    public unowned Alpm.List<string> get_conflicts();
    public unowned Alpm.List<string> get_provides();
    public unowned Alpm.List<string> get_replaces();
    public unowned Alpm.List<string> get_files();
    public unowned Alpm.List<string> get_backup();
    public DB* get_db();
    // changelog functions
    public size_t download_size();
  }

  /**
   * Deltas
   */
  [CCode (cname = "pmdelta_t", cprefix = "alpm_delta_")]
  [Compact]
  public struct Delta {
    public unowned string get_from();
    public unowned string get_to();
    public unowned string get_filename();
    public unowned string get_md5sum();
    public size_t get_size();
  }

  /**
   * Groups
   */
  [CCode (cname = "pmgrp_t", cprefix = "alpm_grp_")]
  [Compact]
  public struct Group {
    public unowned string get_name();
    public unowned Alpm.List<Package> get_pkgs();
  }

  /**
   * Transactions
   */

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

  public unowned Package? find_satisfier(Alpm.List<Package> pkgs, string depstring);

  [CCode (cname = "pmdepend_t", cprefix = "alpm_dep_")]
  public struct Depend {
    public DepMod get_mod();
    public unowned string get_name();
    public unowned string get_version();
    public string compute_string();
  }

  /**
   * Errors
   */
  [CCode (cname = "pmerrno_t", cprefix = "PM_ERR_")]
  public enum Error {
    MEMORY = 1,
    SYSTEM,
    BADPERMS,
    NOT_A_FILE,
    NOT_A_DIR,
    WRONG_ARGS,
    DISK_SPACE,
    /* Interface */
    HANDLE_NULL,
    HANDLE_NOT_NULL,
    HANDLE_LOCK,
    /* Databases */
    DB_OPEN,
    DB_CREATE,
    DB_NULL,
    DB_NOT_NULL,
    DB_NOT_FOUND,
    DB_WRITE,
    DB_REMOVE,
    /* Servers */
    SERVER_BAD_URL,
    SERVER_NONE,
    /* Transactions */
    TRANS_NOT_NULL,
    TRANS_NULL,
    TRANS_DUP_TARGET,
    TRANS_NOT_INITIALIZED,
    TRANS_NOT_PREPARED,
    TRANS_ABORT,
    TRANS_TYPE,
    TRANS_NOT_LOCKED,
    /* Packages */
    PKG_NOT_FOUND,
    PKG_IGNORED,
    PKG_INVALID,
    PKG_OPEN,
    PKG_CANT_REMOVE,
    PKG_INVALID_NAME,
    PKG_INVALID_ARCH,
    PKG_REPO_NOT_FOUND,
    /* Deltas */
    DLT_INVALID,
    DLT_PATCHFAILED,
    /* Dependencies */
    UNSATISFIED_DEPS,
    CONFLICTING_DEPS,
    FILE_CONFLICTS,
    /* Misc */
    RETRIEVE,
    WRITE,
    INVALID_REGEX,
    /* External library errors */
    LIBARCHIVE,
    LIBFETCH,
    EXTERNAL_DOWNLOAD
  }

  [CCode (cname = "pm_errno")]
  public extern Error errno;
}

/* vim: set ts=2 sw=2 noet: */
