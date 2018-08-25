 /**
  * Base Object class to act as a shim/trampoline for Object virtual methods
  * GLib.Object doesn't upcast without explicit instructions,
  * so this prevents having to explicitly upcast all references based on Object.
  */
public abstract class Object : GLib.Object
{
    public virtual string ToString()
    {
        return ((GLib.Object)this).ToString();
    }
    public virtual bool Equals(Object o)
    {
        return ((GLib.Object)this).Equals(o);
    }
    public virtual int GetHashCode()
    {
        return ((GLib.Object)this).GetHashCode();
    }
    public static bool InstanceEquals(Object objA, Object objB)
    {
        return GLib.Object.InstanceEquals(objA, objB);
    }
    public static bool ReferenceEquals(Object objA, Object objB)
    {
        return GLib.Object.ReferenceEquals(objA, objB);
    }
}
