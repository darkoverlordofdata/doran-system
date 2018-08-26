 /**
  * Base Object class to act as a shim/trampoline for Object virtual methods
  * GLib.Object doesn't upcast without explicit instructions,
  * so this prevents having to explicitly upcast all references based on Object.
  */
public abstract class Object : GLib.Object
{
    /**
     * Returns a string representation of the object.
     */
    public virtual string ToString()
    {
        return ((GLib.Object)this).ToString();
    }

    /**
     * Indicates whether some other object is "equal to" this one.
     */
    public virtual bool Equals(Object o)
    {
        return ((GLib.Object)this).Equals(o);
    }
    
    /**
     * Returns a hash code value for the object. This method is
     */
    public virtual int GetHashCode()
    {
        return ((GLib.Object)this).GetHashCode();
    }

    /**
     * Creates and returns a copy of this object.  The precise meaning
     * of "copy" may depend on the class of the object. 
     */
    public virtual Object Clone() throws System.Exception
    {
        if (this is System.ICloneable)
            return (Object)(GLib.Object.new(get_type()));
        throw new System.Exception.CloneNotSupportedException(get_type().name());
    }

    /**
     * Indicates whether two other objects are "equal to" this each other.
     * Generaly used to check if 2 objects contain the save value.
     */
    public static bool InstanceEquals(Object objA, Object objB)
    {
        return GLib.Object.InstanceEquals(objA, objB);
    }

    /**
     * Indicates whether two other objects are "equal to" this each other.
     * Generaly used to check if 2 object references refer to the same object.
     */
    public static bool ReferenceEquals(Object objA, Object objB)
    {
        return GLib.Object.ReferenceEquals(objA, objB);
    }
}
