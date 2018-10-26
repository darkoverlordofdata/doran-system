/**
 * The {@code Short} class wraps a value of primitive type {@code
 * short} in an object.  An object of type {@code Short} contains a
 * single field whose type is {@code short}.
 *
 * <p>In addition, this class provides several methods for converting
 * a {@code short} to a {@code String} and a {@code String} to a
 * {@code short}, as well as other constants and methods useful when
 * dealing with a {@code short}.
 *
 * @author  Nakul Saraiya
 * @author  Joseph D. Darcy
 * @see     java.lang.Number
 * @since   JDK1.1
 */
public class System.Short : Number<Short>
{

    /**
     * A constant holding the minimum value a {@code short} can
     * have, -2<sup>15</sup>.
     */
    public const short MIN_VALUE = short.MIN;

    /**
     * A constant holding the maximum value a {@code short} can
     * have, 2<sup>15</sup>-1.
     */
    public const short MAX_VALUE = short.MAX;

    /**
     * The number of bits used to represent a {@code short} value in two's
     * complement binary form.
     * @since 1.5
     */
    public const int SIZE = BYTES*8;

    /**
     * The number of bytes used to represent a {@code short} value in two's
     * complement binary form.
     *
     * @since 1.8
     */
    public const int BYTES = (int)sizeof(short);

    /**
     * The {@code Class} instance representing the primitive type
     * {@code short}.
     */
    public const Type TYPE = Type.SHORT;

    /**
     * Parses the string argument as a signed {@code short} in the
     * radix specified by the second argument. The characters in the
     * string must all be digits, of the specified radix (as
     * determined by whether {@link java.lang.Character#digit(char,
     * int)} returns a nonnegative value) except that the first
     * character may be an ASCII minus sign {@code '-'}
     * ({@code '\u005Cu002D'}) to indicate a negative value or an
     * ASCII plus sign {@code '+'} ({@code '\u005Cu002B'}) to
     * indicate a positive value.  The resulting {@code short} value
     * is returned.
     *
     * <p>An exception of type {@code NumberFormatException} is
     * thrown if any of the following situations occurs:
     * <ul>
     * <li> The first argument is {@code null} or is a string of
     * length zero.
     *
     * <li> The radix is either smaller than {@link
     * java.lang.Character#MIN_RADIX} or larger than {@link
     * java.lang.Character#MAX_RADIX}.
     *
     * <li> Any character of the string is not a digit of the
     * specified radix, except that the first character may be a minus
     * sign {@code '-'} ({@code '\u005Cu002D'}) or plus sign
     * {@code '+'} ({@code '\u005Cu002B'}) provided that the
     * string is longer than length 1.
     *
     * <li> The value represented by the string is not a value of type
     * {@code short}.
     * </ul>
     *
     * @param s         the {@code String} containing the
     *                  {@code short} representation to be parsed
     * @param radix     the radix to be used while parsing {@code s}
     * @return          the {@code short} represented by the string
     *                  argument in the specified radix.
     * @throws          NumberFormatException If the {@code String}
     *                  does not contain a parsable {@code short}.
     */
    public static short ParseShort(string s, int radix = 10)
        throws Exception
    {
        int i = Integer.ParseInt(s, radix);
        if (i < MIN_VALUE || i > MAX_VALUE)
            throw new Exception.NumberFormatException(
                @"Value out of range. Value:\"$s\" Radix: $radix");
        return (short)i;
    }

    /**
     * Returns a {@code Short} object holding the value
     * extracted from the specified {@code String} when parsed
     * with the radix given by the second argument. The first argument
     * is interpreted as representing a signed {@code short} in
     * the radix specified by the second argument, exactly as if the
     * argument were given to the {@link #parseShort(java.lang.String,
     * int)} method. The result is a {@code Short} object that
     * represents the {@code short} value specified by the string.
     *
     * <p>In other words, this method returns a {@code Short} object
     * equal to the value of:
     *
     * <blockquote>
     *  {@code new Short(Short.parseShort(s, radix))}
     * </blockquote>
     *
     * @param s         the string to be parsed
     * @param radix     the radix to be used in interpreting {@code s}
     * @return          a {@code Short} object holding the value
     *                  represented by the string argument in the
     *                  specified radix.
     * @throws          NumberFormatException If the {@code String} does
     *                  not contain a parsable {@code short}.
     */
    public static Short ValueOf(string s, int radix = 10)
        throws Exception
    {
        return new Short(ParseShort(s, radix));
    }
    
    /**
     * Returns a {@code Short} instance representing the specified
     * {@code short} value.
     * If a new {@code Short} instance is not required, this method
     * should generally be used in preference to the constructor
     * {@link #Short(short)}, as this method is likely to yield
     * significantly better space and time performance by caching
     * frequently requested values.
     *
     * This method will always cache values in the range -128 to 127,
     * inclusive, and may cache other values outside of this range.
     *
     * @param  s a short value.
     * @return a {@code Short} instance representing {@code s}.
     * @since  1.5
     */
    public static Short Value(short s)
    {
        return new Short(s);        
    }
    
    /**
     * The value of the {@code Short}.
     *
     * @serial
     */
    private short value;

    /**
     * Constructs a newly allocated {@code Short} object that
     * represents the specified {@code short} value.
     *
     * @param value     the value to be represented by the
     *                  {@code Short}.
     */
    public Short(short value)
    {
        this.value = value;
    }

    /**
     * Constructs a newly allocated {@code Short} object that
     * represents the {@code short} value indicated by the
     * {@code String} parameter. The string is converted to a
     * {@code short} value in exactly the manner used by the
     * {@code parseShort} method for radix 10.
     *
     * @param s the {@code String} to be converted to a
     *          {@code Short}
     * @throws  NumberFormatException If the {@code String}
     *          does not contain a parsable {@code short}.
     * @see     java.lang.Short#parseShort(java.lang.String, int)
     */
    public Short.String(string s)
    {
        this.value = ParseShort(s, 10);
    }

    /**
     * Returns the value of this {@code Short} as a {@code byte} after
     * a narrowing primitive conversion.
     * @jls 5.1.3 Narrowing Primitive Conversions
     */
    public override char CharValue()
    {
        return (char)value;
    }

    /**
     * Returns the value of this {@code Short} as a
     * {@code short}.
     */
    public override short ShortValue()
    {
        return (short)value;
    }

    /**
     * Returns the value of this {@code Short} as an {@code int} after
     * a widening primitive conversion.
     * @jls 5.1.2 Widening Primitive Conversions
     */
    public override int IntValue()
    {
        return (int)value;
    }

    /**
     * Returns the value of this {@code Short} as a {@code long} after
     * a widening primitive conversion.
     * @jls 5.1.2 Widening Primitive Conversions
     */
    public override long LongValue()
    {
        return (long)value;
    }

    /**
     * Returns the value of this {@code Short} as a {@code float}
     * after a widening primitive conversion.
     * @jls 5.1.2 Widening Primitive Conversions
     */
    public override float FloatValue()
    {
        return (float)value;
    }

    /**
     * Returns the value of this {@code Short} as a {@code double}
     * after a widening primitive conversion.
     * @jls 5.1.2 Widening Primitive Conversions
     */
    public override double DoubleValue()
    {
        return (double)value;
    }

    /**
     * Returns a {@code String} object representing this
     * {@code Short}'s value.  The value is converted to signed
     * decimal representation and returned as a string, exactly as if
     * the {@code short} value were given as an argument to the
     * {@link java.lang.Short#toString(short)} method.
     *
     * @return  a string representation of the value of this object in
     *          base&nbsp;10.
     */
    public override string ToString()
    {
        return value.to_string();
    }

    /**
     * Returns a hash code for this {@code Short}; equal to the result
     * of invoking {@code intValue()}.
     *
     * @return a hash code value for this {@code Short}
     */
    public override int GetHashCode()
    {
        return (int)value;
    }

    /**
     * Compares this object to the specified object.  The result is
     * {@code true} if and only if the argument is not
     * {@code null} and is a {@code Short} object that
     * contains the same {@code short} value as this object.
     *
     * @param obj       the object to compare with
     * @return          {@code true} if the objects are the same;
     *                  {@code false} otherwise.
     */
    public override bool Equals(Object obj)
    {
        if (obj is Short)
            return value == ((Short)obj).ShortValue();
        else
            return false;

    }

    /**
     * Compares two {@code Short} objects numerically.
     *
     * @param   anotherShort   the {@code Short} to be compared.
     * @return  the value {@code 0} if this {@code Short} is
     *          equal to the argument {@code Short}; a value less than
     *          {@code 0} if this {@code Short} is numerically less
     *          than the argument {@code Short}; and a value greater than
     *           {@code 0} if this {@code Short} is numerically
     *           greater than the argument {@code Short} (signed
     *           comparison).
     * @since   1.2
     */
    public override int CompareTo(Short other)
    {
        return Compare(this.value, other.value);
    }

    /**
     * Compares two {@code short} values numerically.
     * The value returned is identical to what would be returned by:
     * <pre>
     *    Short.valueOf(x).compareTo(Short.valueOf(y))
     * </pre>
     *
     * @param  x the first {@code short} to compare
     * @param  y the second {@code short} to compare
     * @return the value {@code 0} if {@code x == y};
     *         a value less than {@code 0} if {@code x < y}; and
     *         a value greater than {@code 0} if {@code x > y}
     * @since 1.7
     */
    public static int Compare(short x, short y)
    {
        return (x < y) ? -1 : (( x == y ) ? 0 : 1);
    }


} 