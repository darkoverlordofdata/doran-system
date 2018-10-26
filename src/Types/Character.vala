using System.Collections.Generic;
/**
 *
 * The {@code Byte} class wraps a value of primitive type {@code byte}
 * in an object.  An object of type {@code Byte} contains a single
 * field whose type is {@code byte}.
 *
 * <p>In addition, this class provides several methods for converting
 * a {@code byte} to a {@code String} and a {@code String} to a {@code
 * byte}, as well as other constants and methods useful when dealing
 * with a {@code byte}.
 *
 * @author  Nakul Saraiya
 * @author  Joseph D. Darcy
 * @see     java.lang.Number
 * @since   JDK1.1
 */
public class System.Character : Number<Character>
{
    /**
     * The minimum radix available for conversion to and from strings.
     * The constant value of this field is the smallest value permitted
     * for the radix argument in radix-conversion methods such as the
     * {@code digit} method, the {@code forDigit} method, and the
     * {@code toString} method of class {@code Integer}.
     *
     * @see     Character#digit(char, int)
     * @see     Character#forDigit(int, int)
     * @see     Integer#toString(int, int)
     * @see     Integer#valueOf(String)
     */
    public const int MIN_RADIX = 2;

    /**
     * The maximum radix available for conversion to and from strings.
     * The constant value of this field is the largest value permitted
     * for the radix argument in radix-conversion methods such as the
     * {@code digit} method, the {@code forDigit} method, and the
     * {@code toString} method of class {@code Integer}.
     *
     * @see     Character#digit(char, int)
     * @see     Character#forDigit(int, int)
     * @see     Integer#toString(int, int)
     * @see     Integer#valueOf(String)
     */
    public const int MAX_RADIX = 36;
    /**
     * A constant holding the minimum value a {@code byte} can
     * have, -2<sup>7</sup>.
     */
    public const char MIN_VALUE = -(char)128;

    /**
     * A constant holding the maximum value a {@code byte} can
     * have, 2<sup>7</sup>-1.
     */
    public const char MAX_VALUE = 127;

    /**
     * The {@code Class} instance representing the primitive type
     * {@code byte}.
     */
    public const Type TYPE = Type.CHAR;

    /**
     * The number of bytes used to represent a {@code char} value in two's
     * complement binary form.
     *
     * @since 1.8
     */
    public const int BYTES = (int)sizeof(char);

    /**
     * The number of bits used to represent an {@code char} value in two's
     * complement binary form.
     *
     * @since 1.5
     */
    public const int SIZE = BYTES*8;

    /**
     * The minimum value of a
     * <a href="http://www.unicode.org/glossary/#supplementary_code_point">
     * Unicode supplementary code point</a>, constant {@code U+10000}.
     *
     * @since 1.5
     */
    public const int MIN_SUPPLEMENTARY_CODE_POINT = 0x010000;


    /**
     * The minimum value of a
     * <a href="http://www.unicode.org/glossary/#high_surrogate_code_unit">
     * Unicode high-surrogate code unit</a>
     * in the UTF-16 encoding, constant {@code '\u005CuD800'}.
     * A high-surrogate is also known as a <i>leading-surrogate</i>.
     *
     * @since 1.5
     */
    public const unichar MIN_HIGH_SURROGATE = 0xd800; //'\uD800';

    /**
     * The maximum value of a
     * <a href="http://www.unicode.org/glossary/#high_surrogate_code_unit">
     * Unicode high-surrogate code unit</a>
     * in the UTF-16 encoding, constant {@code '\u005CuDBFF'}.
     * A high-surrogate is also known as a <i>leading-surrogate</i>.
     *
     * @since 1.5
     */
    public const unichar MAX_HIGH_SURROGATE = 0xdbff; // '\uDBFF';

    /**
     * The minimum value of a Unicode surrogate code unit in the
     * UTF-16 encoding, constant {@code '\u005CuD800'}.
     *
     * @since 1.5
     */

    public const unichar MIN_SURROGATE = MIN_HIGH_SURROGATE;
    /**
     * The minimum value of a
     * <a href="http://www.unicode.org/glossary/#low_surrogate_code_unit">
     * Unicode low-surrogate code unit</a>
     * in the UTF-16 encoding, constant {@code '\u005CuDC00'}.
     * A low-surrogate is also known as a <i>trailing-surrogate</i>.
     *
     * @since 1.5
     */
    public const unichar MIN_LOW_SURROGATE  =  0xdc00;//'\uDC00';

    /**
     * The maximum value of a
     * <a href="http://www.unicode.org/glossary/#low_surrogate_code_unit">
     * Unicode low-surrogate code unit</a>
     * in the UTF-16 encoding, constant {@code '\u005CuDFFF'}.
     * A low-surrogate is also known as a <i>trailing-surrogate</i>.
     *
     * @since 1.5
     */
    public const unichar MAX_LOW_SURROGATE  = 0xdfff; // '\uDFFF';

    /**
     * The maximum value of a Unicode surrogate code unit in the
     * UTF-16 encoding, constant {@code '\u005CuDFFF'}.
     *
     * @since 1.5
     */
    public const unichar MAX_SURROGATE = MAX_LOW_SURROGATE;

    /**
     * The minimum value of a
     * <a href="http://www.unicode.org/glossary/#code_point">
     * Unicode code point</a>, constant {@code U+0000}.
     *
     * @since 1.5
     */
    public const int MIN_CODE_POINT = 0x000000;

    /**
     * The maximum value of a
     * <a href="http://www.unicode.org/glossary/#code_point">
     * Unicode code point</a>, constant {@code U+10FFFF}.
     *
     * @since 1.5
     */
    public const int MAX_CODE_POINT = 0x10FFFF;


    private class CharCache
    {
        public static Character[] cache = new Character[256];
        static construct {
            print("Do I get Here?\n");
            for(int i = 0; i < cache.length; i++)
                cache[i] = new Character((char)(i - 128));
        }

    }


    /**
     * Returns a {@code Byte} instance representing the specified
     * {@code byte} value.
     * If a new {@code Byte} instance is not required, this method
     * should generally be used in preference to the constructor
     * {@link #Byte(byte)}, as this method is likely to yield
     * significantly better space and time performance since
     * all byte values are cached.
     *
     * @param  b a byte value.
     * @return a {@code Byte} instance representing {@code b}.
     * @since  1.5
     */
    public static Character Value(char c)
    {
        // return CharCache.cache[(int)c+128];
        return new Character(c);
    }

    /**
     * Parses the string argument as a signed decimal {@code
     * byte}. The characters in the string must all be decimal digits,
     * except that the first character may be an ASCII minus sign
     * {@code '-'} ({@code '\u005Cu002D'}) to indicate a negative
     * value or an ASCII plus sign {@code '+'}
     * ({@code '\u005Cu002B'}) to indicate a positive value. The
     * resulting {@code byte} value is returned, exactly as if the
     * argument and the radix 10 were given as arguments to the {@link
     * #parseByte(java.lang.String, int)} method.
     *
     * @param s         a {@code String} containing the
     *                  {@code byte} representation to be parsed
     * @return          the {@code byte} value represented by the
     *                  argument in decimal
     * @throws          NumberFormatException if the string does not
     *                  contain a parsable {@code byte}.
     */
    public static char ParseChar(string s, int radix = 10) 
        throws Exception
    {
        int i = Integer.ParseInt(s, radix);
        if (i < MIN_VALUE || i > MAX_VALUE)
            throw new Exception.NumberFormatException(
                @"Value out of range. Value:\"$s\" Radix: $radix");
        return (char)i;
    }

    /**
     * Returns a {@code Byte} object holding the value
     * extracted from the specified {@code String} when parsed
     * with the radix given by the second argument. The first argument
     * is interpreted as representing a signed {@code byte} in
     * the radix specified by the second argument, exactly as if the
     * argument were given to the {@link #parseByte(java.lang.String,
     * int)} method. The result is a {@code Byte} object that
     * represents the {@code byte} value specified by the string.
     *
     * <p> In other words, this method returns a {@code Byte} object
     * equal to the value of:
     *
     * <blockquote>
     * {@code new Byte(Byte.parseByte(s, radix))}
     * </blockquote>
     *
     * @param s         the string to be parsed
     * @param radix     the radix to be used in interpreting {@code s}
     * @return          a {@code Byte} object holding the value
     *                  represented by the string argument in the
     *                  specified radix.
     * @throws          NumberFormatException If the {@code String} does
     *                  not contain a parsable {@code byte}.
     */
    public static Character ValueOf(string s, int radix=10) 
        throws Exception
    {
        return Value(ParseChar(s, radix));
    }
    
    /**
     * The value of the {@code Byte}.
     *
     * @serial
     */
    private char value;

    /**
     * Constructs a newly allocated {@code Byte} object that
     * represents the specified {@code byte} value.
     *
     * @param value     the value to be represented by the
     *                  {@code Byte}.
     */
    public Character(char value)
    {
        this.value = value;
    }

    /**
     * Constructs a newly allocated {@code Byte} object that
     * represents the {@code byte} value indicated by the
     * {@code String} parameter. The string is converted to a
     * {@code byte} value in exactly the manner used by the
     * {@code parseByte} method for radix 10.
     *
     * @param s         the {@code String} to be converted to a
     *                  {@code Byte}
     * @throws           NumberFormatException If the {@code String}
     *                  does not contain a parsable {@code byte}.
     * @see        java.lang.Byte#parseByte(java.lang.String, int)
     */
    public Character.String(string s) throws Exception
    {
        this.value = ParseChar(s, 10);
    }

    /**
     * Returns the value of this {@code Byte} as a
     * {@code byte}.
     */
    public override char CharValue()
    {
        return value;
    }

    /**
     * Returns the value of this {@code Byte} as a {@code short} after
     * a widening primitive conversion.
     * @jls 5.1.2 Widening Primitive Conversions
     */
    public override short ShortValue()
    {
        return (short)value;
    }

    /**
     * Returns the value of this {@code Byte} as an {@code int} after
     * a widening primitive conversion.
     * @jls 5.1.2 Widening Primitive Conversions
     */
    public override int IntValue()
    {
        return (int)value;
    }

    /**
     * Returns the value of this {@code Byte} as a {@code long} after
     * a widening primitive conversion.
     * @jls 5.1.2 Widening Primitive Conversions
     */
    public override long LongValue()
    {
        return (long)value;
    }

    /**
     * Returns the value of this {@code Byte} as a {@code float} after
     * a widening primitive conversion.
     * @jls 5.1.2 Widening Primitive Conversions
     */
    public override float FloatValue()
    {
        return (float)value;
    }

    /**
     * Returns the value of this {@code Byte} as a {@code double}
     * after a widening primitive conversion.
     * @jls 5.1.2 Widening Primitive Conversions
     */
    public override double DoubleValue()
    {
        return (double)value;
    }

    /**
     * Returns a {@code String} object representing this
     * {@code Byte}'s value.  The value is converted to signed
     * decimal representation and returned as a string, exactly as if
     * the {@code byte} value were given as an argument to the
     * {@link java.lang.Byte#toString(byte)} method.
     *
     * @return  a string representation of the value of this object in
     *          base&nbsp;10.
     */
    public override string ToString()
    {
        return value.to_string();
    }

    /**
     * Determines the number of {@code char} values needed to
     * represent the specified character (Unicode code point). If the
     * specified character is equal to or greater than 0x10000, then
     * the method returns 2. Otherwise, the method returns 1.
     *
     * <p>This method doesn't validate the specified character to be a
     * valid Unicode code point. The caller must validate the
     * character value using {@link #isValidCodePoint(int) isValidCodePoint}
     * if necessary.
     *
     * @param   codePoint the character (Unicode code point) to be tested.
     * @return  2 if the character is a valid supplementary character; 1 otherwise.
     * @see     Character#isSupplementaryCodePoint(int)
     * @since   1.5
     */
    public static int CharCount(int codePoint)
    {
        return codePoint >= MIN_SUPPLEMENTARY_CODE_POINT ? 2 : 1;
        // return ((unichar)c).iswide() ? 2 : 1;
    }
    
    /**
     * Determines if the given {@code char} value is a Unicode
     * <i>surrogate code unit</i>.
     *
     * <p>Such values do not represent characters by themselves,
     * but are used in the representation of
     * <a href="#supplementary">supplementary characters</a>
     * in the UTF-16 encoding.
     *
     * <p>A char value is a surrogate code unit if and only if it is either
     * a {@linkplain #isLowSurrogate(char) low-surrogate code unit} or
     * a {@linkplain #isHighSurrogate(char) high-surrogate code unit}.
     *
     * @param  ch the {@code char} value to be tested.
     * @return {@code true} if the {@code char} value is between
     *         {@link #MIN_SURROGATE} and
     *         {@link #MAX_SURROGATE} inclusive;
     *         {@code false} otherwise.
     * @since  1.7
     */
    public static bool IsSurrogate(int ch) 
    {
        return ch >= MIN_SURROGATE && ch < (MAX_SURROGATE + 1);
    }

    /**
     * Determines whether the specified character (Unicode code point)
     * is in the <a href="#supplementary">supplementary character</a> range.
     *
     * @param  codePoint the character (Unicode code point) to be tested
     * @return {@code true} if the specified code point is between
     *         {@link #MIN_SUPPLEMENTARY_CODE_POINT} and
     *         {@link #MAX_CODE_POINT} inclusive;
     *         {@code false} otherwise.
     * @since  1.5
     */
    public static bool IsSupplementaryCodePoint(int codePoint) {
        return codePoint >= MIN_SUPPLEMENTARY_CODE_POINT
            && codePoint <  MAX_CODE_POINT + 1;
    }

    /**
     * Returns the code point at the given index of the
     * {@code CharSequence}. If the {@code char} value at
     * the given index in the {@code CharSequence} is in the
     * high-surrogate range, the following index is less than the
     * length of the {@code CharSequence}, and the
     * {@code char} value at the following index is in the
     * low-surrogate range, then the supplementary code point
     * corresponding to this surrogate pair is returned. Otherwise,
     * the {@code char} value at the given index is returned.
     *
     * @param seq a sequence of {@code char} values (Unicode code
     * units)
     * @param index the index to the {@code char} values (Unicode
     * code units) in {@code seq} to be converted
     * @return the Unicode code point at the given index
     * @exception NullPointerException if {@code seq} is null.
     * @exception IndexOutOfBoundsException if the value
     * {@code index} is negative or not less than
     * {@link CharSequence#length() seq.length()}.
     * @since  1.5
     */
    public static int CodePointAt(string seq, int index) 
    {
        return (int)seq.get_char(index);
    }

    public static int ToLowerCase(int codePoint) 
    {   
        unichar cp = codePoint;
        return (int)cp.tolower();
    }

    public static int ToUpperCase(int codePoint) 
    {   
        unichar cp = codePoint;
        return (int)cp.toupper();
    }

    /**
     * Returns a value indicating a character's general category.
     *
     * <p><b>Note:</b> This method cannot handle <a
     * href="#supplementary"> supplementary characters</a>. To support
     * all Unicode characters, including supplementary characters, use
     * the {@link #getType(int)} method.
     *
     * @param   ch      the character to be tested.
     * @return  a value of type {@code int} representing the
     *          character's general category.
     * @see     Character#COMBINING_SPACING_MARK
     * @see     Character#CONNECTOR_PUNCTUATION
     * @see     Character#CONTROL
     * @see     Character#CURRENCY_SYMBOL
     * @see     Character#DASH_PUNCTUATION
     * @see     Character#DECIMAL_DIGIT_NUMBER
     * @see     Character#ENCLOSING_MARK
     * @see     Character#END_PUNCTUATION
     * @see     Character#FINAL_QUOTE_PUNCTUATION
     * @see     Character#FORMAT
     * @see     Character#INITIAL_QUOTE_PUNCTUATION
     * @see     Character#LETTER_NUMBER
     * @see     Character#LINE_SEPARATOR
     * @see     Character#LOWERCASE_LETTER
     * @see     Character#MATH_SYMBOL
     * @see     Character#MODIFIER_LETTER
     * @see     Character#MODIFIER_SYMBOL
     * @see     Character#NON_SPACING_MARK
     * @see     Character#OTHER_LETTER
     * @see     Character#OTHER_NUMBER
     * @see     Character#OTHER_PUNCTUATION
     * @see     Character#OTHER_SYMBOL
     * @see     Character#PARAGRAPH_SEPARATOR
     * @see     Character#PRIVATE_USE
     * @see     Character#SPACE_SEPARATOR
     * @see     Character#START_PUNCTUATION
     * @see     Character#SURROGATE
     * @see     Character#TITLECASE_LETTER
     * @see     Character#UNASSIGNED
     * @see     Character#UPPERCASE_LETTER
     * @since   1.1
     */
    public static int GetType(int ch) 
    {
        return ((unichar)ch).type();
    }

    public static bool IsLetterOrDigit(int codePoint) 
    {
        return ((((1 << UnicodeType.UPPERCASE_LETTER) |
            (1 << UnicodeType.LOWERCASE_LETTER) |
            (1 << UnicodeType.TITLECASE_LETTER) |
            (1 << UnicodeType.MODIFIER_LETTER) |
            (1 << UnicodeType.OTHER_LETTER) |
            (1 << UnicodeType.DECIMAL_NUMBER)) >> GetType(codePoint)) & 1)
            != 0;
    }

    public static bool IsAlphabetic(int codePoint) 
    {
        return (((((1 << UnicodeType.UPPERCASE_LETTER) |
            (1 << UnicodeType.LOWERCASE_LETTER) |
            (1 << UnicodeType.TITLECASE_LETTER) |
            (1 << UnicodeType.MODIFIER_LETTER) |
            (1 << UnicodeType.OTHER_LETTER) |
            (1 << UnicodeType.LETTER_NUMBER)) >> GetType(codePoint)) & 1) != 0);
    }

    public static bool IsLowerCase(int codePoint) 
    {
        return GetType(codePoint) == UnicodeType.LOWERCASE_LETTER;
    }

    public static bool IsUpperCase(int codePoint) 
    {
        return GetType(codePoint) == UnicodeType.UPPERCASE_LETTER;
    }

    public static bool IsTitleCase(int codePoint) 
    {
        return GetType(codePoint) == UnicodeType.TITLECASE_LETTER;
    }

    public static bool IsDigit(int codePoint) 
    {
        return GetType(codePoint) == UnicodeType.DECIMAL_NUMBER;
    }

    public static bool IsDefined(int codePoint) 
    {
        return GetType(codePoint) != UnicodeType.UNASSIGNED;
    }

    public static bool IsLetter(int codePoint) 
    {
        return ((((1 << UnicodeType.UPPERCASE_LETTER) |
            (1 << UnicodeType.LOWERCASE_LETTER) |
            (1 << UnicodeType.TITLECASE_LETTER) |
            (1 << UnicodeType.MODIFIER_LETTER) |
            (1 << UnicodeType.OTHER_LETTER)) >> GetType(codePoint)) & 1)
            != 0;
    }

    public static bool IsSpaceChar(int codePoint) 
    {
        return ((((1 << UnicodeType.SPACE_SEPARATOR) |
                  (1 << UnicodeType.LINE_SEPARATOR) |
                  (1 << UnicodeType.PARAGRAPH_SEPARATOR)) >> GetType(codePoint)) & 1)
            != 0;
    }

    public static bool IsWhitespace(int codePoint) 
    {
        return ((unichar)codePoint).isspace();
    }

    public static bool IsISOControl(int codePoint) 
    {
        // Optimized form of:
        //     (codePoint >= 0x00 && codePoint <= 0x1F) ||
        //     (codePoint >= 0x7F && codePoint <= 0x9F);
        return codePoint <= 0x9F &&
            (codePoint >= 0x7F || ((uint)codePoint) >> 5 == 0);
    }

    /**
     * Returns the code point preceding the given index of the
     * {@code CharSequence}. If the {@code char} value at
     * {@code (index - 1)} in the {@code CharSequence} is in
     * the low-surrogate range, {@code (index - 2)} is not
     * negative, and the {@code char} value at {@code (index - 2)}
     * in the {@code CharSequence} is in the
     * high-surrogate range, then the supplementary code point
     * corresponding to this surrogate pair is returned. Otherwise,
     * the {@code char} value at {@code (index - 1)} is
     * returned.
     *
     * @param seq the {@code CharSequence} instance
     * @param index the index following the code point that should be returned
     * @return the Unicode code point value before the given index.
     * @exception NullPointerException if {@code seq} is null.
     * @exception IndexOutOfBoundsException if the {@code index}
     * argument is less than 1 or greater than {@link
     * CharSequence#length() seq.length()}.
     * @since  1.5
     */
    public static int CodePointBefore(string seq, int index) 
    {
        unichar c2 = seq.get_char(--index);
        if (IsLowSurrogate(c2) && index > 0) {
            unichar c1 = seq.get_char(--index);
            if (IsHighSurrogate(c1)) {
                return ToCodePoint(c1, c2);
            }
        }
        return (int)c2;
    }

    /**
     * Determines if the given {@code char} value is a
     * <a href="http://www.unicode.org/glossary/#high_surrogate_code_unit">
     * Unicode high-surrogate code unit</a>
     * (also known as <i>leading-surrogate code unit</i>).
     *
     * <p>Such values do not represent characters by themselves,
     * but are used in the representation of
     * <a href="#supplementary">supplementary characters</a>
     * in the UTF-16 encoding.
     *
     * @param  ch the {@code char} value to be tested.
     * @return {@code true} if the {@code char} value is between
     *         {@link #MIN_HIGH_SURROGATE} and
     *         {@link #MAX_HIGH_SURROGATE} inclusive;
     *         {@code false} otherwise.
     * @see    Character#isLowSurrogate(char)
     * @see    Character.UnicodeBlock#of(int)
     * @since  1.5
     */
    public static bool IsHighSurrogate(unichar ch) 
    {
        // Help VM constant-fold; MAX_HIGH_SURROGATE + 1 == MIN_LOW_SURROGATE
        return ch >= MIN_HIGH_SURROGATE && ch < (MAX_HIGH_SURROGATE + 1);
    }

    /**
     * Determines if the given {@code char} value is a
     * <a href="http://www.unicode.org/glossary/#low_surrogate_code_unit">
     * Unicode low-surrogate code unit</a>
     * (also known as <i>trailing-surrogate code unit</i>).
     *
     * <p>Such values do not represent characters by themselves,
     * but are used in the representation of
     * <a href="#supplementary">supplementary characters</a>
     * in the UTF-16 encoding.
     *
     * @param  ch the {@code char} value to be tested.
     * @return {@code true} if the {@code char} value is between
     *         {@link #MIN_LOW_SURROGATE} and
     *         {@link #MAX_LOW_SURROGATE} inclusive;
     *         {@code false} otherwise.
     * @see    Character#isHighSurrogate(char)
     * @since  1.5
     */
    public static bool IsLowSurrogate(unichar ch) 
    {
        return ch >= MIN_LOW_SURROGATE && ch < (MAX_LOW_SURROGATE + 1);
    }

    /**
     * Converts the specified surrogate pair to its supplementary code
     * point value. This method does not validate the specified
     * surrogate pair. The caller must validate it using {@link
     * #isSurrogatePair(char, char) isSurrogatePair} if necessary.
     *
     * @param  high the high-surrogate code unit
     * @param  low the low-surrogate code unit
     * @return the supplementary code point composed from the
     *         specified surrogate pair.
     * @since  1.5
     */
    public static int ToCodePoint(unichar high, unichar low) 
    {
        // Optimized form of:
        // return ((high - MIN_HIGH_SURROGATE) << 10)
        //         + (low - MIN_LOW_SURROGATE)
        //         + MIN_SUPPLEMENTARY_CODE_POINT;
        return (int)(((high << 10) + low) + (MIN_SUPPLEMENTARY_CODE_POINT
                                       - (MIN_HIGH_SURROGATE << 10)
                                       - MIN_LOW_SURROGATE));
    }

    /**
     * Returns a hash code for this {@code Byte}; equal to the result
     * of invoking {@code intValue()}.
     *
     * @return a hash code value for this {@code Byte}
     */
    public override int GetHashCode()
    {
        return (int)value;
    }

    /**
     * Compares this object to the specified object.  The result is
     * {@code true} if and only if the argument is not
     * {@code null} and is a {@code Byte} object that
     * contains the same {@code byte} value as this object.
     *
     * @param obj       the object to compare with
     * @return          {@code true} if the objects are the same;
     *                  {@code false} otherwise.
     */
    public override bool Equals(Object obj)
    {
        if (obj is Character)
            return value == ((Character)obj).CharValue();
        else
            return false;

    }

    /**
     * Compares two {@code Byte} objects numerically.
     *
     * @param   anotherByte   the {@code Byte} to be compared.
     * @return  the value {@code 0} if this {@code Byte} is
     *          equal to the argument {@code Byte}; a value less than
     *          {@code 0} if this {@code Byte} is numerically less
     *          than the argument {@code Byte}; and a value greater than
     *           {@code 0} if this {@code Byte} is numerically
     *           greater than the argument {@code Byte} (signed
     *           comparison).
     * @since   1.2
     */
    public override int CompareTo(Character other)
    {
        return Compare(this.value, other.value);
    }

    /**
     * Compares two {@code byte} values numerically.
     * The value returned is identical to what would be returned by:
     * <pre>
     *    Byte.valueOf(x).compareTo(Byte.valueOf(y))
     * </pre>
     *
     * @param  x the first {@code byte} to compare
     * @param  y the second {@code byte} to compare
     * @return the value {@code 0} if {@code x == y};
     *         a value less than {@code 0} if {@code x < y}; and
     *         a value greater than {@code 0} if {@code x > y}
     * @since 1.7
     */
    public static int Compare(char x, char y)
    {
        return (x < y) ? -1 : (( x == y ) ? 0 : 1);
    }

    public static int Digit(char ch, int radix) 
    {
        for (int i=0; i<radix; i++)
        {
            if (ch == Integer.Digits[i])
                return i;
        }
        return -1;
    }

    /**
     * Instances of this class represent particular subsets of the Unicode
     * character set.  The only family of subsets defined in the
     * {@code Character} class is {@link Character.UnicodeBlock}.
     * Other portions of the Java API may define other subsets for their
     * own purposes.
     *
     * @since 1.2
     */
    public class Subset : Object  {

        private string name;

        /**
         * Constructs a new {@code Subset} instance.
         *
         * @param  name  The name of this subset
         * @exception NullPointerException if name is {@code null}
         */
        protected Subset(string name) {
            if (name == null) {
                throw new Exception.NullPointerException("name");
            }
            this.name = name;
        }

        /**
         * Compares two {@code Subset} objects for equality.
         * This method returns {@code true} if and only if
         * {@code this} and the argument refer to the same
         * object; since this method is {@code final}, this
         * guarantee holds for all subclasses.
         */
        public override bool Equals(Object obj) {
            return (this == obj);
        }

        /**
         * Returns the standard hash code as defined by the
         * {@link Object#hashCode} method.  This method
         * is {@code final} in order to ensure that the
         * {@code equals} and {@code hashCode} methods will
         * be consistent in all subclasses.
         */
        public override int GetHashCode() {
            return base.GetHashCode();
        }

        /**
         * Returns the name of this subset.
         */
        public override string ToString() {
            return name;
        }
    }

    /**
     * A family of character subsets representing the character blocks in the
     * Unicode specification. Character blocks generally define characters
     * used for a specific script or purpose. A character is contained by
     * at most one Unicode block.
     *
     * @since 1.2
     */
    public class UnicodeBlock : Subset {

        private static Dictionary<string, UnicodeBlock> map = new Dictionary<string, UnicodeBlock>();

        /**
         * Creates a UnicodeBlock with the given identifier name and
         * alias names.
         */
        private UnicodeBlock(string idName, string[] aliases) {
            base(idName);
            map[idName] = this;
            foreach (string alias in aliases)
                map[alias] = this;
        }

        /**
         * Constant for the "Basic Latin" Unicode character block.  
         * @since 1.2
         */
        public static UnicodeBlock  BASIC_LATIN =
            new UnicodeBlock("BASIC_LATIN", { 
                             "BASIC LATIN", 
                             "BASICLATIN" });

        /**
         * Constant for the "Latin-1 Supplement" Unicode character block.
         * @since 1.2
         */
        public static UnicodeBlock LATIN_1_SUPPLEMENT =
            new UnicodeBlock("LATIN_1_SUPPLEMENT", {
                             "LATIN-1 SUPPLEMENT",
                             "LATIN-1SUPPLEMENT" });

        /**
         * Constant for the "Latin Extended-A" Unicode character block.
         * @since 1.2
         */
        public static UnicodeBlock LATIN_EXTENDED_A =
            new UnicodeBlock("LATIN_EXTENDED_A", {
                             "LATIN EXTENDED-A",
                             "LATINEXTENDED-A" });

        /**
         * Constant for the "Latin Extended-B" Unicode character block.
         * @since 1.2
         */
        public static UnicodeBlock LATIN_EXTENDED_B =
            new UnicodeBlock("LATIN_EXTENDED_B", {
                             "LATIN EXTENDED-B",
                             "LATINEXTENDED-B" });

        public static UnicodeBlock ForName(string blockName) {
            UnicodeBlock block = map.get(blockName.up());
            if (block == null) {
                throw new Exception.IllegalArgumentException("");
            }
            return block;
        }

    }

} 