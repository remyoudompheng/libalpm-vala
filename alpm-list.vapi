[CCode (cprefix = "alpm_list_", cheader_filename = "alpm_list.h")]
[Compact]
namespace Alpm {
  [CCode (cname = "alpm_list_t", type_parameters = "G")]
  [Compact]
  public class List<G> {
    [CCode (cname = "alpm_list_new")]
    public List();
    public delegate int Compare(G a, G b);

    /* item mutators */
    public List<G> add(G data);
    public List<G> copy();

    /* item accessors */
    public List<G> first();
    public List<G> nth(int n);
    [CCode (cname = "alpm_list_next")]
    public unowned List<G>? next();
    public unowned G getdata();

    /* misc */
    public int count();
    public unowned string? find_str(string needle);
  } 
}

/* vim: set ts=2 sw=2 noet: */
