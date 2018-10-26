/**
 * The {@code Float} class wraps a value of primitive type
 * {@code float} in an object. An object of type
 * {@code Float} contains a single field whose type is
 * {@code float}.
 *
 * <p>In addition, this class provides several methods for converting a
 * {@code float} to a {@code String} and a
 * {@code String} to a {@code float}, as well as other
 * constants and methods useful when dealing with a
 * {@code float}.
 *
 * @author  Lee Boynton
 * @author  Arthur van Hoff
 * @author  Joseph D. Darcy
 * @since JDK1.0
 */
public class System.Float : Number<Float>
{
    /**
     * A constant holding the largest positive finite value of type
     * {@code float}, (2-2<sup>-23</sup>)&middot;2<sup>127</sup>.
     * It is equal to the hexadecimal floating-point literal
     * {@code 0x1.fffffeP+127f} and also equal to
     * {@code Float.intBitsToFloat(0x7f7fffff)}.
     */
    public const float MAX_VALUE = float.MAX;

    /**
     * A constant holding the smallest positive nonzero value of type
     * {@code float}, 2<sup>-149</sup>. It is equal to the
     * hexadecimal floating-point literal {@code 0x0.000002P-126f}
     * and also equal to {@code Float.intBitsToFloat(0x1)}.
     */
    public const float MIN_VALUE = float.MIN;


    /**
     * The number of bits used to represent a {@code float} value.
     *
     * @since 1.5
     */
    public const int SIZE = BYTES*8;

    /**
     * The number of bytes used to represent a {@code float} value.
     *
     * @since 1.8
     */
    public const int BYTES = (int)sizeof(float);

    /**
     * The {@code Class} instance representing the primitive type
     * {@code float}.
     *
     * @since JDK1.1
     */
    public const Type TYPE = Type.FLOAT;

    /**
     * Returns a {@code Float} object holding the
     * {@code float} value represented by the argument string
     * {@code s}.
     *
     * <p>If {@code s} is {@code null}, then a
     * {@code NullPointerException} is thrown.
     *
     * @param   s   the string to be parsed.
     * @return  a {@code Float} object holding the value
     *          represented by the {@code String} argument.
     * @throws  NumberFormatException  if the string does not contain a
     *          parsable number.
     */
    public static Float ValueOf(string s)
    {
        return new Float(ParseFloat(s));        
    }
    
    /**
     * Returns a {@code Float} instance representing the specified
     * {@code float} value.
     * If a new {@code Float} instance is not required, this method
     * should generally be used in preference to the constructor
     * {@link #Float(float)}, as this method is likely to yield
     * significantly better space and time performance by caching
     * frequently requested values.
     *
     * @param  f a float value.
     * @return a {@code Float} instance representing {@code f}.
     * @since  1.5
     */
    public static Float Value(float f)
    {
        return new Float(f);        
    }
    
    /**
     * Returns a new {@code float} initialized to the value
     * represented by the specified {@code String}, as performed
     * by the {@code valueOf} method of class {@code Float}.
     *
     * @param  s the string to be parsed.
     * @return the {@code float} value represented by the string
     *         argument.
     * @throws NullPointerException  if the string is null
     * @throws NumberFormatException if the string does not contain a
     *               parsable {@code float}.
     * @see    java.lang.Float#valueOf(String)
     * @since 1.2
     */
    public static float ParseFloat(string s)
    {
        return (float)double.parse(s);
    }

    /**
     * The value of the Float.
     *
     * @serial
     */
    private float value;

    /**
     * Constructs a newly allocated {@code Float} object that
     * represents the primitive {@code float} argument.
     *
     * @param   value   the value to be represented by the {@code Float}.
     */
    public Float(float value)
    {
        this.value = value;
    }

    /**
     * Constructs a newly allocated {@code Float} object that
     * represents the argument converted to type {@code float}.
     *
     * @param   value   the value to be represented by the {@code Float}.
     */
    public Float.Double(double value)
    {
        this.value = (float)value;
    }

    /**
     * Constructs a newly allocated {@code Float} object that
     * represents the floating-point value of type {@code float}
     * represented by the string. The string is converted to a
     * {@code float} value as if by the {@code valueOf} method.
     *
     * @param      s   a string to be converted to a {@code Float}.
     * @throws  NumberFormatException  if the string does not contain a
     *               parsable number.
     * @see        java.lang.Float#valueOf(java.lang.String)
     */
    public Float.String(string s)
    {
        this.value = ParseFloat(s);
    }

    /**
     * Returns {@code true} if the specified number is a
     * Not-a-Number (NaN) value, {@code false} otherwise.
     *
     * @param   v   the value to be tested.
     * @return  {@code true} if the argument is NaN;
     *          {@code false} otherwise.
     */
    public bool IsNaN()
    {
        return value.is_nan();
    }

    /**
     * Returns {@code true} if the specified number is infinitely
     * large in magnitude, {@code false} otherwise.
     *
     * @param   v   the value to be tested.
     * @return  {@code true} if the argument is positive infinity or
     *          negative infinity; {@code false} otherwise.
     */
    public bool IsInfinite()
    {
        return value.is_infinity() != 0;
    }

    /**
     * Returns a string representation of this {@code Float} object.
     * The primitive {@code float} value represented by this object
     * is converted to a {@code String} exactly as if by the method
     * {@code toString} of one argument.
     *
     * @return  a {@code String} representation of this object.
     * @see java.lang.Float#toString(float)
     */
    public override string ToString()
    {
        return value.to_string();
    }

    /**
     * Returns the value of this {@code Float} as a {@code byte} after
     * a narrowing primitive conversion.
     *
     * @return  the {@code float} value represented by this object
     *          converted to type {@code byte}
     * @jls 5.1.3 Narrowing Primitive Conversions
     */
    public override char CharValue()
    {
        return (char)value;
    }

    /**
     * Returns the value of this {@code Float} as a {@code short}
     * after a narrowing primitive conversion.
     *
     * @return  the {@code float} value represented by this object
     *          converted to type {@code short}
     * @jls 5.1.3 Narrowing Primitive Conversions
     * @since JDK1.1
     */
    public override short ShortValue()
    {
        return (short)value;
    }

    /**
     * Returns the value of this {@code Float} as an {@code int} after
     * a narrowing primitive conversion.
     *
     * @return  the {@code float} value represented by this object
     *          converted to type {@code int}
     * @jls 5.1.3 Narrowing Primitive Conversions
     */
    public override int IntValue()
    {
        return (int)value;
    }

    /**
     * Returns value of this {@code Float} as a {@code long} after a
     * narrowing primitive conversion.
     *
     * @return  the {@code float} value represented by this object
     *          converted to type {@code long}
     * @jls 5.1.3 Narrowing Primitive Conversions
     */
    public override long LongValue()
    {
        return (long)value;
    }

    /**
     * Returns the {@code float} value of this {@code Float} object.
     *
     * @return the {@code float} value represented by this object
     */
    public override float FloatValue()
    {
        return (float)value;
    }

    /**
     * Returns the value of this {@code Float} as a {@code double}
     * after a widening primitive conversion.
     *
     * @return the {@code float} value represented by this
     *         object converted to type {@code double}
     * @jls 5.1.2 Widening Primitive Conversions
     */
    public override double DoubleValue()
    {
        return (double)value;
    }

    /**
     * Returns a hash code for this {@code Float} object. The
     * result is the integer bit representation, exactly as produced
     * by the method {@link #floatToIntBits(float)}, of the primitive
     * {@code float} value represented by this {@code Float}
     * object.
     *
     * @return a hash code value for this object.
     */
    public override int GetHashCode()
    {
        if (this.value == 0) return 0;
        long value = *(long*)(&this.value);
        return ((int)value) ^ ((int)(value >> 32));
    }

    /**

     * Compares this object against the specified object.  The result
     * is {@code true} if and only if the argument is not
     * {@code null} and is a {@code Float} object that
     * represents a {@code float} with the same value as the
     * {@code float} represented by this object. For this
     * purpose, two {@code float} values are considered to be the
     * same if and only if the method {@link #floatToIntBits(float)}
     * returns the identical {@code int} value when applied to
     * each.
     *
     * <p>Note that in most cases, for two instances of class
     * {@code Float}, {@code f1} and {@code f2}, the value
     * of {@code f1.equals(f2)} is {@code true} if and only if
     *
     * <blockquote><pre>
     *   f1.floatValue() == f2.floatValue()
     * </pre></blockquote>
     *
     * <p>also has the value {@code true}. However, there are two exceptions:
     * <ul>
     * <li>If {@code f1} and {@code f2} both represent
     *     {@code Float.NaN}, then the {@code equals} method returns
     *     {@code true}, even though {@code Float.NaN==Float.NaN}
     *     has the value {@code false}.
     * <li>If {@code f1} represents {@code +0.0f} while
     *     {@code f2} represents {@code -0.0f}, or vice
     *     versa, the {@code equal} test has the value
     *     {@code false}, even though {@code 0.0f==-0.0f}
     *     has the value {@code true}.
     * </ul>
     *
     * This definition allows hash tables to operate properly.
     *
     * @param obj the object to be compared
     * @return  {@code true} if the objects are the same;
     *          {@code false} otherwise.
     * @see java.lang.Float#floatToIntBits(float)
     */
    public override bool Equals(Object obj)
    {
        if (obj is Float)
            return value == ((Float)obj).FloatValue();
        else
            return false;

    }

    /**
     * Compares two {@code Float} objects numerically.  There are
     * two ways in which comparisons performed by this method differ
     * from those performed by the Java language numerical comparison
     * operators ({@code <, <=, ==, >=, >}) when
     * applied to primitive {@code float} values:
     *
     * <ul><li>
     *          {@code Float.NaN} is considered by this method to
     *          be equal to itself and greater than all other
     *          {@code float} values
     *          (including {@code Float.POSITIVE_INFINITY}).
     * <li>
     *          {@code 0.0f} is considered by this method to be greater
     *          than {@code -0.0f}.
     * </ul>
     *
     * This ensures that the <i>natural ordering</i> of {@code Float}
     * objects imposed by this method is <i>consistent with equals</i>.
     *
     * @param   anotherFloat   the {@code Float} to be compared.
     * @return  the value {@code 0} if {@code anotherFloat} is
     *          numerically equal to this {@code Float}; a value
     *          less than {@code 0} if this {@code Float}
     *          is numerically less than {@code anotherFloat};
     *          and a value greater than {@code 0} if this
     *          {@code Float} is numerically greater than
     *          {@code anotherFloat}.
     *
     * @since   1.2
     * @see Comparable#compareTo(Object)
     */
    public override int CompareTo(Float other)
    {
        return Compare(this.value, other.value);
    }

    /**
     * Compares the two specified {@code float} values. The sign
     * of the integer value returned is the same as that of the
     * integer that would be returned by the call:
     * <pre>
     *    new Float(f1).compareTo(new Float(f2))
     * </pre>
     *
     * @param   f1        the first {@code float} to compare.
     * @param   f2        the second {@code float} to compare.
     * @return  the value {@code 0} if {@code f1} is
     *          numerically equal to {@code f2}; a value less than
     *          {@code 0} if {@code f1} is numerically less than
     *          {@code f2}; and a value greater than {@code 0}
     *          if {@code f1} is numerically greater than
     *          {@code f2}.
     * @since 1.4
     */
    public static int Compare(float x, float y)
    {
        return (x < y) ? -1 : (( x == y ) ? 0 : 1);
    }

    /**
     * Returns a representation of the specified floating-point value
     * according to the IEEE 754 floating-point "single format" bit
     * layout, preserving Not-a-Number (NaN) values.
     *
     * <p>Bit 31 (the bit that is selected by the mask
     * {@code 0x80000000}) represents the sign of the floating-point
     * number.
     * Bits 30-23 (the bits that are selected by the mask
     * {@code 0x7f800000}) represent the exponent.
     * Bits 22-0 (the bits that are selected by the mask
     * {@code 0x007fffff}) represent the significand (sometimes called
     * the mantissa) of the floating-point number.
     *
     * <p>If the argument is positive infinity, the result is
     * {@code 0x7f800000}.
     *
     * <p>If the argument is negative infinity, the result is
     * {@code 0xff800000}.
     *
     * <p>If the argument is NaN, the result is the integer representing
     * the actual NaN value.  Unlike the {@code floatToIntBits}
     * method, {@code floatToRawIntBits} does not collapse all the
     * bit patterns encoding a NaN to a single "canonical"
     * NaN value.
     *
     * <p>In all cases, the result is an integer that, when given to the
     * {@link #intBitsToFloat(int)} method, will produce a
     * floating-point value the same as the argument to
     * {@code floatToRawIntBits}.
     *
     * @param   value   a floating-point number.
     * @return the bits that represent the floating-point number.
     * @since 1.3
     */
    public static int FloatToRawIntBits(float value)
    {
        float f = value;
        int i = 0;
        Memory.copy(&i, &f, 4);
        return i;
    }

    /**
     * Bit mask to isolate the exponent field of a
     * <code>float</code>.
     */
    public const int     EXP_BIT_MASK    = 0x7F800000;

    /**
     * Bit mask to isolate the significand field of a
     * <code>float</code>.
     */
    public const int     SIGNIF_BIT_MASK = 0x007FFFFF;

    /**
     * Returns a representation of the specified floating-point value
     * according to the IEEE 754 floating-point "single format" bit
     * layout.
     *
     * <p>Bit 31 (the bit that is selected by the mask
     * {@code 0x80000000}) represents the sign of the floating-point
     * number.
     * Bits 30-23 (the bits that are selected by the mask
     * {@code 0x7f800000}) represent the exponent.
     * Bits 22-0 (the bits that are selected by the mask
     * {@code 0x007fffff}) represent the significand (sometimes called
     * the mantissa) of the floating-point number.
     *
     * <p>If the argument is positive infinity, the result is
     * {@code 0x7f800000}.
     *
     * <p>If the argument is negative infinity, the result is
     * {@code 0xff800000}.
     *
     * <p>If the argument is NaN, the result is {@code 0x7fc00000}.
     *
     * <p>In all cases, the result is an integer that, when given to the
     * {@link #intBitsToFloat(int)} method, will produce a floating-point
     * value the same as the argument to {@code floatToIntBits}
     * (except all NaN values are collapsed to a single
     * "canonical" NaN value).
     *
     * @param   value   a floating-point number.
     * @return the bits that represent the floating-point number.
     */
    public static int FloatToIntBits(float value) {
        int result = FloatToRawIntBits(value);
        // Check for NaN based on values of bit fields, maximum
        // exponent and nonzero significand.
        if ( ((result & EXP_BIT_MASK) ==
              EXP_BIT_MASK) &&
             (result & SIGNIF_BIT_MASK) != 0)
            result = 0x7fc00000;
        return result;
    }



} 