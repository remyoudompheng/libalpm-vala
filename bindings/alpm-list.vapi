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
