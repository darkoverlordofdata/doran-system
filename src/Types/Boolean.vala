/**
 * The Boolean class wraps a value of the primitive type
 * {@code boolean} in an object. An object of type
 * {@code Boolean} contains a single field whose type is
 * {@code boolean}.
 * <p>
 * In addition, this class provides many methods for
 * converting a {@code boolean} to a {@code String} and a
 * {@code String} to a {@code boolean}, as well as other
 * constants and methods useful when dealing with a
 * {@code boolean}.
 *
 * @author  Arthur van Hoff
 * @since   JDK1.0
 */
public class System.Boolean : Comparable<Boolean>
{
    /**
     * The {@code Boolean} object corresponding to the primitive
     * value {@code true}.
     */
    private static Boolean _TRUE;
    public static Boolean TRUE { 
        get { _TRUE = _TRUE ?? new Boolean(true); return _TRUE; } }

    /**
     * The {@code Boolean} object corresponding to the primitive
     * value {@code false}.
     */
    private static Boolean _FALSE;
    public static Boolean FALSE { 
        get { _FALSE = _FALSE ?? new Boolean(false); return _FALSE; } }

    /**
     * The Class object representing the primitive type boolean.
     *
     * @since   JDK1.1
     */
    public const Type TYPE = Type.BOOLEAN;

    /**
     * The number of bytes used to represent a {@code bool} value in two's
     * complement binary form.
     *
     * @since 1.8
     */
    public const int BYTES = (int)sizeof(bool);

    /**
     * The number of bits used to represent an {@code bool} value in two's
     * complement binary form.
     *
     * @since 1.5
     */
    public const int SIZE = BYTES*8;

    /**
     * The value of the Boolean.
     *
     * @serial
     */
    private bool value;

    /**
     * Allocates a {@code Boolean} object representing the
     * {@code value} argument.
     *
     * <p><b>Note: It is rarely appropriate to use this constructor.
     * Unless a <i>new</i> instance is required, the static factory
     * {@link #valueOf(boolean)} is generally a better choice. It is
     * likely to yield significantly better space and time performance.</b>
     *
     * @param   value   the value of the {@code Boolean}.
     */
    public Boolean(bool value)
    {
        this.value = value;
    }

    /**
     * Allocates a {@code Boolean} object representing the value
     * {@code true} if the string argument is not {@code null}
     * and is equal, ignoring case, to the string {@code "true"}.
     * Otherwise, allocate a {@code Boolean} object representing the
     * value {@code false}. Examples:<p>
     * {@code new Boolean("True")} produces a {@code Boolean} object
     * that represents {@code true}.<br>
     * {@code new Boolean("yes")} produces a {@code Boolean} object
     * that represents {@code false}.
     *
     * @param   s   the string to be converted to a {@code Boolean}.
     */
    public Boolean.String(string s)
    {
        this.value = bool.parse(s);
    }

    /**
     * Parses the string argument as a boolean.  The {@code boolean}
     * returned represents the value {@code true} if the string argument
     * is not {@code null} and is equal, ignoring case, to the string
     * {@code "true"}. <p>
     * Example: {@code Boolean.parseBoolean("True")} returns {@code true}.<br>
     * Example: {@code Boolean.parseBoolean("yes")} returns {@code false}.
     *
     * @param      s   the {@code String} containing the boolean
     *                 representation to be parsed
     * @return     the boolean represented by the string argument
     * @since 1.5
     */
    public static bool ParseBoolean(string s)
    {
        return bool.parse(s);
    }

    /**
     * Returns the value of this {@code Boolean} object as a boolean
     * primitive.
     *
     * @return  the primitive {@code boolean} value of this object.
     */
    public bool BooleanValue()
    {
        return value;
    }

    /**
     * Returns a {@code Boolean} instance representing the specified
     * {@code boolean} value.  If the specified {@code boolean} value
     * is {@code true}, this method returns {@code Boolean.TRUE};
     * if it is {@code false}, this method returns {@code Boolean.FALSE}.
     * If a new {@code Boolean} instance is not required, this method
     * should generally be used in preference to the constructor
     * {@link #Boolean(boolean)}, as this method is likely to yield
     * significantly better space and time performance.
     *
     * @param  b a boolean value.
     * @return a {@code Boolean} instance representing {@code b}.
     * @since  1.4
     */
    public static Boolean Value(bool b)
    {
        return (b ? TRUE : FALSE);
    }

    /**
     * Returns a {@code Boolean} with a value represented by the
     * specified string.  The {@code Boolean} returned represents a
     * true value if the string argument is not {@code null}
     * and is equal, ignoring case, to the string {@code "true"}.
     *
     * @param   s   a string.
     * @return  the {@code Boolean} value represented by the string.
     */
    public static Boolean ValueOf(string s)
    {
        return ParseBoolean(s) ? TRUE : FALSE;
        // return new Boolean.String(s);        
    }
    
    /**
     * Returns a {@code String} object representing this Boolean's
     * value.  If this object represents the value {@code true},
     * a string equal to {@code "true"} is returned. Otherwise, a
     * string equal to {@code "false"} is returned.
     *
     * @return  a string representation of this object.
     */
    public override string ToString()
    {
        return value.to_string();
    }


    /**
     * Returns a hash code for this {@code Boolean} object.
     *
     * @return  the integer {@code 1231} if this object represents
     * {@code true}; returns the integer {@code 1237} if this
     * object represents {@code false}.
     */
    public override int GetHashCode()
    {
        return value ? 1231 : 1237;
    }

   /**
     * Returns {@code true} if and only if the argument is not
     * {@code null} and is a {@code Boolean} object that
     * represents the same {@code boolean} value as this object.
     *
     * @param   obj   the object to compare with.
     * @return  {@code true} if the Boolean objects represent the
     *          same value; {@code false} otherwise.
     */
    public override bool Equals(Object obj)
    {
        if (obj is Boolean)
            return value == ((Boolean)obj).BooleanValue();
        else
            return false;
    }

    /**
     * Compares this {@code Boolean} instance with another.
     *
     * @param   b the {@code Boolean} instance to be compared
     * @return  zero if this object represents the same boolean value as the
     *          argument; a positive value if this object represents true
     *          and the argument represents false; and a negative value if
     *          this object represents false and the argument represents true
     * @throws  NullPointerException if the argument is {@code null}
     * @see     Comparable
     * @since  1.5
     */
    public override int CompareTo(Boolean other)
    {
        return Compare(this.value, other.value);
    }


    /**
     * Compares two {@code boolean} values.
     * The value returned is identical to what would be returned by:
     * <pre>
     *    Boolean.valueOf(x).compareTo(Boolean.valueOf(y))
     * </pre>
     *
     * @param  x the first {@code boolean} to compare
     * @param  y the second {@code boolean} to compare
     * @return the value {@code 0} if {@code x == y};
     *         a value less than {@code 0} if {@code !x && y}; and
     *         a value greater than {@code 0} if {@code x && !y}
     * @since 1.7
     */
    public static int Compare(bool x, bool y)
    {
        return (x == y) ? 0 : ( x ? 1 : -1 );
    }
} 