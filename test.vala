using Alpm;
using Alpm.Option;

static int main(string[] args) {
  assert(args.length > 1);

  initialize();
  set_root("/");
  set_dbpath("/var/lib/pacman");

  DB *db = register_local();
  assert (db != null);

  unowned Package? p = find_satisfier(db->get_pkgcache(), args[1]);
  assert(p != null); 

 /* print depends */
  unowned Alpm.List<Depend*> deps = p.get_depends();
  stdout.printf("%d depends\n", deps.count());
  for (unowned Alpm.List<Depend*> i = deps; i != null; i = i.next())
    stdout.puts(i.getdata().compute_string() + "\n");

  /* print revdeps */
  Alpm.List<string> revdeps = p.compute_requiredby();
  stdout.printf("Required by %d packages :\n", revdeps.count());
  for (unowned Alpm.List<string> i = revdeps; i != null; i = i.next())
    stdout.puts(i.getdata() + "\n");

  release();

  return 0;
}

