/**
 * A compiled representation of a regular expression.
 *
 * <p> A regular expression, specified as a string, must first be compiled into
 * an instance of this class.  The resulting pattern can then be used to create
 * a {@link Matcher} object that can match arbitrary {@linkplain
 * java.lang.string character sequences} against the regular
 * expression.  All of the state involved in performing a match resides in the
 * matcher, so many matchers can share the same pattern.
 *
 * @see java.lang.string#split(string, int)
 * @see java.lang.string#split(string)
 *
 * @author      Mike McCloskey
 * @author      Mark Reinhold
 * @author      JSR-51 Expert Group
 * @since       1.4
 * @spec        JSR-51
 */
using System.Collections.Generic;

public class System.Regex.Pattern : Object
{
    /**
     * Regular expression modifier values.  Instead of being passed as
     * arguments, they can also be passed as inline modifiers.
     * For example, the following statements have the same effect.
     * <pre>
     * RegExp r1 = RegExp.compile("abc", Pattern.I|Pattern.M);
     * RegExp r2 = RegExp.compile("(?im)abc", 0);
     * </pre>
     *
     * The flags are duplicated so that the familiar Perl match flag
     * names are available.
     */

    /**
     * Enables Unix lines mode.
     *
     * <p> In this mode, only the <tt>'\n'</tt> line terminator is recognized
     * in the behavior of <tt>.</tt>, <tt>^</tt>, and <tt>$</tt>.
     *
     * <p> Unix lines mode can also be enabled via the embedded flag
     * expression&nbsp;<tt>(?d)</tt>.
     */
    public const int UNIX_LINES = 0x01;

    /**
     * Enables case-insensitive matching.
     *
     * <p> By default, case-insensitive matching assumes that only characters
     * in the US-ASCII charset are being matched.  Unicode-aware
     * case-insensitive matching can be enabled by specifying the {@link
     * #UNICODE_CASE} flag in conjunction with this flag.
     *
     * <p> Case-insensitive matching can also be enabled via the embedded flag
     * expression&nbsp;<tt>(?i)</tt>.
     *
     * <p> Specifying this flag may impose a slight performance penalty.  </p>
     */
    public const int CASE_INSENSITIVE = 0x02;

    /**
     * Permits whitespace and comments in pattern.
     *
     * <p> In this mode, whitespace is ignored, and embedded comments starting
     * with <tt>#</tt> are ignored until the end of a line.
     *
     * <p> Comments mode can also be enabled via the embedded flag
     * expression&nbsp;<tt>(?x)</tt>.
     */
    public const int COMMENTS = 0x04;

    /**
     * Enables multiline mode.
     *
     * <p> In multiline mode the expressions <tt>^</tt> and <tt>$</tt> match
     * just after or just before, respectively, a line terminator or the end of
     * the input sequence.  By default these expressions only match at the
     * beginning and the end of the entire input sequence.
     *
     * <p> Multiline mode can also be enabled via the embedded flag
     * expression&nbsp;<tt>(?m)</tt>.  </p>
     */
    public const int MULTILINE = 0x08;

    /**
     * Enables literal parsing of the pattern.
     *
     * <p> When this flag is specified then the input string that specifies
     * the pattern is treated as a sequence of literal characters.
     * Metacharacters or escape sequences in the input sequence will be
     * given no special meaning.
     *
     * <p>The flags CASE_INSENSITIVE and UNICODE_CASE retain their impact on
     * matching when used in conjunction with this flag. The other flags
     * become superfluous.
     *
     * <p> There is no embedded flag character for enabling literal parsing.
     * @since 1.5
     */
    public const int LITERAL = 0x10;

    /**
     * Enables dotall mode.
     *
     * <p> In dotall mode, the expression <tt>.</tt> matches any character,
     * including a line terminator.  By default this expression does not match
     * line terminators.
     *
     * <p> Dotall mode can also be enabled via the embedded flag
     * expression&nbsp;<tt>(?s)</tt>.  (The <tt>s</tt> is a mnemonic for
     * "single-line" mode, which is what this is called in Perl.)  </p>
     */
    public const int DOTALL = 0x20;

    /**
     * Enables Unicode-aware case folding.
     *
     * <p> When this flag is specified then case-insensitive matching, when
     * enabled by the {@link #CASE_INSENSITIVE} flag, is done in a manner
     * consistent with the Unicode Standard.  By default, case-insensitive
     * matching assumes that only characters in the US-ASCII charset are being
     * matched.
     *
     * <p> Unicode-aware case folding can also be enabled via the embedded flag
     * expression&nbsp;<tt>(?u)</tt>.
     *
     * <p> Specifying this flag may impose a performance penalty.  </p>
     */
    public const int UNICODE_CASE = 0x40;

    /**
     * Enables canonical equivalence.
     *
     * <p> When this flag is specified then two characters will be considered
     * to match if, and only if, their full canonical decompositions match.
     * The expression <tt>"a&#92;u030A"</tt>, for example, will match the
     * string <tt>"&#92;u00E5"</tt> when this flag is specified.  By default,
     * matching does not take canonical equivalence into account.
     *
     * <p> There is no embedded flag character for enabling canonical
     * equivalence.
     *
     * <p> Specifying this flag may impose a performance penalty.  </p>
     */
    public const int CANON_EQ = 0x80;

    /**
     * Enables the Unicode version of <i>Predefined character classes</i> and
     * <i>POSIX character classes</i>.
     *
     * <p> When this flag is specified then the (US-ASCII only)
     * <i>Predefined character classes</i> and <i>POSIX character classes</i>
     * are in conformance with
     * <a href="http://www.unicode.org/reports/tr18/"><i>Unicode Technical
     * Standard #18: Unicode Regular Expression</i></a>
     * <i>Annex C: Compatibility Properties</i>.
     * <p>
     * The UNICODE_CHARACTER_CLASS mode can also be enabled via the embedded
     * flag expression&nbsp;<tt>(?U)</tt>.
     * <p>
     * The flag implies UNICODE_CASE, that is, it enables Unicode-aware case
     * folding.
     * <p>
     * Specifying this flag may impose a performance penalty.  </p>
     * @since 1.7
     */
    public const int UNICODE_CHARACTER_CLASS = 0x100;

    /* Pattern has only two serialized components: The pattern string
     * and the flags, which are all that is needed to recompile the pattern
     * when it is deserialized.
     */

    /**
     * The original regular-expression pattern string.
     *
     * @serial
     */
    private string pattern;

    /**
     * The original pattern flags.
     *
     * @serial
     */
    private int flags;

    /**
     * Boolean indicating this Pattern is compiled; this is necessary in order
     * to lazily compile deserialized Patterns.
     */
    private bool compiled = false;

    /**
     * The normalized pattern string.
     */
    private string normalizedPattern;

    /**
     * The starting point of state machine for the find operation.  This allows
     * a match to start anywhere in the input.
     */
    public Node Root;

    /**
     * The Root of object tree for a match operation.  The pattern is matched
     * at the beginning.  This may include a find that uses BnM or a First
     * node.
     */
    public Node MatchRoot;

    /**
     * Temporary storage used by parsing pattern slice.
     */
    public int[] Buffer;

    /**
     * Map the "name" of the "named capturing group" to its group id
     * node.
     */
    public Dictionary<string, int> NamedGroups;

    /**
     * Temporary storage used while parsing group references.
     */
    public GroupHead[] GroupNodes;

    /**
     * Temporary null terminated code point array used by pattern compiling.
     */
    private int[] temp;

    /**
     * The number of capturing groups in this Pattern. Used by matchers to
     * allocate storage needed to perform a match.
     */
    public int CapturingGroupCount;

    /**
     * The local variable count used by parsing tree. Used by matchers to
     * allocate storage needed to perform a match.
     */
    public int LocalCount;

    /**
     * Index into the pattern string that keeps track of how much has been
     * parsed.
     */
    private int cursor;

    /**
     * Holds the length of the pattern string.
     */
    private int patternLength;

    /**
     * If the Start node might possibly match supplementary characters.
     * It is set to true during compiling if
     * (1) There is supplementary char in pattern, or
     * (2) There is complement node of Category or Block
     */
    private bool hasSupplementary;

    /**
     * Compiles the given regular expression into a pattern.
     *
     * @param  regex
     *         The expression to be compiled
     * @return the given regular expression compiled into a pattern
     * @throws  PatternSyntaxException
     *          If the expression's syntax is invalid
     */
    // public static Pattern compile(string regex) {
    //     return new Pattern(regex, 0);
    // }

    /**
     * Compiles the given regular expression into a pattern with the given
     * flags.
     *
     * @param  regex
     *         The expression to be compiled
     *
     * @param  flags
     *         Match flags, a bit mask that may include
     *         {@link #CASE_INSENSITIVE}, {@link #MULTILINE}, {@link #DOTALL},
     *         {@link #UNICODE_CASE}, {@link #CANON_EQ}, {@link #UNIX_LINES},
     *         {@link #LITERAL}, {@link #UNICODE_CHARACTER_CLASS}
     *         and {@link #COMMENTS}
     *
     * @return the given regular expression compiled into a pattern with the given flags
     * @throws  IllegalArgumentException
     *          If bit values other than those corresponding to the defined
     *          match flags are set in <tt>flags</tt>
     *
     * @throws  PatternSyntaxException
     *          If the expression's syntax is invalid
     */
    public static Pattern Compile(string regex, int flags=0) 
    {
        return new Pattern(regex, flags);
    }

    /**
     * Returns the regular expression from which this pattern was compiled.
     *
     * @return  The source of this pattern
     */
    public string GetPattern() 
    {
        return pattern;
    }

    /**
     * <p>Returns the string representation of this pattern. This
     * is the regular expression from which this pattern was
     * compiled.</p>
     *
     * @return  The string representation of this pattern
     * @since 1.5
     */
    public string ToString() 
    {
        return pattern;
    }

    private GLib.Object lock = new GLib.Object();
    /**
     * Creates a matcher that will match the given input against this pattern.
     *
     * @param  input
     *         The character sequence to be matched
     *
     * @return  A new matcher for this pattern
     */
    public Matcher GetMatcher(string input) 
    {
        if (!compiled) {
            lock(this.lock) {
                if (!compiled)
                    compileImpl();
            }
        }
        Matcher m = new Matcher(this, input);
        return m;
    }

    /**
     * Returns this pattern's match flags.
     *
     * @return  The match flags specified when this pattern was compiled
     */
    public int GetFlags() 
    {
        return flags;
    }

    /**
     * Compiles the given regular expression and attempts to match the given
     * input against it.
     *
     * <p> An invocation of this convenience method of the form
     *
     * <blockquote><pre>
     * Pattern.matches(regex, input);</pre></blockquote>
     *
     * behaves in exactly the same way as the expression
     *
     * <blockquote><pre>
     * Pattern.compile(regex).Matcher(input).matches()</pre></blockquote>
     *
     * <p> If a pattern is to be used multiple times, compiling it once and reusing
     * it will be more efficient than invoking this method each time.  </p>
     *
     * @param  regex
     *         The expression to be compiled
     *
     * @param  input
     *         The character sequence to be matched
     * @return whether or not the regular expression matches on the input
     * @throws  PatternSyntaxException
     *          If the expression's syntax is invalid
     */
    public static bool Matches(string regex, string input) 
    {
        Pattern p = Pattern.Compile(regex);
        Matcher m = p.GetMatcher(input);
        return m.Matches();
    }

    /**
     * Splits the given input sequence around matches of this pattern.
     *
     * <p> The array returned by this method contains each substring of the
     * input sequence that is terminated by another subsequence that matches
     * this pattern or is terminated by the end of the input sequence.  The
     * substrings in the array are in the order in which they occur in the
     * input. If this pattern does not match any subsequence of the input then
     * the resulting array has just one element, namely the input sequence in
     * string form.
     *
     * <p> When there is a positive-width match at the beginning of the input
     * sequence then an empty leading substring is included at the beginning
     * of the resulting array. A zero-width match at the beginning however
     * never produces such empty leading substring.
     *
     * <p> The <tt>limit</tt> parameter controls the number of times the
     * pattern is applied and therefore affects the length of the resulting
     * array.  If the limit <i>n</i> is greater than zero then the pattern
     * will be applied at most <i>n</i>&nbsp;-&nbsp;1 times, the array's
     * length will be no greater than <i>n</i>, and the array's last entry
     * will contain all input beyond the last matched delimiter.  If <i>n</i>
     * is non-positive then the pattern will be applied as many times as
     * possible and the array can have any length.  If <i>n</i> is zero then
     * the pattern will be applied as many times as possible, the array can
     * have any length, and trailing empty strings will be discarded.
     *
     * <p> The input <tt>"boo:and:foo"</tt>, for example, yields the following
     * results with these parameters:
     *
     * <blockquote><table cellpadding=1 cellspacing=0
     *              summary="Split examples showing regex, limit, and result">
     * <tr><th align="left"><i>Regex&nbsp;&nbsp;&nbsp;&nbsp;</i></th>
     *     <th align="left"><i>Limit&nbsp;&nbsp;&nbsp;&nbsp;</i></th>
     *     <th align="left"><i>Result&nbsp;&nbsp;&nbsp;&nbsp;</i></th></tr>
     * <tr><td align=center>:</td>
     *     <td align=center>2</td>
     *     <td><tt>{ "boo", "and:foo" }</tt></td></tr>
     * <tr><td align=center>:</td>
     *     <td align=center>5</td>
     *     <td><tt>{ "boo", "and", "foo" }</tt></td></tr>
     * <tr><td align=center>:</td>
     *     <td align=center>-2</td>
     *     <td><tt>{ "boo", "and", "foo" }</tt></td></tr>
     * <tr><td align=center>o</td>
     *     <td align=center>5</td>
     *     <td><tt>{ "b", "", ":and:f", "", "" }</tt></td></tr>
     * <tr><td align=center>o</td>
     *     <td align=center>-2</td>
     *     <td><tt>{ "b", "", ":and:f", "", "" }</tt></td></tr>
     * <tr><td align=center>o</td>
     *     <td align=center>0</td>
     *     <td><tt>{ "b", "", ":and:f" }</tt></td></tr>
     * </table></blockquote>
     *
     * @param  input
     *         The character sequence to be split
     *
     * @param  limit
     *         The result threshold, as described above
     *
     * @return  The array of strings computed by splitting the input
     *          around matches of this pattern
     */
    public string[] Split(string input, int limit=0) 
    {
        int index = 0;
        bool matchLimited = limit > 0;
        ArrayList<string> matchList = new ArrayList<string>();
        Matcher m = GetMatcher(input);

        // Add segments before each match found
        while(m.Find()) {
            if (!matchLimited || matchList.Count < limit - 1) {
                if (index == 0 && index == m.Start() && m.Start() == m.End()) {
                    // no empty leading substring included for zero-width match
                    // at the beginning of the input char sequence.
                    continue;
                }
                string match = input.substr(index, m.Start());
                matchList.Add(match);
                index = m.End();
            } else if (matchList.Count == limit - 1) { // last one
                string match = input.substr(index, input.length);
                matchList.Add(match);
                index = m.End();
            }
        }

        // If no match was found, return this
        if (index == 0) {
            return new string[] {input};
        }

        // Add remaining segment
        if (!matchLimited || matchList.Count < limit)
            matchList.Add(input.substr(index, input.length));

        // Construct result
        int resultSize = matchList.Count;
        if (limit == 0)
            while (resultSize > 0 && matchList[resultSize-1].Equals(""))
                resultSize--;
        // string[] result = new string[resultSize];
        println("matchList %d", matchList.Count);
        return matchList.ToArray();
    }

    /**
     * Splits the given input sequence around matches of this pattern.
     *
     * <p> This method works as if by invoking the two-argument {@link
     * #split(java.lang.string, int) split} method with the given input
     * sequence and a limit argument of zero.  Trailing empty strings are
     * therefore not included in the resulting array. </p>
     *
     * <p> The input <tt>"boo:and:foo"</tt>, for example, yields the following
     * results with these expressions:
     *
     * <blockquote><table cellpadding=1 cellspacing=0
     *              summary="Split examples showing regex and result">
     * <tr><th align="left"><i>Regex&nbsp;&nbsp;&nbsp;&nbsp;</i></th>
     *     <th align="left"><i>Result</i></th></tr>
     * <tr><td align=center>:</td>
     *     <td><tt>{ "boo", "and", "foo" }</tt></td></tr>
     * <tr><td align=center>o</td>
     *     <td><tt>{ "b", "", ":and:f" }</tt></td></tr>
     * </table></blockquote>
     *
     *
     * @param  input
     *         The character sequence to be split
     *
     * @return  The array of strings computed by splitting the input
     *          around matches of this pattern
     */
    // public string[] split(string input) {
    //     return split(input, 0);
    // }

    /**
     * Returns a literal pattern <code>string</code> for the specified
     * <code>string</code>.
     *
     * <p>This method produces a <code>string</code> that can be used to
     * create a <code>Pattern</code> that would match the string
     * <code>s</code> as if it were a literal pattern.</p> Metacharacters
     * or escape sequences in the input sequence will be given no special
     * meaning.
     *
     * @param  s The string to be literalized
     * @return  A literal string replacement
     * @since 1.5
     */
    public static string Quote(string s) 
    {
        int slashEIndex = s.index_of("\\E");
        if (slashEIndex == -1)
            return "\\Q" + s + "\\E";

        StringBuilder sb = new StringBuilder();
        sb.append("\\Q");
        slashEIndex = 0;
        int current = 0;
        while ((slashEIndex = s.index_of("\\E", current)) != -1) {
            sb.append(s.substr(current, slashEIndex));
            current = slashEIndex + 2;
            sb.append("\\E\\\\E\\Q");
        }
        sb.append(s.substr(current, s.length));
        sb.append("\\E");
        return sb.str;
    }

    /**
     * This private constructor is used to create all Patterns. The pattern
     * string and match flags are all that is needed to completely describe
     * a Pattern. An empty pattern string results in an object tree with
     * only a Start node and a LastNode node.
     */
    private Pattern(string p, int f) 
    {
        pattern = p;
        flags = f;

        // to use UNICODE_CASE if UNICODE_CHARACTER_CLASS present
        if ((flags & UNICODE_CHARACTER_CLASS) != 0)
            flags |= UNICODE_CASE;

        // Reset group index count
        CapturingGroupCount = 1;
        LocalCount = 0;

        if (pattern.length > 0) {
            compileImpl();
        } else {
            Root = new Start(LastAccept);
            MatchRoot = LastAccept;
        }
    }

    /**
     * The pattern is converted to normalizedD form and then a pure group
     * is constructed to match canonical equivalences of the characters.
     */
    private void normalize() 
    {
        bool inCharClass = false;
        int lastCodePoint = -1;

        // Convert pattern into normalizedD form
        normalizedPattern = pattern.normalize(-1, NormalizeMode.NFD);
        patternLength = normalizedPattern.length;

        // Modify pattern to match canonical equivalences
        StringBuilder newPattern = new StringBuilder();
        for (int i=0; i<patternLength; ) {
            unichar c = normalizedPattern.get_char(i);
            StringBuilder sequenceBuffer;
            if ((c.type() == UnicodeType.NON_SPACING_MARK)
                && (lastCodePoint != -1)) {
                sequenceBuffer = new StringBuilder();
                sequenceBuffer.append_unichar(lastCodePoint);
                sequenceBuffer.append_unichar(c);
                while(c.type() == UnicodeType.NON_SPACING_MARK) {
                    i += Character.CharCount((int)c);
                    if (i >= patternLength)
                        break;
                    c = normalizedPattern.get_char(i);
                    sequenceBuffer.append_unichar(c);
                }
                string ea = produceEquivalentAlternation(
                                               sequenceBuffer.str);
                newPattern.truncate(newPattern.len-Character.CharCount(lastCodePoint));
                newPattern.append("(?:").append(ea).append(")");
            } else if (c == '[' && lastCodePoint != '\\') {
                i = normalizeCharClass(newPattern, i);
            } else {
                newPattern.append_unichar(c);
            }
            lastCodePoint = (int)c;
            i += Character.CharCount((int)c);
        }
        normalizedPattern = newPattern.str;
    }

    /**
     * Complete the character class being parsed and add a set
     * of alternations to it that will match the canonical equivalences
     * of the characters within the class.
     */
    private int normalizeCharClass(StringBuilder newPattern, int i) 
    {
        StringBuilder charClass = new StringBuilder();
        StringBuilder eq = null;
        int lastCodePoint = -1;
        string result;

        i++;
        charClass.append("[");
        while(true) {
            unichar c = normalizedPattern.get_char(i);
            StringBuilder sequenceBuffer;

            if (c == ']' && lastCodePoint != '\\') {
                charClass.append_unichar(c);
                break;
            } else if (c.type() == UnicodeType.NON_SPACING_MARK) {
                sequenceBuffer = new StringBuilder();
                sequenceBuffer.append_unichar(lastCodePoint);
                while(c.type() == UnicodeType.NON_SPACING_MARK) {
                    sequenceBuffer.append_unichar(c);
                    i += Character.CharCount((int)c);
                    if (i >= normalizedPattern.length)
                        break;
                    c = normalizedPattern.get_char(i);
                }
                string ea = produceEquivalentAlternation(
                                                  sequenceBuffer.str);

                charClass.truncate(charClass.len-Character.CharCount(lastCodePoint));
                if (eq == null)
                    eq = new StringBuilder();
                eq.append_c('|');
                eq.append(ea);
            } else {
                charClass.append_unichar(c);
                i++;
            }
            if (i == normalizedPattern.length)
                throw error("Unclosed character class");
            lastCodePoint = (int)c;
        }

        if (eq != null) {
            result = "(?:"+charClass.str+eq.str+")";
        } else {
            result = charClass.str;
        }

        newPattern.append(result);
        return i;
    }

    /**
     * Given a specific sequence composed of a regular character and
     * combining marks that follow it, produce the alternation that will
     * match all canonical equivalences of that sequence.
     */
    private string produceEquivalentAlternation(string source) 
    {
        int len = countChars(source, 0, 1);
        if (source.length == len)
            // source has one character.
            return source;

        string sbase = source.substring(0,len);
        string combiningMarks = source.substring(len);

        string[] perms = producePermutations(combiningMarks);
        StringBuilder result = new StringBuilder(source);

        // Add combined permutations
        for (int x=0; x<perms.length; x++) {
            string next = sbase + perms[x];
            if (x>0)
                result.append("|"+next);
            next = composeOneStep(next);
            if (next != null)
                result.append("|"+produceEquivalentAlternation(next));
        }
        return result.str;
    }

    /**
     * Returns an array of strings that have all the possible
     * permutations of the characters in the input string.
     * This is used to get a list of all possible orderings
     * of a set of combining marks. Note that some of the permutations
     * are invalid because of combining class collisions, and these
     * possibilities must be removed because they are not canonically
     * equivalent.
     */
    private string[] producePermutations(string input) 
    {
        if (input.length == countChars(input, 0, 1))
            return new string[] {input};

        if (input.length == countChars(input, 0, 2)) {
            int c0 = Character.CodePointAt(input, 0);
            int c1 = Character.CodePointAt(input, Character.CharCount(c0));
            if (getClass(c1) == getClass(c0)) {
                return new string[] {input};
            }
            string[] result = new string[2];
            result[0] = input;
            StringBuilder sb = new StringBuilder();
            sb.append_unichar(c1);
            sb.append_unichar(c0);
            result[1] = sb.str;
            return result;
        }

        int length = 1;
        int nCodePoints = countCodePoints(input);
        for (int x=1; x<nCodePoints; x++)
            length = length * (x+1);

        string[] temp = new string[length];

        int[] combClass = new int[nCodePoints];
        for (int x=0, i=0; x<nCodePoints; x++) {
            int c = Character.CodePointAt(input, i);
            combClass[x] = getClass(c);
            i +=  Character.CharCount(c);
        }

        // For each char, take it out and add the permutations
        // of the remaining chars
        int index = 0;
        int len = 0;
        // offset maintains the index in code units.
// loop:   
        for (int x=0, offset=0; x<nCodePoints; x++, offset+=len) {
            var skip = false;
            len = countChars(input, offset, 1);
            for (int y=x-1; y>=0; y--) {
                if (combClass[y] == combClass[x]) {
                    skip = true;
                    break;
                    // continue loop;
                }
            }
            if (skip) continue;
            StringBuilder sb = new StringBuilder(input);
            string otherChars = sb.erase(offset, len).str;
            string[] subResult = producePermutations(otherChars);

            string prefix = input.substr(offset, offset+len);
            for (int y=0; y<subResult.length; y++)
                temp[index++] =  prefix + subResult[y];
        }
        string[] result = new string[index];
        for (int x=0; x<index; x++)
            result[x] = temp[x];
        return result;
    }

    private int getClass(int c) 
    {
        // Default value is that no reordering should take place
        return 0;
        // #  All code points not explicitly listed for Canonical_Combining_Class
        // #  have the value Not_Reordered (0).        
    }


    /**
     * Attempts to compose input by combining the first character
     * with the first combining mark following it. Returns a string
     * that is the composition of the leading character with its first
     * combining mark followed by the remaining combining marks. Returns
     * null if the first two characters cannot be further composed.
     */
    private string composeOneStep(string input) 
    {
        int len = countChars(input, 0, 2);
        string firstTwoCharacters = input.substring(0, len);
        string result = firstTwoCharacters.normalize(-1, NormalizeMode.NFC);

        if (result.Equals(firstTwoCharacters))
            return null;
        else {
            string remainder = input.substring(len);
            return result + remainder;
        }
    }

    /**
     * Preprocess any \Q...\E sequences in `temp', meta-quoting them.
     * See the description of `quotemeta' in perlfunc(1).
     */
    private void removeQEQuoting() {
        int pLen = patternLength;
        int i = 0;
        while (i < pLen-1) {
            if (temp[i] != '\\')
                i += 1;
            else if (temp[i + 1] != 'Q')
                i += 2;
            else
                break;
        }
        if (i >= pLen - 1)    // No \Q sequence found
            return;
        int j = i;
        i += 2;
        int[] newtemp = new int[j + 3*(pLen-i) + 2];
        System.arraycopy<int>(temp, 0, newtemp, 0, j);

        bool inQuote = true;
        bool beginQuote = true;
        while (i < pLen) {
            int c = temp[i++];
            if (!ASCII.IsAscii(c) || ASCII.IsAlpha(c)) {
                newtemp[j++] = c;
            } else if (ASCII.IsDigit(c)) {
                if (beginQuote) {
                    /*
                     * A unicode escape \[0xu] could be before this quote,
                     * and we don't want this numeric char to processed as
                     * part of the escape.
                     */
                    newtemp[j++] = '\\';
                    newtemp[j++] = 'x';
                    newtemp[j++] = '3';
                }
                newtemp[j++] = c;
            } else if (c != '\\') {
                if (inQuote) newtemp[j++] = '\\';
                newtemp[j++] = c;
            } else if (inQuote) {
                if (temp[i] == 'E') {
                    i++;
                    inQuote = false;
                } else {
                    newtemp[j++] = '\\';
                    newtemp[j++] = '\\';
                }
            } else {
                if (temp[i] == 'Q') {
                    i++;
                    inQuote = true;
                    beginQuote = true;
                    continue;
                } else {
                    newtemp[j++] = c;
                    if (i != pLen)
                        newtemp[j++] = temp[i++];
                }
            }

            beginQuote = false;
        }

        patternLength = j;
        temp = new int[j + 2];
        System.arraycopy<int>(newtemp, 0, temp, 0, newtemp.length);
        // temp = Arrays.copyOf(newtemp, j + 2); // double zero termination
    }

    /**
     * Copies regular expression to an int array and invokes the parsing
     * of the expression which will create the object tree.
     */
    private void compileImpl() 
    {
        // Handle canonical equivalences
        if (has(CANON_EQ) && !has(LITERAL)) {
            normalize();
        } else {
            normalizedPattern = pattern;
        }
        patternLength = normalizedPattern.length;

        // Copy pattern to int array for convenience
        // Use double zero to terminate pattern
        temp = new int[patternLength + 2];

        hasSupplementary = false;
        int c = 0, count = 0;
        // Convert all chars into code points
        for (int x = 0; x < patternLength; x += Character.CharCount(c)) {
            c = (int)normalizedPattern.get_char(x);
            if (isSupplementary(c)) {
                hasSupplementary = true;
            }
            temp[count++] = c;
        }

        patternLength = count;   // patternLength now in code points

        if (! has(LITERAL))
            removeQEQuoting();

        // Allocate all temporary objects here.
        Buffer = new int[32];
        GroupNodes = new GroupHead[10];
        NamedGroups = null;

        if (has(LITERAL)) {
            // Literal pattern handling
            MatchRoot = newSlice(temp, patternLength, hasSupplementary);
            MatchRoot.next = LastAccept;
        } else {
            // Start recursive descent parsing
            MatchRoot = expr(LastAccept);
            // Check extra pattern characters
            if (patternLength != cursor) {
                if (peek() == ')') {
                    throw error("Unmatched closing ')'");
                } else {
                    throw error("Unexpected internal error");
                }
            }
        }

        // Peephole optimization
        if (MatchRoot is Slice) {
            Root = BnM.optimize(MatchRoot);
            if (Root == MatchRoot) {
                Root = hasSupplementary ? new StartS(MatchRoot) : new Start(MatchRoot);
            }
        } else if (MatchRoot is Begin || MatchRoot is First) {
            Root = MatchRoot;
        } else {
            Root = hasSupplementary ? new StartS(MatchRoot) : new Start(MatchRoot);
        }

        // Release temporary storage
        temp = null;
        Buffer = null;
        GroupNodes = null;
        patternLength = 0;
        compiled = true;
    }

    public Dictionary<string, int> GetNamedGroups() 
    {
        if (NamedGroups == null)
            NamedGroups = new Dictionary<string, int>();
        return NamedGroups;
    }

    /**
     * Used to print out a subtree of the Pattern to help with debugging.
     */
    private static void printObjectTree(Node node) 
    {
        while(node != null) {
            if (node is Prolog) {
                println(node.to_string());
                printObjectTree(((Prolog)node).loop);
                println("**** end contents prolog loop");
            } else if (node is Loop) {
                println(node.to_string());
                printObjectTree(((Loop)node).body);
                println("**** end contents Loop body");
            } else if (node is Curly) {
                println(node.to_string());
                printObjectTree(((Curly)node).atom);
                println("**** end contents Curly body");
            } else if (node is GroupCurly) {
                println(node.to_string());
                printObjectTree(((GroupCurly)node).atom);
                println("**** end contents GroupCurly body");
            } else if (node is GroupTail) {
                println(node.to_string());
                println(@"Tail next is $(node.next)");
                return;
            } else {
                println(node.to_string());
            }
            node = node.next;
            if (node != null)
                println("->next:");
            if (node == Pattern.Accept) {
                println("Accept Node");
                node = null;
            }
       }
    }

    /**
     * Used to accumulate information about a subtree of the object graph
     * so that optimizations can be applied to the subtree.
     */
    public class TreeInfo : Object 
    {
        public int minLength;
        public int maxLength;
        public bool maxValid;
        public bool deterministic;

        public TreeInfo() {
            reset();
        }
        public void reset() {
            minLength = 0;
            maxLength = 0;
            maxValid = true;
            deterministic = true;
        }
    }

    /*
     * The following private methods are mainly used to improve the
     * readability of the code. In order to let the Java compiler easily
     * inline them, we should not put many assertions or error checks in them.
     */

    /**
     * Indicates whether a particular flag is set or not.
     */
    private bool has(int f) 
    {
        return (flags & f) != 0;
    }

    /**
     * Match next character, signal error if failed.
     */
    private void acceptNext(int ch, string s) 
    {
        int testChar = temp[cursor++];
        if (has(COMMENTS))
            testChar = parsePastWhitespace(testChar);
        if (ch != testChar) {
            throw error(s);
        }
    }

    /**
     * Mark the end of pattern with a specific character.
     */
    private void mark(int c) 
    {
        temp[patternLength] = c;
    }

    /**
     * Peek the next character, and do not advance the cursor.
     */
    private int peek() 
    {
        int ch = temp[cursor];
        if (has(COMMENTS))
            ch = peekPastWhitespace(ch);
        return ch;
    }

    /**
     * Read the next character, and advance the cursor by one.
     */
    private int read() 
    {
        int ch = temp[cursor++];
        if (has(COMMENTS))
            ch = parsePastWhitespace(ch);
        return ch;
    }

    /**
     * Read the next character, and advance the cursor by one,
     * ignoring the COMMENTS setting
     */
    private int readEscaped() 
    {
        int ch = temp[cursor++];
        return ch;
    }

    /**
     * Advance the cursor by one, and peek the next character.
     */
    private int next() 
    {
        int ch = temp[++cursor];
        if (has(COMMENTS))
            ch = peekPastWhitespace(ch);
        return ch;
    }

    /**
     * Advance the cursor by one, and peek the next character,
     * ignoring the COMMENTS setting
     */
    private int nextEscaped() 
    {
        int ch = temp[++cursor];
        return ch;
    }

    /**
     * If in xmode peek past whitespace and comments.
     */
    private int peekPastWhitespace(int ch) 
    {
        while (ASCII.IsSpace(ch) || ch == '#') {
            while (ASCII.IsSpace(ch))
                ch = temp[++cursor];
            if (ch == '#') {
                ch = peekPastLine();
            }
        }
        return ch;
    }

    /**
     * If in xmode parse past whitespace and comments.
     */
    private int parsePastWhitespace(int ch) 
    {
        while (ASCII.IsSpace(ch) || ch == '#') {
            while (ASCII.IsSpace(ch))
                ch = temp[cursor++];
            if (ch == '#')
                ch = parsePastLine();
        }
        return ch;
    }

    /**
     * xmode parse past comment to end of line.
     */
    private int parsePastLine() 
    {
        int ch = temp[cursor++];
        while (ch != 0 && !isLineSeparator(ch))
            ch = temp[cursor++];
        return ch;
    }

    /**
     * xmode peek past comment to end of line.
     */
    private int peekPastLine() 
    {
        int ch = temp[++cursor];
        while (ch != 0 && !isLineSeparator(ch))
            ch = temp[++cursor];
        return ch;
    }

    /**
     * Determines if character is a line separator in the current mode
     */
    private bool isLineSeparator(int ch) 
    {
        if (has(UNIX_LINES)) {
            return ch == '\n';
        } else {
            return (ch == '\n' ||
                    ch == '\r' ||
                    (ch|1) == 0x2029 ||
                    ch == 0x0085);
        }
    }

    /**
     * Read the character after the next one, and advance the cursor by two.
     */
    private int skip() 
    {
        int i = cursor;
        int ch = temp[i+1];
        cursor = i + 2;
        return ch;
    }

    /**
     * Unread one next character, and retreat cursor by one.
     */
    private void unread() 
    {
        cursor--;
    }

    /**
     * Internal method used for handling all syntax errors. The pattern is
     * displayed with a pointer to aid in locating the syntax error.
     */
    private RegexException.PatternSyntaxException error(string s) 
    {
        return new RegexException.PatternSyntaxException(@"$s, $normalizedPattern, $(cursor-1)");
        // return new PatternSyntaxException(s, normalizedPattern,  cursor - 1);
    }

    /**
     * Determines if there is any supplementary character or unpaired
     * surrogate in the specified range.
     */
    private bool findSupplementary(int start, int end) 
    {
        for (int i = start; i < end; i++) {
            if (isSupplementary(temp[i]))
                return true;
        }
        return false;
    }

    /**
     * Determines if the specified code point is a supplementary
     * character or unpaired surrogate.
     */
    private static bool isSupplementary(int ch) 
    {
        return ch >= Character.MIN_SUPPLEMENTARY_CODE_POINT ||
               Character.IsSurrogate(ch);
    }

    /**
     *  The following methods handle the main parsing. They are sorted
     *  according to their precedence order, the lowest one first.
     */

    /**
     * The expression is parsed with branch nodes added for alternations.
     * This may be called recursively to parse sub expressions that may
     * contain alternations.
     */
    private Node expr(Node end) 
    {
        Node prev = null;
        Node firstTail = null;
        Branch branch = null;
        Node branchConn = null;

        for (;;) {
            Node node = sequence(end);
            Node nodeTail = Root;      //double return
            if (prev == null) {
                prev = node;
                firstTail = nodeTail;
            } else {
                // Branch
                if (branchConn == null) {
                    branchConn = new BranchConn();
                    branchConn.next = end;
                }
                if (node == end) {
                    // if the node returned from sequence() is "end"
                    // we have an empty expr, set a null atom into
                    // the branch to indicate to go "next" directly.
                    node = null;
                } else {
                    // the "tail.next" of each atom goes to branchConn
                    nodeTail.next = branchConn;
                }
                if (prev == branch) {
                    branch.add(node);
                } else {
                    if (prev == end) {
                        prev = null;
                    } else {
                        // replace the "end" with "branchConn" at its tail.next
                        // when put the "prev" into the branch as the first atom.
                        firstTail.next = branchConn;
                    }
                    prev = branch = new Branch(prev, node, branchConn);
                }
            }
            if (peek() != '|') {
                return prev;
            }
            next();
        }
    }

    /**
     * Parsing of sequences between alternations.
     */
    private Node sequence(Node end) 
    {
        Node head = null;
        Node tail = null;
        Node node = null;
        var skip = false;
    //LOOP:
        for (;;) {
            int ch = peek();
            switch (ch) {
            case '(':
                // Because group handles its own closure,
                // we need to treat it differently
                node = group0();
                // Check for comment or flag group
                if (node == null)
                    continue;
                if (head == null)
                    head = node;
                else
                    tail.next = node;
                // Double return: Tail was returned in Root
                tail = Root;
                continue;
            case '[':
                node = clazz(true);
                break;
            case '\\':
                ch = nextEscaped();
                if (ch == 'p' || ch == 'P') {
                    bool oneLetter = true;
                    bool comp = (ch == 'P');
                    ch = next(); // Consume { if present
                    if (ch != '{') {
                        unread();
                    } else {
                        oneLetter = false;
                    }
                    node = family(oneLetter, comp);
                } else {
                    unread();
                    node = atom();
                }
                break;
            case '^':
                next();
                if (has(MULTILINE)) {
                    if (has(UNIX_LINES))
                        node = new UnixCaret();
                    else
                        node = new Caret();
                } else {
                    node = new Begin();
                }
                break;
            case '$':
                next();
                if (has(UNIX_LINES))
                    node = new UnixDollar(has(MULTILINE));
                else
                    node = new Dollar(has(MULTILINE));
                break;
            case '.':
                next();
                if (has(DOTALL)) {
                    node = new All();
                } else {
                    if (has(UNIX_LINES))
                        node = new UnixDot();
                    else {
                        node = new Dot();
                    }
                }
                break;
            case '|':
            case ')':
                skip = true;
                break;// LOOP;
            case ']': // Now interpreting dangling ] and } as literals
            case '}':
                node = atom();
                break;
            case '?':
            case '*':
            case '+':
                next();
                throw error("Dangling meta character '$ch'");
            case 0:
                if (cursor >= patternLength) {
                    skip = true;
                    break;// LOOP;
                }
                // Fall through
                node = atom();
                break;
            default:
                node = atom();
                break;
            }
            if (skip) break;

            node = closure(node);

            if (head == null) {
                head = tail = node;
            } else {
                tail.next = node;
                tail = node;
            }
        }
        if (head == null) {
            return end;
        }
        tail.next = end;
        Root = tail;      //double return
        return head;
    }

    /**
     * Parse and add a new Single or Slice.
     */
    private Node atom() 
    {
        int first = 0;
        int prev = -1;
        bool hasSupplementary = false;
        int ch = peek();
        for (;;) {
            switch (ch) {
            case '*':
            case '+':
            case '?':
            case '{':
                if (first > 1) {
                    cursor = prev;    // Unwind one character
                    first--;
                }
                break;
            case '$':
            case '.':
            case '^':
            case '(':
            case '[':
            case '|':
            case ')':
                break;
            case '\\':
                ch = nextEscaped();
                if (ch == 'p' || ch == 'P') { // Property
                    if (first > 0) { // Slice is waiting; handle it first
                        unread();
                        break;
                    } else { // No slice; just return the family node
                        bool comp = (ch == 'P');
                        bool oneLetter = true;
                        ch = next(); // Consume { if present
                        if (ch != '{')
                            unread();
                        else
                            oneLetter = false;
                        return family(oneLetter, comp);
                    }
                }
                unread();
                prev = cursor;
                ch = escape(false, first == 0, false);
                if (ch >= 0) {
                    append(ch, first);
                    first++;
                    if (isSupplementary(ch)) {
                        hasSupplementary = true;
                    }
                    ch = peek();
                    continue;
                } else if (first == 0) {
                    return Root;
                }
                // Unwind meta escape sequence
                cursor = prev;
                break;
            case 0:
                if (cursor >= patternLength) {
                    break;
                }
                // Fall through
                prev = cursor;
                append(ch, first);
                first++;
                if (isSupplementary(ch)) {
                    hasSupplementary = true;
                }
                ch = next();
                continue;
            default:
                prev = cursor;
                append(ch, first);
                first++;
                if (isSupplementary(ch)) {
                    hasSupplementary = true;
                }
                ch = next();
                continue;
            }
            break;
        }
        if (first == 1) {
            return newSingle(Buffer[0]);
        } else {
            return newSlice(Buffer, first, hasSupplementary);
        }
    }

    private void append(int ch, int len) 
    {
        if (len >= Buffer.length) {
            int[] tmp = new int[len+len];
            System.arraycopy<int>(Buffer, 0, tmp, 0, len);
            Buffer = tmp;
        }
        Buffer[len] = ch;
    }

    /**
     * Parses a backref greedily, taking as many numbers as it
     * can. The first digit is always treated as a backref, but
     * multi digit numbers are only treated as a backref if at
     * least that many backrefs exist at this point in the regex.
     */
    private Node ref(int refNum) 
    {
        bool done = false;
        while(!done) {
            int ch = peek();
            switch(ch) {
            case '0':
            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
                int newRefNum = (refNum * 10) + (ch - '0');
                // Add another number if it doesn't make a group
                // that doesn't exist
                if (CapturingGroupCount - 1 < newRefNum) {
                    done = true;
                    break;
                }
                refNum = newRefNum;
                read();
                break;
            default:
                done = true;
                break;
            }
        }
        if (has(CASE_INSENSITIVE))
            return new CIBackRef(refNum, has(UNICODE_CASE));
        else
            return new BackRef(refNum);
    }

    /**
     * Parses an escape sequence to determine the actual value that needs
     * to be matched.
     * If -1 is returned and create was true a new object was added to the tree
     * to handle the escape sequence.
     * If the returned value is greater than zero, it is the value that
     * matches the escape sequence.
     */
    private int escape(bool inclass, bool create, bool isrange) 
    {
        int ch = skip();
        switch (ch) {
        case '0':
            return o();
        case '1':
        case '2':
        case '3':
        case '4':
        case '5':
        case '6':
        case '7':
        case '8':
        case '9':
            if (inclass) break;
            if (create) {
                Root = ref((ch - '0'));
            }
            return -1;
        case 'A':
            if (inclass) break;
            if (create) Root = new Begin();
            return -1;
        case 'B':
            if (inclass) break;
            if (create) Root = new Bound(Bound.NONE, has(UNICODE_CHARACTER_CLASS));
            return -1;
        case 'C':
            break;
        case 'D':
            if (create) Root = has(UNICODE_CHARACTER_CLASS)
                               ? new Utype(UnicodeProp.DIGIT).complement()
                               : new Ctype(ASCII.DIGIT).complement();
            return -1;
        case 'E':
        case 'F':
            break;
        case 'G':
            if (inclass) break;
            if (create) Root = new LastMatch();
            return -1;
        case 'H':
            if (create) Root = new HorizWS().complement();
            return -1;
        case 'I':
        case 'J':
        case 'K':
        case 'L':
        case 'M':
        case 'N':
        case 'O':
        case 'P':
        case 'Q':
            break;
        case 'R':
            if (inclass) break;
            if (create) Root = new LineEnding();
            return -1;
        case 'S':
            if (create) Root = has(UNICODE_CHARACTER_CLASS)
                               ? new Utype(UnicodeProp.WHITE_SPACE).complement()
                               : new Ctype(ASCII.SPACE).complement();
            return -1;
        case 'T':
        case 'U':
            break;
        case 'V':
            if (create) Root = new VertWS().complement();
            return -1;
        case 'W':
            if (create) Root = has(UNICODE_CHARACTER_CLASS)
                               ? new Utype(UnicodeProp.WORD).complement()
                               : new Ctype(ASCII.WORD).complement();
            return -1;
        case 'X':
        case 'Y':
            break;
        case 'Z':
            if (inclass) break;
            if (create) {
                if (has(UNIX_LINES))
                    Root = new UnixDollar(false);
                else
                    Root = new Dollar(false);
            }
            return -1;
        case 'a':
            return 0x07;
        case 'b':
            if (inclass) break;
            if (create) Root = new Bound(Bound.BOTH, has(UNICODE_CHARACTER_CLASS));
            return -1;
        case 'c':
            return c();
        case 'd':
            if (create) Root = has(UNICODE_CHARACTER_CLASS)
                               ? new Utype(UnicodeProp.DIGIT)
                               : (Node)new Ctype(ASCII.DIGIT);
            return -1;
        case 'e':
            return 033;
        case 'f':
            return '\f';
        case 'g':
            break;
        case 'h':
            if (create) Root = new HorizWS();
            return -1;
        case 'i':
        case 'j':
            break;
        case 'k':
            if (inclass)
                break;
            if (read() != '<')
                throw error("\\k is not followed by '<' for named capturing group");
            string name = groupname(read());
            if (!GetNamedGroups().ContainsKey(name))
                throw error("(named capturing group <"+ name+"> does not exit");
            if (create) {
                if (has(CASE_INSENSITIVE))
                    Root = new CIBackRef(GetNamedGroups()[name], has(UNICODE_CASE));
                else
                    Root = new BackRef(GetNamedGroups()[name]);
            }
            return -1;
        case 'l':
        case 'm':
            break;
        case 'n':
            return '\n';
        case 'o':
        case 'p':
        case 'q':
            break;
        case 'r':
            return '\r';
        case 's':
            if (create) Root = has(UNICODE_CHARACTER_CLASS)
                               ? new Utype(UnicodeProp.WHITE_SPACE)
                               : (Node)new Ctype(ASCII.SPACE);
            return -1;
        case 't':
            return '\t';
        case 'u':
            return u();
        case 'v':
            // '\v' was implemented as VT/0x0B in releases < 1.8 (though
            // undocumented). In JDK8 '\v' is specified as a predefined
            // character class for all vertical whitespace characters.
            // So [-1, Root=VertWS node] pair is returned (instead of a
            // single 0x0B). This breaks the range if '\v' is used as
            // the start or end value, such as [\v-...] or [...-\v], in
            // which a single definite value (0x0B) is expected. For
            // compatibility concern '\013'/0x0B is returned if isrange.
            if (isrange)
                return 013;
            if (create) Root = new VertWS();
            return -1;
        case 'w':
            if (create) Root = has(UNICODE_CHARACTER_CLASS)
                               ? new Utype(UnicodeProp.WORD)
                               : (Node)new Ctype(ASCII.WORD);
            return -1;
        case 'x':
            return x();
        case 'y':
            break;
        case 'z':
            if (inclass) break;
            if (create) Root = new End();
            return -1;
        default:
            return ch;
        }
        throw error("Illegal/unsupported escape sequence");
    }

    /**
     * Parse a character class, and return the node that matches it.
     *
     * Consumes a ] on the way out if consume is true. Usually consume
     * is true except for the case of [abc&&def] where def is a separate
     * right hand node with "understood" brackets.
     */
    private CharProperty clazz(bool consume) 
    {
        CharProperty prev = null;
        CharProperty node = null;
        BitClass bits = new BitClass();
        bool include = true;
        bool firstInClass = true;
        int ch = next();
        for (;;) {
            switch (ch) {
                case '^':
                    // Negates if first char in a class, otherwise literal
                    if (firstInClass) {
                        if (temp[cursor-1] != '[')
                            break;
                        ch = next();
                        include = !include;
                        continue;
                    } else {
                        // ^ not first in class, treat as literal
                        break;
                    }
                case '[':
                    firstInClass = false;
                    node = clazz(true);
                    if (prev == null)
                        prev = node;
                    else
                        prev = union(prev, node);
                    ch = peek();
                    continue;
                case '&':
                    firstInClass = false;
                    ch = next();
                    if (ch == '&') {
                        ch = next();
                        CharProperty rightNode = null;
                        while (ch != ']' && ch != '&') {
                            if (ch == '[') {
                                if (rightNode == null)
                                    rightNode = clazz(true);
                                else
                                    rightNode = union(rightNode, clazz(true));
                            } else { // abc&&def
                                unread();
                                rightNode = clazz(false);
                            }
                            ch = peek();
                        }
                        if (rightNode != null)
                            node = rightNode;
                        if (prev == null) {
                            if (rightNode == null)
                                throw error("Bad class syntax");
                            else
                                prev = rightNode;
                        } else {
                            prev = intersection(prev, node);
                        }
                    } else {
                        // treat as a literal &
                        unread();
                        break;
                    }
                    continue;
                case 0:
                    firstInClass = false;
                    if (cursor >= patternLength)
                        throw error("Unclosed character class");
                    break;
                case ']':
                    firstInClass = false;
                    if (prev != null) {
                        if (consume)
                            next();
                        return prev;
                    }
                    break;
                default:
                    firstInClass = false;
                    break;
            }
            node = range(bits);
            if (include) {
                if (prev == null) {
                    prev = node;
                } else {
                    if (prev != node)
                        prev = union(prev, node);
                }
            } else {
                if (prev == null) {
                    prev = node.complement();
                } else {
                    if (prev != node)
                        prev = setDifference(prev, node);
                }
            }
            ch = peek();
        }
    }

    private CharProperty bitsOrSingle(BitClass bits, int ch) 
    {
        /* Bits can only handle codepoints in [u+0000-u+00ff] range.
           Use "single" node instead of bits when dealing with unicode
           case folding for codepoints listed below.
           (1)Uppercase out of range: u+00ff, u+00b5
              toUpperCase(u+00ff) -> u+0178
              toUpperCase(u+00b5) -> u+039c
           (2)LatinSmallLetterLongS u+17f
              toUpperCase(u+017f) -> u+0053
           (3)LatinSmallLetterDotlessI u+131
              toUpperCase(u+0131) -> u+0049
           (4)LatinCapitalLetterIWithDotAbove u+0130
              toLowerCase(u+0130) -> u+0069
           (5)KelvinSign u+212a
              toLowerCase(u+212a) ==> u+006B
           (6)AngstromSign u+212b
              toLowerCase(u+212b) ==> u+00e5
        */
        int d;
        if (ch < 256 &&
            !(has(CASE_INSENSITIVE) && has(UNICODE_CASE) &&
              (ch == 0xff || ch == 0xb5 ||
               ch == 0x49 || ch == 0x69 ||  //I and i
               ch == 0x53 || ch == 0x73 ||  //S and s
               ch == 0x4b || ch == 0x6b ||  //K and k
               ch == 0xc5 || ch == 0xe5)))  //A+ring
            return bits.add(ch, GetFlags());
        return newSingle(ch);
    }

    /**
     * Parse a single character or a character range in a character class
     * and return its representative node.
     */
    private CharProperty range(BitClass bits) 
    {
        int ch = peek();
        if (ch == '\\') {
            ch = nextEscaped();
            if (ch == 'p' || ch == 'P') { // A property
                bool comp = (ch == 'P');
                bool oneLetter = true;
                // Consume { if present
                ch = next();
                if (ch != '{')
                    unread();
                else
                    oneLetter = false;
                return family(oneLetter, comp);
            } else { // ordinary escape
                bool isrange = temp[cursor+1] == '-';
                unread();
                ch = escape(true, true, isrange);
                if (ch == -1)
                    return (CharProperty) Root;
            }
        } else {
            next();
        }
        if (ch >= 0) {
            if (peek() == '-') {
                int endRange = temp[cursor+1];
                if (endRange == '[') {
                    return bitsOrSingle(bits, ch);
                }
                if (endRange != ']') {
                    next();
                    int m = peek();
                    if (m == '\\') {
                        m = escape(true, false, true);
                    } else {
                        next();
                    }
                    if (m < ch) {
                        throw error("Illegal character range");
                    }
                    if (has(CASE_INSENSITIVE))
                        return caseInsensitiveRangeFor(ch, m);
                    else
                        return rangeFor(ch, m);
                }
            }
            return bitsOrSingle(bits, ch);
        }
        throw error(@"Unexpected character '$ch'");
    }

    /**
     * Parses a Unicode character family and returns its representative node.
     */
    private CharProperty family(bool singleLetter,
                                bool maybeComplement)
    {
        next();
        string name;
        CharProperty node = null;

        if (singleLetter) {
            int c = temp[cursor];
            if (!Character.IsSupplementaryCodePoint(c)) {
                name = c.to_string(); // string.valueOf((char)c);
            } else {
                name = ((unichar)temp[cursor]).to_string();
            }
            read();
        } else {
            int i = cursor;
            mark('}');
            while(read() != '}') {
            }
            mark(0);
            int j = cursor;
            if (j > patternLength)
                throw error("Unclosed character family");
            if (i + 1 >= j)
                throw error("Empty character family");
            name = ((string32)temp).to_string().substring(i, j-i-1);
            // name = new string(temp, i, j-i-1);
        }

        int i = name.index_of_char('=');
        if (i != -1) {
            // property construct \p{name=value}
            string value = name.substring(i + 1);
            name = name.substr(0, i).down();
            if ("sc".Equals(name) || "script".Equals(name)) {
                node = unicodeScriptPropertyFor(value);
            } else if ("blk".Equals(name) || "block".Equals(name)) {
                node = unicodeBlockPropertyFor(value);
            } else if ("gc".Equals(name) || "general_category".Equals(name)) {
                node = charPropertyNodeFor(value);
            } else {
                throw error("Unknown Unicode property {name=<" + name + ">, "
                             + "value=<" + value + ">}");
            }
        } else {
            if (name.starts_with("In")) {
                // \p{inBlockName}
                node = unicodeBlockPropertyFor(name.substring(2));
            } else if (name.starts_with("Is")) {
                // \p{isGeneralCategory} and \p{isScriptName}
                name = name.substring(2);
                UnicodeProp uprop = UnicodeProp.ForName(name);
                if (uprop != -1)
                    node = new Utype(uprop);
                if (node == null)
                    node = CharPropertyNames.charPropertyFor(name);
                if (node == null)
                    node = unicodeScriptPropertyFor(name);
            } else {
                if (has(UNICODE_CHARACTER_CLASS)) {
                    UnicodeProp uprop = UnicodeProp.ForPOSIXName(name);
                    // if (uprop != null)
                        node = new Utype(uprop);
                }
                if (node == null)
                    node = charPropertyNodeFor(name);
            }
        }
        if (maybeComplement) {
            if (node is Category || node is Block)
                hasSupplementary = true;
            node = node.complement();
        }
        return node;
    }


    /**
     * Returns a CharProperty matching all characters belong to
     * a UnicodeScript.
     */
    private CharProperty unicodeScriptPropertyFor(string name) 
    {
        UnicodeScript script;
        try {
            EnumClass ec = (EnumClass) typeof (UnicodeScript).class_ref ();
            unowned EnumValue? item = ec.get_value_by_name (@"GLIB_UNICODESCRIPT_$name");
            script = (UnicodeScript)item.value;
            // script = UnicodeScript.forName(name);
        } catch (Exception.IllegalArgumentException iae) {
            throw error(@"Unknown character script name {$name}");
        }
        return new Script(script);
    }

    /**
     * Returns a CharProperty matching all characters in a UnicodeBlock.
     */
    private CharProperty unicodeBlockPropertyFor(string name) 
    {
        Character.UnicodeBlock block;
        try {
            block = Character.UnicodeBlock.ForName(name);
        } catch (Exception.IllegalArgumentException iae) {
            throw error(@"Unknown character block name {$name}");
        }
        return new Block(block);
    }

    /**
     * Returns a CharProperty matching all characters in a named property.
     */
    private CharProperty charPropertyNodeFor(string name) 
    {
        CharProperty p = CharPropertyNames.charPropertyFor(name);
        if (p == null)
            throw error("Unknown character property name {" + name + "}");
        return p;
    }

    /**
     * Parses and returns the name of a "named capturing group", the trailing
     * ">" is consumed after parsing.
     */
    private string groupname(int ch) 
    {
        StringBuilder sb = new StringBuilder();
        sb.append(((unichar)ch).to_string());
        while (ASCII.IsLower(ch=read()) || ASCII.IsUpper(ch) ||
               ASCII.IsDigit(ch)) {
            sb.append(((unichar)ch).to_string());
        }
        if (sb.len == 0)
            throw error("named capturing group has 0 length name");
        if (ch != '>')
            throw error("named capturing group is missing trailing '>'");
        return sb.str;
    }

    /**
     * Parses a group and returns the head node of a set of nodes that process
     * the group. Sometimes a double return system is used where the tail is
     * returned in Root.
     */
    private Node group0() 
    {
        bool capturingGroup = false;
        Node head = null;
        Node tail = null;
        int save = flags;
        Root = null;
        int ch = next();
        if (ch == '?') {
            ch = skip();
            switch (ch) {
            case ':':   //  (?:xxx) pure group
                head = createGroup(true);
                tail = Root;
                head.next = expr(tail);
                break;
            case '=':   // (?=xxx) and (?!xxx) lookahead
            case '!':
                head = createGroup(true);
                tail = Root;
                head.next = expr(tail);
                if (ch == '=') {
                    head = tail = new Pos(head);
                } else {
                    head = tail = new Neg(head);
                }
                break;
            case '>':   // (?>xxx)  independent group
                head = createGroup(true);
                tail = Root;
                head.next = expr(tail);
                head = tail = new Ques(head, INDEPENDENT);
                break;
            case '<':   // (?<xxx)  look behind
                ch = read();
                if (ASCII.IsLower(ch) || ASCII.IsUpper(ch)) {
                    // named captured group
                    string name = groupname(ch);
                    if (GetNamedGroups().ContainsKey(name))
                        throw error("Named capturing group <$name> is already defined");
                    capturingGroup = true;
                    head = createGroup(false);
                    tail = Root;
                    GetNamedGroups()[name] = CapturingGroupCount-1;
                    head.next = expr(tail);
                    break;
                }
                int start = cursor;
                head = createGroup(true);
                tail = Root;
                head.next = expr(tail);
                tail.next = lookbehindEnd;
                TreeInfo info = new TreeInfo();
                head.study(info);
                if (info.maxValid == false) {
                    throw error("Look-behind group does not have "
                                + "an obvious maximum length");
                }
                bool hasSupplementary = findSupplementary(start, patternLength);
                if (ch == '=') {
                    head = tail = (hasSupplementary ?
                                   new BehindS(head, info.maxLength,
                                               info.minLength) :
                                   new Behind(head, info.maxLength,
                                              info.minLength));
                } else if (ch == '!') {
                    head = tail = (hasSupplementary ?
                                   new NotBehindS(head, info.maxLength,
                                                  info.minLength) :
                                   new NotBehind(head, info.maxLength,
                                                 info.minLength));
                } else {
                    throw error("Unknown look-behind group");
                }
                break;
            case '$':
            case '@':
                throw error("Unknown group type");
            default:    // (?xxx:) inlined match flags
                unread();
                addFlag();
                ch = read();
                if (ch == ')') {
                    return null;    // Inline modifier only
                }
                if (ch != ':') {
                    throw error("Unknown inline modifier");
                }
                head = createGroup(true);
                tail = Root;
                head.next = expr(tail);
                break;
            }
        } else { // (xxx) a regular group
            capturingGroup = true;
            head = createGroup(false);
            tail = Root;
            head.next = expr(tail);
        }

        acceptNext(')', "Unclosed group");
        flags = save;

        // Check for quantifiers
        Node node = closure(head);
        if (node == head) { // No closure
            Root = tail;
            return node;    // Dual return
        }
        if (head == tail) { // Zero length assertion
            Root = node;
            return node;    // Dual return
        }

        if (node is Ques) {
            Ques ques = (Ques) node;
            if (ques.type == POSSESSIVE) {
                Root = node;
                return node;
            }
            tail.next = new BranchConn();
            tail = tail.next;
            if (ques.type == GREEDY) {
                head = new Branch(head, null, tail);
            } else { // Reluctant quantifier
                head = new Branch(null, head, tail);
            }
            Root = tail;
            return head;
        } else if (node is Curly) {
            Curly curly = (Curly) node;
            if (curly.type == POSSESSIVE) {
                Root = node;
                return node;
            }
            // Discover if the group is deterministic
            TreeInfo info = new TreeInfo();
            if (head.study(info)) { // Deterministic
                GroupTail temp = (GroupTail) tail;
                head = Root = new GroupCurly(head.next, curly.cmin,
                                   curly.cmax, curly.type,
                                   ((GroupTail)tail).localIndex,
                                   ((GroupTail)tail).groupIndex,
                                             capturingGroup);
                return head;
            } else { // Non-deterministic
                int temp = ((GroupHead) head).localIndex;
                Loop loop;
                if (curly.type == GREEDY)
                    loop = new Loop(LocalCount, temp);
                else  // Reluctant Curly
                    loop = new LazyLoop(LocalCount, temp);
                Prolog prolog = new Prolog(loop);
                LocalCount += 1;
                loop.cmin = curly.cmin;
                loop.cmax = curly.cmax;
                loop.body = head;
                tail.next = loop;
                Root = loop;
                return prolog; // Dual return
            }
        }
        throw error("Internal logic error");
    }

    /**
     * Create group head and tail nodes using double return. If the group is
     * created with anonymous true then it is a pure group and should not
     * affect group counting.
     */
    private Node createGroup(bool anonymous) 
    {
        int localIndex = LocalCount++;
        int groupIndex = 0;
        if (!anonymous)
            groupIndex = CapturingGroupCount++;
        GroupHead head = new GroupHead(localIndex);
        Root = new GroupTail(localIndex, groupIndex);
        if (!anonymous && groupIndex < 10)
            GroupNodes[groupIndex] = head;
        return head;
    }

    /**
     * Parses inlined match flags and set them appropriately.
     */
    private void addFlag() 
    {
        int ch = peek();
        for (;;) {
            switch (ch) {
            case 'i':
                flags |= CASE_INSENSITIVE;
                break;
            case 'm':
                flags |= MULTILINE;
                break;
            case 's':
                flags |= DOTALL;
                break;
            case 'd':
                flags |= UNIX_LINES;
                break;
            case 'u':
                flags |= UNICODE_CASE;
                break;
            case 'c':
                flags |= CANON_EQ;
                break;
            case 'x':
                flags |= COMMENTS;
                break;
            case 'U':
                flags |= (UNICODE_CHARACTER_CLASS | UNICODE_CASE);
                break;
            case '-': // subFlag then fall through
                ch = next();
                subFlag();
                return;
            default:
                return;
            }
            ch = next();
        }
    }

    /**
     * Parses the second part of inlined match flags and turns off
     * flags appropriately.
     */
    private void subFlag() {
        int ch = peek();
        for (;;) {
            switch (ch) {
            case 'i':
                flags &= ~CASE_INSENSITIVE;
                break;
            case 'm':
                flags &= ~MULTILINE;
                break;
            case 's':
                flags &= ~DOTALL;
                break;
            case 'd':
                flags &= ~UNIX_LINES;
                break;
            case 'u':
                flags &= ~UNICODE_CASE;
                break;
            case 'c':
                flags &= ~CANON_EQ;
                break;
            case 'x':
                flags &= ~COMMENTS;
                break;
            case 'U':
                flags &= ~(UNICODE_CHARACTER_CLASS | UNICODE_CASE);
                return;
            default:
                return;
            }
            ch = next();
        }
    }

    const int MAX_REPS   = 0x7FFFFFFF;

    const int GREEDY     = 0;

    const int LAZY       = 1;

    const int POSSESSIVE = 2;

    const int INDEPENDENT = 3;

    /**
     * Processes repetition. If the next character peeked is a quantifier
     * then new nodes must be appended to handle the repetition.
     * Prev could be a single or a group, so it could be a chain of nodes.
     */
    private Node closure(Node prev) 
    {
        Node atom;
        int ch = peek();
        switch (ch) {
        case '?':
            ch = next();
            if (ch == '?') {
                next();
                return new Ques(prev, LAZY);
            } else if (ch == '+') {
                next();
                return new Ques(prev, POSSESSIVE);
            }
            return new Ques(prev, GREEDY);
        case '*':
            ch = next();
            if (ch == '?') {
                next();
                return new Curly(prev, 0, MAX_REPS, LAZY);
            } else if (ch == '+') {
                next();
                return new Curly(prev, 0, MAX_REPS, POSSESSIVE);
            }
            return new Curly(prev, 0, MAX_REPS, GREEDY);
        case '+':
            ch = next();
            if (ch == '?') {
                next();
                return new Curly(prev, 1, MAX_REPS, LAZY);
            } else if (ch == '+') {
                next();
                return new Curly(prev, 1, MAX_REPS, POSSESSIVE);
            }
            return new Curly(prev, 1, MAX_REPS, GREEDY);
        case '{':
            ch = temp[cursor+1];
            if (ASCII.IsDigit(ch)) {
                skip();
                int cmin = 0;
                do {
                    cmin = cmin * 10 + (ch - '0');
                } while (ASCII.IsDigit(ch = read()));
                int cmax = cmin;
                if (ch == ',') {
                    ch = read();
                    cmax = MAX_REPS;
                    if (ch != '}') {
                        cmax = 0;
                        while (ASCII.IsDigit(ch)) {
                            cmax = cmax * 10 + (ch - '0');
                            ch = read();
                        }
                    }
                }
                if (ch != '}')
                    throw error("Unclosed counted closure");
                if (((cmin) | (cmax) | (cmax - cmin)) < 0)
                    throw error("Illegal repetition range");
                Curly curly;
                ch = peek();
                if (ch == '?') {
                    next();
                    curly = new Curly(prev, cmin, cmax, LAZY);
                } else if (ch == '+') {
                    next();
                    curly = new Curly(prev, cmin, cmax, POSSESSIVE);
                } else {
                    curly = new Curly(prev, cmin, cmax, GREEDY);
                }
                return curly;
            } else {
                throw error("Illegal repetition");
            }
        default:
            return prev;
        }
    }

    /**
     *  Utility method for parsing control escape sequences.
     */
    private int c() 
    {
        if (cursor < patternLength) {
            return read() ^ 64;
        }
        throw error("Illegal control escape sequence");
    }

    /**
     *  Utility method for parsing octal escape sequences.
     */
    private int o() 
    {
        int n = read();
        if (((n-'0')|('7'-n)) >= 0) {
            int m = read();
            if (((m-'0')|('7'-m)) >= 0) {
                int o = read();
                if ((((o-'0')|('7'-o)) >= 0) && (((n-'0')|('3'-n)) >= 0)) {
                    return (n - '0') * 64 + (m - '0') * 8 + (o - '0');
                }
                unread();
                return (n - '0') * 8 + (m - '0');
            }
            unread();
            return (n - '0');
        }
        throw error("Illegal octal escape sequence");
    }

    /**
     *  Utility method for parsing hexadecimal escape sequences.
     */
    private int x() 
    {
        int n = read();
        if (ASCII.IsHexDigit(n)) {
            int m = read();
            if (ASCII.IsHexDigit(m)) {
                return ASCII.ToDigit(n) * 16 + ASCII.ToDigit(m);
            }
        } else if (n == '{' && ASCII.IsHexDigit(peek())) {
            int ch = 0;
            while (ASCII.IsHexDigit(n = read())) {
                ch = (ch << 4) + ASCII.ToDigit(n);
                if (ch > Character.MAX_CODE_POINT)
                    throw error("Hexadecimal codepoint is too big");
            }
            if (n != '}')
                throw error("Unclosed hexadecimal escape sequence");
            return ch;
        }
        throw error("Illegal hexadecimal escape sequence");
    }

    /**
     *  Utility method for parsing unicode escape sequences.
     */
    // private int cursor() 
    // {
    //     return cursor;
    // }

    private void setcursor(int pos) 
    {
        cursor = pos;
    }

    private int uxxxx() 
    {
        int n = 0;
        for (int i = 0; i < 4; i++) {
            int ch = read();
            if (!ASCII.IsHexDigit(ch)) {
                throw error("Illegal Unicode escape sequence");
            }
            n = n * 16 + ASCII.ToDigit(ch);
        }
        return n;
    }

    private int u() 
    {
        int n = uxxxx();
        if (Character.IsHighSurrogate((unichar)n)) {
            int cur = cursor; //();
            if (read() == '\\' && read() == 'u') {
                int n2 = uxxxx();
                if (Character.IsLowSurrogate((unichar)n2))
                    return Character.ToCodePoint((unichar)n, (unichar)n2);
            }
            setcursor(cur);
        }
        return n;
    }

    //
    // Utility methods for code point support
    //

    private static int countChars(string seq, int index,
                                        int lengthInCodePoints) 
    {
        // optimization
        if (lengthInCodePoints == 1 && !Character.IsHighSurrogate(seq.get_char(index))) {
            assert (index >= 0 && index < seq.length);
            return 1;
        }
        int length = seq.length;
        int x = index;
        if (lengthInCodePoints >= 0) {
            assert (index >= 0 && index < length);
            for (int i = 0; x < length && i < lengthInCodePoints; i++) {
                if (Character.IsHighSurrogate(seq.get_char(x++))) {
                    if (x < length && Character.IsLowSurrogate(seq.get_char(x))) {
                        x++;
                    }
                }
            }
            return x - index;
        }

        assert (index >= 0 && index <= length);
        if (index == 0) {
            return 0;
        }
        int len = -lengthInCodePoints;
        for (int i = 0; x > 0 && i < len; i++) {
            if (Character.IsLowSurrogate(seq.get_char(--x))) {
                if (x > 0 && Character.IsHighSurrogate(seq.get_char(x-1))) {
                    x--;
                }
            }
        }
        return index - x;
    }

    private static int countCodePoints(string seq) 
    {
        int length = seq.length;
        int n = 0;
        for (int i = 0; i < length; ) {
            n++;
            if (Character.IsHighSurrogate(seq.get_char(i++))) {
                if (i < length && Character.IsLowSurrogate(seq.get_char(i))) {
                    i++;
                }
            }
        }
        return n;
    }

    /**
     *  Creates a bit vector for matching Latin-1 values. A normal BitClass
     *  never matches values above Latin-1, and a complemented BitClass always
     *  matches values above Latin-1.
     */
    public class BitClass : BmpCharProperty 
    {
        public bool[] bits;
        public BitClass() { 
            bits = new bool[256]; 
            isSatisfiedBy = (ch) => {
                return ch < 256 && bits[ch];
            };
        }
        // private BitClass(bool[] bits) { this.bits = bits; }
        public BitClass add(int c, int flags) {
            assert (c >= 0 && c <= 255);
            if ((flags & CASE_INSENSITIVE) != 0) {
                if (ASCII.IsAscii(c)) {
                    bits[ASCII.ToUpper(c)] = true;
                    bits[ASCII.ToLower(c)] = true;
                } else if ((flags & UNICODE_CASE) != 0) {
                    bits[Character.ToLowerCase(c)] = true;
                    bits[Character.ToUpperCase(c)] = true;
                }
            }
            bits[c] = true;
            return this;
        }
   }

    /**
     *  Returns a suitably optimized, single character matcher.
     */
    private CharProperty newSingle(int ch) 
    {
        if (has(CASE_INSENSITIVE)) {
            int lower, upper;
            if (has(UNICODE_CASE)) {
                upper = Character.ToUpperCase(ch);
                lower = Character.ToLowerCase(upper);
                if (upper != lower)
                    return new SingleU(lower);
            } else if (ASCII.IsAscii(ch)) {
                lower = ASCII.ToLower(ch);
                upper = ASCII.ToUpper(ch);
                if (lower != upper)
                    return new SingleI(lower, upper);
            }
        }
        if (isSupplementary(ch))
            return new SingleS(ch);    // Match a given Unicode character
        return new Single(ch);         // Match a given BMP character
    }

    /**
     *  Utility method for creating a string slice matcher.
     */
    private Node newSlice(int[] buf, int count, bool hasSupplementary) 
    {
        int[] tmp = new int[count];
        if (has(CASE_INSENSITIVE)) {
            if (has(UNICODE_CASE)) {
                for (int i = 0; i < count; i++) {
                    tmp[i] = Character.ToLowerCase(
                                 Character.ToUpperCase(buf[i]));
                }
                // return hasSupplementary ? (Node)(new SliceUS(tmp)) : (Node)(new SliceU(tmp));
                return hasSupplementary ? new SliceUS(tmp) : (Node)new SliceU(tmp);
            }
            for (int i = 0; i < count; i++) {
                tmp[i] = ASCII.ToLower(buf[i]);
            }
            return hasSupplementary ? new SliceIS(tmp) : (Node)new SliceI(tmp);
        }
        for (int i = 0; i < count; i++) {
            tmp[i] = buf[i];
        }
        return hasSupplementary ? new SliceS(tmp) : (Node)new Slice(tmp);
    }

    /**
     * The following classes are the building components of the object
     * tree that represents a compiled regular expression. The object tree
     * is made of individual elements that handle constructs in the Pattern.
     * Each type of object knows how to match its equivalent construct with
     * the match() method.
     */

    /**
     * Base class for all node classes. Subclasses should override the match()
     * method as appropriate. This class is an accepting node, so its match()
     * always returns true.
     */
    public class Node : Object 
    {
        public Node next;
        public Node() {
            next = Pattern.Accept;
        }
        /**
         * This method implements the classic Accept node.
         */
        public virtual bool match(Matcher matcher, int i, string seq) {
            matcher.Last = i;
            matcher.Groups[0] = matcher.First;
            matcher.Groups[1] = matcher.Last;
            return true;
        }
        /**
         * This method is good for all zero length assertions.
         */
        public virtual bool study(TreeInfo info) {
            if (next != null) {
                return next.study(info);
            } else {
                return info.deterministic;
            }
        }
    }

    public class LastNode : Node 
    {
        /**
         * This method implements the classic Accept node with
         * the addition of a check to see if the match occurred
         * using all of the input.
         */
        public override bool match(Matcher matcher, int i, string seq) {
            if (matcher.AcceptMode == Matcher.ENDANCHOR && i != matcher.To)
                return false;
            matcher.Last = i;
            matcher.Groups[0] = matcher.First;
            matcher.Groups[1] = matcher.Last;
            return true;
        }
    }

    /**
     * Used for REs that can start anywhere within the input string.
     * This basically tries to match repeatedly at each spot in the
     * input string, moving forward after each try. An anchored search
     * or a BnM will bypass this node completely.
     */
    public class Start : Node 
    {
        public int minLength;
        public Start(Node node) {
            next = node;
            TreeInfo info = new TreeInfo();
            next.study(info);
            minLength = info.minLength;
        }
        public override bool match(Matcher matcher, int i, string seq) {
            if (i > matcher.To - minLength) {
                matcher.HitEnd = true;
                return false;
            }
            int guard = matcher.To - minLength;
            for (; i <= guard; i++) {
                if (next.match(matcher, i, seq)) {
                    matcher.First = i;
                    matcher.Groups[0] = matcher.First;
                    matcher.Groups[1] = matcher.Last;
                    return true;
                }
            }
            matcher.HitEnd = true;
            return false;
        }
        public override bool study(TreeInfo info) {
            next.study(info);
            info.maxValid = false;
            info.deterministic = false;
            return false;
        }
    }

    /*
     * StartS supports supplementary characters, including unpaired surrogates.
     */
    public class StartS : Start 
    {
        public StartS(Node node) {
            base(node);
        }
        public override bool match(Matcher matcher, int i, string seq) {
            if (i > matcher.To - minLength) {
                matcher.HitEnd = true;
                return false;
            }
            int guard = matcher.To - minLength;
            while (i <= guard) {
                //if ((ret = next.match(matcher, i, seq)) || i == guard)
                if (next.match(matcher, i, seq)) {
                    matcher.First = i;
                    matcher.Groups[0] = matcher.First;
                    matcher.Groups[1] = matcher.Last;
                    return true;
                }
                if (i == guard)
                    break;
                // Optimization to move to the next character. This is
                // faster than countChars(seq, i, 1).
                if (Character.IsHighSurrogate(seq.get_char(i++))) {
                    if (i < seq.length &&
                        Character.IsLowSurrogate(seq.get_char(i))) {
                        i++;
                    }
                }
            }
            matcher.HitEnd = true;
            return false;
        }
    }

    /**
     * Node to anchor at the beginning of input. This object implements the
     * match for a \A sequence, and the caret anchor will use this if not in
     * multiline mode.
     */
    public class Begin : Node 
    {
        public override bool match(Matcher matcher, int i, string seq) {
            int fromIndex = (matcher.AnchoringBounds) ?
                matcher.From : 0;
            if (i == fromIndex && next.match(matcher, i, seq)) {
                matcher.First = i;
                matcher.Groups[0] = i;
                matcher.Groups[1] = matcher.Last;
                return true;
            } else {
                return false;
            }
        }
    }

    /**
     * Node to anchor at the end of input. This is the absolute end, so this
     * should not match at the last newline before the end as $ will.
     */
    public class End : Node 
    {
        public override bool match(Matcher matcher, int i, string seq) {
            int endIndex = (matcher.AnchoringBounds) ?
                matcher.To : matcher.GetTextLength();
            if (i == endIndex) {
                matcher.HitEnd = true;
                return next.match(matcher, i, seq);
            }
            return false;
        }
    }

    /**
     * Node to anchor at the beginning of a line. This is essentially the
     * object to match for the multiline ^.
     */
    public class Caret : Node 
    {
        public override bool match(Matcher matcher, int i, string seq) {
            int startIndex = matcher.From;
            int endIndex = matcher.To;
            if (!matcher.AnchoringBounds) {
                startIndex = 0;
                endIndex = matcher.GetTextLength();
            }
            // Perl does not match ^ at end of input even after newline
            if (i == endIndex) {
                matcher.HitEnd = true;
                return false;
            }
            if (i > startIndex) {
                unichar ch = seq.get_char(i-1);
                if (ch != '\n' && ch != '\r'
                    && (ch|1) != 0x2029
                    && ch != 0x0085 ) {
                    return false;
                }
                // Should treat /r/n as one newline
                if (ch == '\r' && seq.get_char(i) == '\n')
                    return false;
            }
            return next.match(matcher, i, seq);
        }
    }

    /**
     * Node to anchor at the beginning of a line when in unixdot mode.
     */
    public class UnixCaret : Node 
    {
        public override bool match(Matcher matcher, int i, string seq) {
            int startIndex = matcher.From;
            int endIndex = matcher.To;
            if (!matcher.AnchoringBounds) {
                startIndex = 0;
                endIndex = matcher.GetTextLength();
            }
            // Perl does not match ^ at end of input even after newline
            if (i == endIndex) {
                matcher.HitEnd = true;
                return false;
            }
            if (i > startIndex) {
                unichar ch = seq.get_char(i-1);
                if (ch != '\n') {
                    return false;
                }
            }
            return next.match(matcher, i, seq);
        }
    }

    /**
     * Node to match the location where the last match ended.
     * This is used for the \G construct.
     */
    public class LastMatch : Node 
    {
        public override bool match(Matcher matcher, int i, string seq) {
            if (i != matcher.OldLast)
                return false;
            return next.match(matcher, i, seq);
        }
    }

    /**
     * Node to anchor at the end of a line or the end of input based on the
     * multiline mode.
     *
     * When not in multiline mode, the $ can only match at the very end
     * of the input, unless the input ends in a line terminator in which
     * it matches right before the last line terminator.
     *
     * Note that \r\n is considered an atomic line terminator.
     *
     * Like ^ the $ operator matches at a position, it does not match the
     * line terminators themselves.
     */
    public class Dollar : Node 
    {
        public bool multiline;
        public Dollar(bool mul) {
            multiline = mul;
        }
        public override bool match(Matcher matcher, int i, string seq) {
            int endIndex = (matcher.AnchoringBounds) ?
                matcher.To : matcher.GetTextLength();
            if (!multiline) {
                if (i < endIndex - 2)
                    return false;
                if (i == endIndex - 2) {
                    unichar ch = seq.get_char(i);
                    if (ch != '\r')
                        return false;
                    ch = seq.get_char(i + 1);
                    if (ch != '\n')
                        return false;
                }
            }
            // Matches before any line terminator; also matches at the
            // end of input
            // Before line terminator:
            // If multiline, we match here no matter what
            // If not multiline, fall through so that the end
            // is marked as hit; this must be a /r/n or a /n
            // at the very end so the end was hit; more input
            // could make this not match here
            if (i < endIndex) {
                unichar ch = seq.get_char(i);
                 if (ch == '\n') {
                     // No match between \r\n
                     if (i > 0 && seq.get_char(i-1) == '\r')
                         return false;
                     if (multiline)
                         return next.match(matcher, i, seq);
                 } else if (ch == '\r' || ch == 0x0085 ||
                            (ch|1) == 0x2029) {
                     if (multiline)
                         return next.match(matcher, i, seq);
                 } else { // No line terminator, no match
                     return false;
                 }
            }
            // Matched at current end so hit end
            matcher.HitEnd = true;
            // If a $ matches because of end of input, then more input
            // could cause it to fail!
            matcher.RequireEnd = true;
            return next.match(matcher, i, seq);
        }
        public override bool study(TreeInfo info) {
            next.study(info);
            return info.deterministic;
        }
    }

    /**
     * Node to anchor at the end of a line or the end of input based on the
     * multiline mode when in unix lines mode.
     */
    public class UnixDollar : Node 
    {
        public bool multiline;
        public UnixDollar(bool mul) {
            multiline = mul;
        }
        public override bool match(Matcher matcher, int i, string seq) {
            int endIndex = (matcher.AnchoringBounds) ?
                matcher.To : matcher.GetTextLength();
            if (i < endIndex) {
                unichar ch = seq.get_char(i);
                if (ch == '\n') {
                    // If not multiline, then only possible to
                    // match at very end or one before end
                    if (multiline == false && i != endIndex - 1)
                        return false;
                    // If multiline return next.match without setting
                    // matcher.HitEnd
                    if (multiline)
                        return next.match(matcher, i, seq);
                } else {
                    return false;
                }
            }
            // Matching because at the end or 1 before the end;
            // more input could change this so set hitEnd
            matcher.HitEnd = true;
            // If a $ matches because of end of input, then more input
            // could cause it to fail!
            matcher.RequireEnd = true;
            return next.match(matcher, i, seq);
        }
        public override bool study(TreeInfo info) {
            next.study(info);
            return info.deterministic;
        }
    }

    /**
     * Node class that matches a Unicode line ending '\R'
     */
    public class LineEnding : Node 
    {
        public override bool match(Matcher matcher, int i, string seq) {
            // (u+000Du+000A|[u+000Au+000Bu+000Cu+000Du+0085u+2028u+2029])
            if (i < matcher.To) {
                int ch = (int)seq.get_char(i);
                if (ch == 0x0A || ch == 0x0B || ch == 0x0C ||
                    ch == 0x85 || ch == 0x2028 || ch == 0x2029)
                    return next.match(matcher, i + 1, seq);
                if (ch == 0x0D) {
                    i++;
                    if (i < matcher.To && seq.get_char(i) == 0x0A)
                        i++;
                    return next.match(matcher, i, seq);
                }
            } else {
                matcher.HitEnd = true;
            }
            return false;
        }
        public override bool study(TreeInfo info) {
            info.minLength++;
            info.maxLength += 2;
            return next.study(info);
        }
    }

    public delegate bool IsSatisfiedBy(unichar ch);
    /**
     * Abstract node class to match one character satisfying some
     * bool property.
     */
    public class CharProperty : Node 
    {
        // public abstract bool isSatisfiedBy(int ch);
        /**
         * Implement as delegate to emulate anonymous abstract class
         */
        public IsSatisfiedBy? isSatisfiedBy; 
        public CharProperty complement() {
            CharProperty that = this;
            return new CharProperty() {
                isSatisfiedBy = (ch) => {
                        return ! that.isSatisfiedBy(ch);}};
        }
        public override bool match(Matcher matcher, int i, string seq) {
            if (i < matcher.To) {
                int ch = Character.CodePointAt(seq, i);
                return isSatisfiedBy(ch)
                    && next.match(matcher, i+Character.CharCount(ch), seq);
            } else {
                matcher.HitEnd = true;
                return false;
            }
        }
        public override bool study(TreeInfo info) {
            info.minLength++;
            info.maxLength++;
            return next.study(info);
        }
    }

    /**
     * Optimized version of CharProperty that works only for
     * properties never satisfied by Supplementary characters.
     */
    public abstract class BmpCharProperty : CharProperty 
    {
        public override bool match(Matcher matcher, int i, string seq) {
            if (i < matcher.To) {
                return isSatisfiedBy(seq.get_char(i))
                    && next.match(matcher, i+1, seq);
            } else {
                matcher.HitEnd = true;
                return false;
            }
        }
    }

    /**
     * Node class that matches a Supplementary Unicode character
     */
    public class SingleS : CharProperty 
    {
        public int c;
        public SingleS(int c) { 
            this.c = c; 
            isSatisfiedBy = (ch) => {
                return ch == c;
            };
        }
    }

    /**
     * Optimization -- matches a given BMP character
     */
    public class Single : BmpCharProperty 
    {
        public int c;
        public Single(int c) { 
            this.c = c; 
            isSatisfiedBy = (ch) => {
                return ch == c;
            };
        }
    }

    /**
     * Case insensitive matches a given BMP character
     */
    public class SingleI : BmpCharProperty 
    {
        public int lower;
        public int upper;
        public SingleI(int lower, int upper) {
            this.lower = lower;
            this.upper = upper;
            isSatisfiedBy = (ch) => {
                return ch == lower || ch == upper;
            };
        }
    }

    /**
     * Unicode case insensitive matches a given Unicode character
     */
    public class SingleU : CharProperty 
    {
        public int lower;
        public SingleU(int lower) {
            this.lower = lower;
            isSatisfiedBy = (ch) => {
                return lower == ch ||
                    lower == Character.ToLowerCase(Character.ToUpperCase((int)ch));
            };
        }
    }

    /**
     * Node class that matches a Unicode block.
     */
    public class Block : CharProperty 
    {
        public Character.UnicodeBlock block;
        public Block(Character.UnicodeBlock block) {
            this.block = block;
            isSatisfiedBy = (ch) => {
                throw new Exception.NotImplemented("Block.isSatisfiedBy");
                return false;
                // return block == Character.UnicodeBlock.of(ch);
            };
        }
    }

    /**
     * Node class that matches a Unicode script
     */
    public class Script : CharProperty 
    {
        public UnicodeScript script;
        public Script(UnicodeScript script) {
            this.script = script;
            isSatisfiedBy = (ch) => {
                throw new Exception.NotImplemented("Script.isSatisfiedBy");
                return false;
                // return script == UnicodeScript.of(ch);
            };
        }
    }

    /**
     * Node class that matches a Unicode category.
     */
    public class Category : CharProperty 
    {
        public int typeMask;
        public Category(int typeMask) { 
            this.typeMask = typeMask; 
            isSatisfiedBy = (ch) => {
                return (typeMask & (1 << Character.GetType((int)ch))) != 0;
            };
        }
    }

    /**
     * Node class that matches a Unicode "type"
     */
    public class Utype : CharProperty 
    {
        public UnicodeProp uprop;
        public Utype(UnicodeProp uprop) { 
            this.uprop = uprop; 
            isSatisfiedBy = (ch) => {
                return uprop.Is((int)ch);
            };
        }
    }

    /**
     * Node class that matches a POSIX type.
     */
    public class Ctype : BmpCharProperty 
    {
        public int ctype;
        public Ctype(int ctype) {
            this.ctype = ctype; 
            isSatisfiedBy = (ch) => {
                return ch < 128 && ASCII.IsType((int)ch, ctype);
            };
        }
    }

    /**
     * Node class that matches a Perl vertical whitespace
     */
    public class VertWS : BmpCharProperty 
    {
        public VertWS() {
            isSatisfiedBy = (cp) => {
                return (cp >= 0x0A && cp <= 0x0D) ||
                    cp == 0x85 || cp == 0x2028 || cp == 0x2029;
            };
        }
    }

    /**
     * Node class that matches a Perl horizontal whitespace
     */
    public class HorizWS : BmpCharProperty 
    {
        public HorizWS() {
            isSatisfiedBy = (cp) => {
                return cp == 0x09 || cp == 0x20 || cp == 0xa0 ||
                    cp == 0x1680 || cp == 0x180e ||
                    cp >= 0x2000 && cp <= 0x200a ||
                    cp == 0x202f || cp == 0x205f || cp == 0x3000;
            };            
        }
    }

    /**
     * Base class for all Slice nodes
     */
    public class SliceNode : Node 
    {
        public int[] buffer;
        public SliceNode(int[] buf) {
            buffer = buf;
        }
        public override bool study(TreeInfo info) {
            info.minLength += buffer.length;
            info.maxLength += buffer.length;
            return next.study(info);
        }
    }

    /**
     * Node class for a case sensitive/BMP-only sequence of literal
     * characters.
     */
    public class Slice : SliceNode 
    {
        public Slice(int[] buf) {
            base(buf);
        }
        public override bool match(Matcher matcher, int i, string seq) {
            int[] buf = buffer;
            int len = buf.length;
            for (int j=0; j<len; j++) {
                if ((i+j) >= matcher.To) {
                    matcher.HitEnd = true;
                    return false;
                }
                if (buf[j] != seq.get_char(i+j))
                    return false;
            }
            return next.match(matcher, i+len, seq);
        }
    }

    /**
     * Node class for a case_insensitive/BMP-only sequence of literal
     * characters.
     */
    public class SliceI : SliceNode 
    {
        public SliceI(int[] buf) {
            base(buf);
        }
        public override bool match(Matcher matcher, int i, string seq) {
            int[] buf = buffer;
            int len = buf.length;
            for (int j=0; j<len; j++) {
                if ((i+j) >= matcher.To) {
                    matcher.HitEnd = true;
                    return false;
                }
                int c = (int)seq.get_char(i+j);
                if (buf[j] != c &&
                    buf[j] != ASCII.ToLower(c))
                    return false;
            }
            return next.match(matcher, i+len, seq);
        }
    }

    /**
     * Node class for a unicode_case_insensitive/BMP-only sequence of
     * literal characters. Uses unicode case folding.
     */
    public class SliceU : SliceNode 
    {
        public SliceU(int[] buf) {
            base(buf);
        }
        public override bool match(Matcher matcher, int i, string seq) {
            int[] buf = buffer;
            int len = buf.length;
            for (int j=0; j<len; j++) {
                if ((i+j) >= matcher.To) {
                    matcher.HitEnd = true;
                    return false;
                }
                int c = (int)seq.get_char(i+j);
                if (buf[j] != c &&
                    buf[j] != Character.ToLowerCase(Character.ToUpperCase(c)))
                    return false;
            }
            return next.match(matcher, i+len, seq);
        }
    }

    /**
     * Node class for a case sensitive sequence of literal characters
     * including supplementary characters.
     */
    public class SliceS : SliceNode 
    {
        public SliceS(int[] buf) {
            base(buf);
        }
        public override bool match(Matcher matcher, int i, string seq) {
            int[] buf = buffer;
            int x = i;
            for (int j = 0; j < buf.length; j++) {
                if (x >= matcher.To) {
                    matcher.HitEnd = true;
                    return false;
                }
                int c = Character.CodePointAt(seq, x);
                if (buf[j] != c)
                    return false;
                x += Character.CharCount(c);
                if (x > matcher.To) {
                    matcher.HitEnd = true;
                    return false;
                }
            }
            return next.match(matcher, x, seq);
        }
    }

    /**
     * Node class for a case insensitive sequence of literal characters
     * including supplementary characters.
     */
    public class SliceIS : SliceNode 
    {
        public SliceIS(int[] buf) {
            base(buf);
        }
        public int toLower(int c) {
            return ASCII.ToLower(c);
        }
        public override bool match(Matcher matcher, int i, string seq) {
            int[] buf = buffer;
            int x = i;
            for (int j = 0; j < buf.length; j++) {
                if (x >= matcher.To) {
                    matcher.HitEnd = true;
                    return false;
                }
                int c = Character.CodePointAt(seq, x);
                if (buf[j] != c && buf[j] != toLower(c))
                    return false;
                x += Character.CharCount(c);
                if (x > matcher.To) {
                    matcher.HitEnd = true;
                    return false;
                }
            }
            return next.match(matcher, x, seq);
        }
    }

    /**
     * Node class for a case insensitive sequence of literal characters.
     * Uses unicode case folding.
     */
    public class SliceUS : SliceIS 
    {
        public SliceUS(int[] buf) {
            base(buf);
        }
        public int toLower(int c) {
            return Character.ToLowerCase(Character.ToUpperCase(c));
        }
    }

    private static bool inRange(int lower, int ch, int upper) {
        return lower <= ch && ch <= upper;
    }

    /**
     * Returns node for matching characters within an explicit value range.
     */
    private static CharProperty rangeFor(int lower,
                                         int upper) {
        return new CharProperty() {
            isSatisfiedBy = (ch)  => {
                    return inRange(lower, (int)ch, upper);}};
    }

    /**
     * Returns node for matching characters within an explicit value
     * range in a case insensitive manner.
     */
    private CharProperty caseInsensitiveRangeFor(int lower,
                                                 int upper) {
        if (has(UNICODE_CASE))
            return new CharProperty() {
                isSatisfiedBy = (ch) => {
                    if (inRange(lower, (int)ch, upper))
                        return true;
                    int up = Character.ToUpperCase((int)ch);
                    return inRange(lower, up, upper) ||
                           inRange(lower, Character.ToLowerCase(up), upper);}};
        return new CharProperty() {
            isSatisfiedBy = (ch) => {
                return inRange(lower, (int)ch, upper) ||
                    ASCII.IsAscii((int)ch) &&
                        (inRange(lower, ASCII.ToUpper((int)ch), upper) ||
                         inRange(lower, ASCII.ToLower((int)ch), upper));
            }};
    }

    /**
     * Implements the Unicode category ALL and the dot metacharacter when
     * in dotall mode.
     */
    public class All : CharProperty 
    {
        public All() {
            isSatisfiedBy = (ch) => {
                return true;
            };
        }
    }

    /**
     * Node class for the dot metacharacter when dotall is not enabled.
     */
    public class Dot : CharProperty 
    {
        public Dot() {
            isSatisfiedBy = (ch) => {
                return (ch != '\n' && ch != '\r'
                        && (ch|1) != 0x2029
                        && ch != 0x0085);
            };
        }
    }

    /**
     * Node class for the dot metacharacter when dotall is not enabled
     * but UNIX_LINES is enabled.
     */
    public class UnixDot : CharProperty 
    {
        public UnixDot() {
            isSatisfiedBy = (ch) => {
                return ch != '\n';
            };
        }
    }

    /**
     * The 0 or 1 quantifier. This one class implements all three types.
     */
    public class Ques : Node 
    {
        public Node atom;
        public int type;
        public Ques(Node node, int type) {
            this.atom = node;
            this.type = type;
        }
        public override bool match(Matcher matcher, int i, string seq) {
            switch (type) {
            case GREEDY:
                return (atom.match(matcher, i, seq) && next.match(matcher, matcher.Last, seq))
                    || next.match(matcher, i, seq);
            case LAZY:
                return next.match(matcher, i, seq)
                    || (atom.match(matcher, i, seq) && next.match(matcher, matcher.Last, seq));
            case POSSESSIVE:
                if (atom.match(matcher, i, seq)) i = matcher.Last;
                return next.match(matcher, i, seq);
            default:
                return atom.match(matcher, i, seq) && next.match(matcher, matcher.Last, seq);
            }
        }
        public override bool study(TreeInfo info) {
            if (type != INDEPENDENT) {
                int minL = info.minLength;
                atom.study(info);
                info.minLength = minL;
                info.deterministic = false;
                return next.study(info);
            } else {
                atom.study(info);
                return next.study(info);
            }
        }
    }

    /**
     * Handles the curly-brace style repetition with a specified minimum and
     * maximum occurrences. The * quantifier is handled as a special case.
     * This class handles the three types.
     */
    public class Curly : Node 
    {
        public Node atom;
        public int type;
        public int cmin;
        public int cmax;

        public Curly(Node node, int cmin, int cmax, int type) {
            this.atom = node;
            this.type = type;
            this.cmin = cmin;
            this.cmax = cmax;
        }
        public override bool match(Matcher matcher, int i, string seq) {
            int j;
            for (j = 0; j < cmin; j++) {
                if (atom.match(matcher, i, seq)) {
                    i = matcher.Last;
                    continue;
                }
                return false;
            }
            if (type == GREEDY)
                return match0(matcher, i, j, seq);
            else if (type == LAZY)
                return match1(matcher, i, j, seq);
            else
                return match2(matcher, i, j, seq);
        }
        // Greedy match.
        // i is the index to start matching at
        // j is the number of atoms that have matched
        public bool match0(Matcher matcher, int i, int j, string seq) {
            if (j >= cmax) {
                // We have matched the maximum... continue with the rest of
                // the regular expression
                return next.match(matcher, i, seq);
            }
            int backLimit = j;
            while (atom.match(matcher, i, seq)) {
                // k is the length of this match
                int k = matcher.Last - i;
                if (k == 0) // Zero length match
                    break;
                // Move up index and number matched
                i = matcher.Last;
                j++;
                // We are greedy so match as many as we can
                while (j < cmax) {
                    if (!atom.match(matcher, i, seq))
                        break;
                    if (i + k != matcher.Last) {
                        if (match0(matcher, matcher.Last, j+1, seq))
                            return true;
                        break;
                    }
                    i += k;
                    j++;
                }
                // Handle backing off if match fails
                while (j >= backLimit) {
                   if (next.match(matcher, i, seq))
                        return true;
                    i -= k;
                    j--;
                }
                return false;
            }
            return next.match(matcher, i, seq);
        }
        // Reluctant match. At this point, the minimum has been satisfied.
        // i is the index to start matching at
        // j is the number of atoms that have matched
        public bool match1(Matcher matcher, int i, int j, string seq) {
            for (;;) {
                // Try finishing match without consuming any more
                if (next.match(matcher, i, seq))
                    return true;
                // At the maximum, no match found
                if (j >= cmax)
                    return false;
                // Okay, must try one more atom
                if (!atom.match(matcher, i, seq))
                    return false;
                // If we haven't moved forward then must break out
                if (i == matcher.Last)
                    return false;
                // Move up index and number matched
                i = matcher.Last;
                j++;
            }
        }
        public bool match2(Matcher matcher, int i, int j, string seq) {
            for (; j < cmax; j++) {
                if (!atom.match(matcher, i, seq))
                    break;
                if (i == matcher.Last)
                    break;
                i = matcher.Last;
            }
            return next.match(matcher, i, seq);
        }
        public override bool study(TreeInfo info) {
            // Save original info
            int minL = info.minLength;
            int maxL = info.maxLength;
            bool maxV = info.maxValid;
            bool detm = info.deterministic;
            info.reset();

            atom.study(info);

            int temp = info.minLength * cmin + minL;
            if (temp < minL) {
                temp = 0xFFFFFFF; // arbitrary large number
            }
            info.minLength = temp;

            if (maxV & info.maxValid) {
                temp = info.maxLength * cmax + maxL;
                info.maxLength = temp;
                if (temp < maxL) {
                    info.maxValid = false;
                }
            } else {
                info.maxValid = false;
            }

            if (info.deterministic && cmin == cmax)
                info.deterministic = detm;
            else
                info.deterministic = false;
            return next.study(info);
        }
    }

    /**
     * Handles the curly-brace style repetition with a specified minimum and
     * maximum occurrences in deterministic cases. This is an iterative
     * optimization over the Prolog and Loop system which would handle this
     * in a recursive way. The * quantifier is handled as a special case.
     * If capture is true then this class saves group settings and ensures
     * that groups are unset when backing off of a group match.
     */
    public class GroupCurly : Node 
    {
        public Node atom;
        public int type;
        public int cmin;
        public int cmax;
        public int localIndex;
        public int groupIndex;
        public bool capture;

        public GroupCurly(Node node, int cmin, int cmax, int type, int local,
                   int group, bool capture) {
            this.atom = node;
            this.type = type;
            this.cmin = cmin;
            this.cmax = cmax;
            this.localIndex = local;
            this.groupIndex = group;
            this.capture = capture;
        }
        public override bool match(Matcher matcher, int i, string seq) {
            int[] groups = matcher.Groups;
            int[] locals = matcher.Locals;
            int save0 = locals[localIndex];
            int save1 = 0;
            int save2 = 0;

            if (capture) {
                save1 = groups[groupIndex];
                save2 = groups[groupIndex+1];
            }

            // Notify GroupTail there is no need to setup group info
            // because it will be set here
            locals[localIndex] = -1;

            bool ret = true;
            for (int j = 0; j < cmin; j++) {
                if (atom.match(matcher, i, seq)) {
                    if (capture) {
                        groups[groupIndex] = i;
                        groups[groupIndex+1] = matcher.Last;
                    }
                    i = matcher.Last;
                } else {
                    ret = false;
                    break;
                }
            }
            if (ret) {
                if (type == GREEDY) {
                    ret = match0(matcher, i, cmin, seq);
                } else if (type == LAZY) {
                    ret = match1(matcher, i, cmin, seq);
                } else {
                    ret = match2(matcher, i, cmin, seq);
                }
            }
            if (!ret) {
                locals[localIndex] = save0;
                if (capture) {
                    groups[groupIndex] = save1;
                    groups[groupIndex+1] = save2;
                }
            }
            return ret;
        }
        // Aggressive group match
        public bool match0(Matcher matcher, int i, int j, string seq) {
            // don't back off passing the starting "j"
            int min = j;
            int[] groups = matcher.Groups;
            int save0 = 0;
            int save1 = 0;
            if (capture) {
                save0 = groups[groupIndex];
                save1 = groups[groupIndex+1];
            }
            for (;;) {
                if (j >= cmax)
                    break;
                if (!atom.match(matcher, i, seq))
                    break;
                int k = matcher.Last - i;
                if (k <= 0) {
                    if (capture) {
                        groups[groupIndex] = i;
                        groups[groupIndex+1] = i + k;
                    }
                    i = i + k;
                    break;
                }
                for (;;) {
                    if (capture) {
                        groups[groupIndex] = i;
                        groups[groupIndex+1] = i + k;
                    }
                    i = i + k;
                    if (++j >= cmax)
                        break;
                    if (!atom.match(matcher, i, seq))
                        break;
                    if (i + k != matcher.Last) {
                        if (match0(matcher, i, j, seq))
                            return true;
                        break;
                    }
                }
                while (j > min) {
                    if (next.match(matcher, i, seq)) {
                        if (capture) {
                            groups[groupIndex+1] = i;
                            groups[groupIndex] = i - k;
                        }
                        return true;
                    }
                    // backing off
                    i = i - k;
                    if (capture) {
                        groups[groupIndex+1] = i;
                        groups[groupIndex] = i - k;
                    }
                    j--;

                }
                break;
            }
            if (capture) {
                groups[groupIndex] = save0;
                groups[groupIndex+1] = save1;
            }
            return next.match(matcher, i, seq);
        }
        // Reluctant matching
        public bool match1(Matcher matcher, int i, int j, string seq) {
            for (;;) {
                if (next.match(matcher, i, seq))
                    return true;
                if (j >= cmax)
                    return false;
                if (!atom.match(matcher, i, seq))
                    return false;
                if (i == matcher.Last)
                    return false;
                if (capture) {
                    matcher.Groups[groupIndex] = i;
                    matcher.Groups[groupIndex+1] = matcher.Last;
                }
                i = matcher.Last;
                j++;
            }
        }
        // Possessive matching
        public bool match2(Matcher matcher, int i, int j, string seq) {
            for (; j < cmax; j++) {
                if (!atom.match(matcher, i, seq)) {
                    break;
                }
                if (capture) {
                    matcher.Groups[groupIndex] = i;
                    matcher.Groups[groupIndex+1] = matcher.Last;
                }
                if (i == matcher.Last) {
                    break;
                }
                i = matcher.Last;
            }
            return next.match(matcher, i, seq);
        }
        public override bool study(TreeInfo info) {
            // Save original info
            int minL = info.minLength;
            int maxL = info.maxLength;
            bool maxV = info.maxValid;
            bool detm = info.deterministic;
            info.reset();

            atom.study(info);

            int temp = info.minLength * cmin + minL;
            if (temp < minL) {
                temp = 0xFFFFFFF; // Arbitrary large number
            }
            info.minLength = temp;

            if (maxV & info.maxValid) {
                temp = info.maxLength * cmax + maxL;
                info.maxLength = temp;
                if (temp < maxL) {
                    info.maxValid = false;
                }
            } else {
                info.maxValid = false;
            }

            if (info.deterministic && cmin == cmax) {
                info.deterministic = detm;
            } else {
                info.deterministic = false;
            }
            return next.study(info);
        }
    }

    /**
     * A Guard node at the end of each atom node in a Branch. It
     * serves the purpose of chaining the "match" operation to
     * "next" but not the "study", so we can collect the TreeInfo
     * of each atom node without including the TreeInfo of the
     * "next".
     */
    public class BranchConn : Node 
    {
        public BranchConn() {  }
        public override bool match(Matcher matcher, int i, string seq) {
            return next.match(matcher, i, seq);
        }
        public override bool study(TreeInfo info) {
            return info.deterministic;
        }
    }

    /**
     * Handles the branching of alternations. Note this is also used for
     * the ? quantifier to branch between the case where it matches once
     * and where it does not occur.
     */
    public class Branch : Node 
    {
        public Node[] atoms = new Node[2];
        public int size = 2;
        public Node conn;
        public Branch(Node first, Node second, Node branchConn) {
            conn = branchConn;
            atoms[0] = first;
            atoms[1] = second;
        }

        public void add(Node node) {
            if (size >= atoms.length) {
                Node[] tmp = new Node[atoms.length*2];
                System.arraycopy<int>(atoms, 0, tmp, 0, atoms.length);
                atoms = tmp;
            }
            atoms[size++] = node;
        }

        public override bool match(Matcher matcher, int i, string seq) {
            for (int n = 0; n < size; n++) {
                if (atoms[n] == null) {
                    if (conn.next.match(matcher, i, seq))
                        return true;
                } else if (atoms[n].match(matcher, i, seq)) {
                    return true;
                }
            }
            return false;
        }

        public override bool study(TreeInfo info) {
            int minL = info.minLength;
            int maxL = info.maxLength;
            bool maxV = info.maxValid;

            int minL2 = Integer.MAX_VALUE; //arbitrary large enough num
            int maxL2 = -1;
            for (int n = 0; n < size; n++) {
                info.reset();
                if (atoms[n] != null)
                    atoms[n].study(info);
                minL2 = int.min(minL2, info.minLength);
                maxL2 = int.max(maxL2, info.maxLength);
                maxV = (maxV & info.maxValid);
            }

            minL += minL2;
            maxL += maxL2;

            info.reset();
            conn.next.study(info);

            info.minLength += minL;
            info.maxLength += maxL;
            info.maxValid &= maxV;
            info.deterministic = false;
            return false;
        }
    }

    /**
     * The GroupHead saves the location where the group begins in the locals
     * and restores them when the match is done.
     *
     * The matchRef is used when a reference to this group is accessed later
     * in the expression. The locals will have a negative value in them to
     * indicate that we do not want to unset the group if the reference
     * doesn't match.
     */
    public class GroupHead : Node 
    {
        public int localIndex;
        public GroupHead(int localCount) {
            localIndex = localCount;
        }
        public override bool match(Matcher matcher, int i, string seq) {
            int save = matcher.Locals[localIndex];
            matcher.Locals[localIndex] = i;
            bool ret = next.match(matcher, i, seq);
            matcher.Locals[localIndex] = save;
            return ret;
        }
        public bool matchRef(Matcher matcher, int i, string seq) {
            int save = matcher.Locals[localIndex];
            matcher.Locals[localIndex] = ~i; // HACK
            bool ret = next.match(matcher, i, seq);
            matcher.Locals[localIndex] = save;
            return ret;
        }
    }

    /**
     * Recursive reference to a group in the regular expression. It calls
     * matchRef because if the reference fails to match we would not unset
     * the group.
     */
    public class GroupRef : Node 
    {
        public GroupHead head;
        public GroupRef(GroupHead head) {
            this.head = head;
        }
        public override bool match(Matcher matcher, int i, string seq) {
            return head.matchRef(matcher, i, seq)
                && next.match(matcher, matcher.Last, seq);
        }
        public override bool study(TreeInfo info) {
            info.maxValid = false;
            info.deterministic = false;
            return next.study(info);
        }
    }

    /**
     * The GroupTail handles the setting of group beginning and ending
     * locations when groups are successfully matched. It must also be able to
     * unset groups that have to be backed off of.
     *
     * The GroupTail node is also used when a previous group is referenced,
     * and in that case no group information needs to be set.
     */
    public class GroupTail : Node 
    {
        public int localIndex;
        public int groupIndex;
        public GroupTail(int localCount, int groupCount) {
            localIndex = localCount;
            groupIndex = groupCount + groupCount;
        }
        public override bool match(Matcher matcher, int i, string seq) {
            int tmp = matcher.Locals[localIndex];
            if (tmp >= 0) { // This is the normal group case.
                // Save the group so we can unset it if it
                // backs off of a match.
                int groupStart = matcher.Groups[groupIndex];
                int groupEnd = matcher.Groups[groupIndex+1];

                matcher.Groups[groupIndex] = tmp;
                matcher.Groups[groupIndex+1] = i;
                if (next.match(matcher, i, seq)) {
                    return true;
                }
                matcher.Groups[groupIndex] = groupStart;
                matcher.Groups[groupIndex+1] = groupEnd;
                return false;
            } else {
                // This is a group reference case. We don't need to save any
                // group info because it isn't really a group.
                matcher.Last = i;
                return true;
            }
        }
    }

    /**
     * This sets up a loop to handle a recursive quantifier structure.
     */
    public class Prolog : Node 
    {
        public Loop loop;
        public Prolog(Loop loop) {
            this.loop = loop;
        }
        public override bool match(Matcher matcher, int i, string seq) {
            return loop.matchInit(matcher, i, seq);
        }
        public override bool study(TreeInfo info) {
            return loop.study(info);
        }
    }

    /**
     * Handles the repetition count for a greedy Curly. The matchInit
     * is called from the Prolog to save the index of where the group
     * beginning is stored. A zero length group check occurs in the
     * normal match but is skipped in the matchInit.
     */
    public class Loop : Node 
    {
        public Node body;
        public int countIndex; // local count index in matcher locals
        public int beginIndex; // group beginning index
        public int cmin;
        public int cmax;
        public Loop(int countIndex, int beginIndex) {
            this.countIndex = countIndex;
            this.beginIndex = beginIndex;
        }
        public override bool match(Matcher matcher, int i, string seq) {
            // Avoid infinite loop in zero-length case.
            if (i > matcher.Locals[beginIndex]) {
                int count = matcher.Locals[countIndex];

                // This block is for before we reach the minimum
                // iterations required for the loop to match
                if (count < cmin) {
                    matcher.Locals[countIndex] = count + 1;
                    bool b = body.match(matcher, i, seq);
                    // If match failed we must backtrack, so
                    // the loop count should NOT be incremented
                    if (!b)
                        matcher.Locals[countIndex] = count;
                    // Return success or failure since we are under
                    // minimum
                    return b;
                }
                // This block is for after we have the minimum
                // iterations required for the loop to match
                if (count < cmax) {
                    matcher.Locals[countIndex] = count + 1;
                    bool b = body.match(matcher, i, seq);
                    // If match failed we must backtrack, so
                    // the loop count should NOT be incremented
                    if (!b)
                        matcher.Locals[countIndex] = count;
                    else
                        return true;
                }
            }
            return next.match(matcher, i, seq);
        }
        public bool matchInit(Matcher matcher, int i, string seq) {
            int save = matcher.Locals[countIndex];
            bool ret = false;
            if (0 < cmin) {
                matcher.Locals[countIndex] = 1;
                ret = body.match(matcher, i, seq);
            } else if (0 < cmax) {
                matcher.Locals[countIndex] = 1;
                ret = body.match(matcher, i, seq);
                if (ret == false)
                    ret = next.match(matcher, i, seq);
            } else {
                ret = next.match(matcher, i, seq);
            }
            matcher.Locals[countIndex] = save;
            return ret;
        }
        public override bool study(TreeInfo info) {
            info.maxValid = false;
            info.deterministic = false;
            return false;
        }
    }

    /**
     * Handles the repetition count for a reluctant Curly. The matchInit
     * is called from the Prolog to save the index of where the group
     * beginning is stored. A zero length group check occurs in the
     * normal match but is skipped in the matchInit.
     */
    public class LazyLoop : Loop 
    {
        public LazyLoop(int countIndex, int beginIndex) {
            base(countIndex, beginIndex);
        }
        public override bool match(Matcher matcher, int i, string seq) {
            // Check for zero length group
            if (i > matcher.Locals[beginIndex]) {
                int count = matcher.Locals[countIndex];
                if (count < cmin) {
                    matcher.Locals[countIndex] = count + 1;
                    bool result = body.match(matcher, i, seq);
                    // If match failed we must backtrack, so
                    // the loop count should NOT be incremented
                    if (!result)
                        matcher.Locals[countIndex] = count;
                    return result;
                }
                if (next.match(matcher, i, seq))
                    return true;
                if (count < cmax) {
                    matcher.Locals[countIndex] = count + 1;
                    bool result = body.match(matcher, i, seq);
                    // If match failed we must backtrack, so
                    // the loop count should NOT be incremented
                    if (!result)
                        matcher.Locals[countIndex] = count;
                    return result;
                }
                return false;
            }
            return next.match(matcher, i, seq);
        }
        public bool matchInit(Matcher matcher, int i, string seq) {
            int save = matcher.Locals[countIndex];
            bool ret = false;
            if (0 < cmin) {
                matcher.Locals[countIndex] = 1;
                ret = body.match(matcher, i, seq);
            } else if (next.match(matcher, i, seq)) {
                ret = true;
            } else if (0 < cmax) {
                matcher.Locals[countIndex] = 1;
                ret = body.match(matcher, i, seq);
            }
            matcher.Locals[countIndex] = save;
            return ret;
        }
        public override bool study(TreeInfo info) {
            info.maxValid = false;
            info.deterministic = false;
            return false;
        }
    }

    /**
     * Refers to a group in the regular expression. Attempts to match
     * whatever the group referred to last matched.
     */
    public class BackRef : Node 
    {
        public int groupIndex;
        public BackRef(int groupCount) {
            groupIndex = groupCount + groupCount;
        }
        public override bool match(Matcher matcher, int i, string seq) {
            int j = matcher.Groups[groupIndex];
            int k = matcher.Groups[groupIndex+1];

            int groupSize = k - j;
            // If the referenced group didn't match, neither can this
            if (j < 0)
                return false;

            // If there isn't enough input left no match
            if (i + groupSize > matcher.To) {
                matcher.HitEnd = true;
                return false;
            }
            // Check each new char to make sure it matches what the group
            // referenced matched last time around
            for (int index=0; index<groupSize; index++)
                if (seq.get_char(i+index) != seq.get_char(j+index))
                    return false;

            return next.match(matcher, i+groupSize, seq);
        }
        public override bool study(TreeInfo info) {
            info.maxValid = false;
            return next.study(info);
        }
    }

    public class CIBackRef : Node 
    {
        public int groupIndex;
        public bool doUnicodeCase;
        public CIBackRef(int groupCount, bool doUnicodeCase) {
            groupIndex = groupCount + groupCount;
            this.doUnicodeCase = doUnicodeCase;
        }
        public override bool match(Matcher matcher, int i, string seq) {
            int j = matcher.Groups[groupIndex];
            int k = matcher.Groups[groupIndex+1];

            int groupSize = k - j;

            // If the referenced group didn't match, neither can this
            if (j < 0)
                return false;

            // If there isn't enough input left no match
            if (i + groupSize > matcher.To) {
                matcher.HitEnd = true;
                return false;
            }

            // Check each new char to make sure it matches what the group
            // referenced matched last time around
            int x = i;
            for (int index=0; index<groupSize; index++) {
                int c1 = Character.CodePointAt(seq, x);
                int c2 = Character.CodePointAt(seq, j);
                if (c1 != c2) {
                    if (doUnicodeCase) {
                        int cc1 = Character.ToUpperCase(c1);
                        int cc2 = Character.ToUpperCase(c2);
                        if (cc1 != cc2 &&
                            Character.ToLowerCase(cc1) !=
                            Character.ToLowerCase(cc2))
                            return false;
                    } else {
                        if (ASCII.ToLower(c1) != ASCII.ToLower(c2))
                            return false;
                    }
                }
                x += Character.CharCount(c1);
                j += Character.CharCount(c2);
            }

            return next.match(matcher, i+groupSize, seq);
        }
        public override bool study(TreeInfo info) {
            info.maxValid = false;
            return next.study(info);
        }
    }

    /**
     * Searches until the next instance of its atom. This is useful for
     * finding the atom efficiently without passing an instance of it
     * (greedy problem) and without a lot of wasted search time (reluctant
     * problem).
     */
    public class First : Node 
    {
        public Node atom;
        public First(Node node) {
            this.atom = BnM.optimize(node);
        }
        public override bool match(Matcher matcher, int i, string seq) {
            if (atom is BnM) {
                return atom.match(matcher, i, seq)
                    && next.match(matcher, matcher.Last, seq);
            }
            for (;;) {
                if (i > matcher.To) {
                    matcher.HitEnd = true;
                    return false;
                }
                if (atom.match(matcher, i, seq)) {
                    return next.match(matcher, matcher.Last, seq);
                }
                i += countChars(seq, i, 1);
                matcher.First++;
            }
        }
        public override bool study(TreeInfo info) {
            atom.study(info);
            info.maxValid = false;
            info.deterministic = false;
            return next.study(info);
        }
    }

    public class Conditional : Node 
    {
        public Node cond;
        public Node yes;
        public Node not;
        public Conditional(Node cond, Node yes, Node not) {
            this.cond = cond;
            this.yes = yes;
            this.not = not;
        }
        public override bool match(Matcher matcher, int i, string seq) {
            if (cond.match(matcher, i, seq)) {
                return yes.match(matcher, i, seq);
            } else {
                return not.match(matcher, i, seq);
            }
        }
        public override bool study(TreeInfo info) {
            int minL = info.minLength;
            int maxL = info.maxLength;
            bool maxV = info.maxValid;
            info.reset();
            yes.study(info);

            int minL2 = info.minLength;
            int maxL2 = info.maxLength;
            bool maxV2 = info.maxValid;
            info.reset();
            not.study(info);

            info.minLength = minL + int.min(minL2, info.minLength);
            info.maxLength = maxL + int.max(maxL2, info.maxLength);
            info.maxValid = (maxV & maxV2 & info.maxValid);
            info.deterministic = false;
            return next.study(info);
        }
    }

    /**
     * Zero width positive lookahead.
     */
    public class Pos : Node 
    {
        public Node cond;
        public Pos(Node cond) {
            this.cond = cond;
        }
        public override bool match(Matcher matcher, int i, string seq) {
            int savedTo = matcher.To;
            bool conditionMatched = false;

            // Relax transparent region boundaries for lookahead
            if (matcher.TransparentBounds)
                matcher.To = matcher.GetTextLength();
            try {
                conditionMatched = cond.match(matcher, i, seq);
            } finally {
                // Reinstate region boundaries
                matcher.To = savedTo;
            }
            return conditionMatched && next.match(matcher, i, seq);
        }
    }

    /**
     * Zero width negative lookahead.
     */
    public class Neg : Node 
    {
        public Node cond;
        public Neg(Node cond) {
            this.cond = cond;
        }
        public override bool match(Matcher matcher, int i, string seq) {
            int savedTo = matcher.To;
            bool conditionMatched = false;

            // Relax transparent region boundaries for lookahead
            if (matcher.TransparentBounds)
                matcher.To = matcher.GetTextLength();
            try {
                if (i < matcher.To) {
                    conditionMatched = !cond.match(matcher, i, seq);
                } else {
                    // If a negative lookahead succeeds then more input
                    // could cause it to fail!
                    matcher.RequireEnd = true;
                    conditionMatched = !cond.match(matcher, i, seq);
                }
            } finally {
                // Reinstate region boundaries
                matcher.To = savedTo;
            }
            return conditionMatched && next.match(matcher, i, seq);
        }
    }

    /**
     * For use with lookbehinds; matches the position where the lookbehind
     * was encountered.
     */
    public class LookBehindEnd : Node
    {
        public override bool match(Matcher matcher, int i, string seq) {
            return i == matcher.LookbehindTo;
        }

    }
    static LookBehindEnd lookbehindEnd = new LookBehindEnd();

    /**
     * Zero width positive lookbehind.
     */
    public class Behind : Node 
    {
        public Node cond;
        public int rmax;
        public int rmin;
        public Behind(Node cond, int rmax, int rmin) {
            this.cond = cond;
            this.rmax = rmax;
            this.rmin = rmin;
        }

        public override bool match(Matcher matcher, int i, string seq) {
            int savedFrom = matcher.From;
            bool conditionMatched = false;
            int startIndex = (!matcher.TransparentBounds) ?
                             matcher.From : 0;
            int from = int.max(i - rmax, startIndex);
            // Set end boundary
            int savedLBT = matcher.LookbehindTo;
            matcher.LookbehindTo = i;
            // Relax transparent region boundaries for lookbehind
            if (matcher.TransparentBounds)
                matcher.From = 0;
            for (int j = i - rmin; !conditionMatched && j >= from; j--) {
                conditionMatched = cond.match(matcher, j, seq);
            }
            matcher.From = savedFrom;
            matcher.LookbehindTo = savedLBT;
            return conditionMatched && next.match(matcher, i, seq);
        }
    }

    /**
     * Zero width positive lookbehind, including supplementary
     * characters or unpaired surrogates.
     */
    public class BehindS : Behind 
    {
        public BehindS(Node cond, int rmax, int rmin) {
            base(cond, rmax, rmin);
        }
        public override bool match(Matcher matcher, int i, string seq) {
            int rmaxChars = countChars(seq, i, -rmax);
            int rminChars = countChars(seq, i, -rmin);
            int savedFrom = matcher.From;
            int startIndex = (!matcher.TransparentBounds) ?
                             matcher.From : 0;
            bool conditionMatched = false;
            int from = int.max(i - rmaxChars, startIndex);
            // Set end boundary
            int savedLBT = matcher.LookbehindTo;
            matcher.LookbehindTo = i;
            // Relax transparent region boundaries for lookbehind
            if (matcher.TransparentBounds)
                matcher.From = 0;

            for (int j = i - rminChars;
                 !conditionMatched && j >= from;
                 j -= j>from ? countChars(seq, j, -1) : 1) {
                conditionMatched = cond.match(matcher, j, seq);
            }
            matcher.From = savedFrom;
            matcher.LookbehindTo = savedLBT;
            return conditionMatched && next.match(matcher, i, seq);
        }
    }

    /**
     * Zero width negative lookbehind.
     */
    public class NotBehind : Node 
    {
        public Node cond;
        public int rmax;
        public int rmin;
        public NotBehind(Node cond, int rmax, int rmin) {
            this.cond = cond;
            this.rmax = rmax;
            this.rmin = rmin;
        }

        public override bool match(Matcher matcher, int i, string seq) {
            int savedLBT = matcher.LookbehindTo;
            int savedFrom = matcher.From;
            bool conditionMatched = false;
            int startIndex = (!matcher.TransparentBounds) ?
                             matcher.From : 0;
            int from = int.max(i - rmax, startIndex);
            matcher.LookbehindTo = i;
            // Relax transparent region boundaries for lookbehind
            if (matcher.TransparentBounds)
                matcher.From = 0;
            for (int j = i - rmin; !conditionMatched && j >= from; j--) {
                conditionMatched = cond.match(matcher, j, seq);
            }
            // Reinstate region boundaries
            matcher.From = savedFrom;
            matcher.LookbehindTo = savedLBT;
            return !conditionMatched && next.match(matcher, i, seq);
        }
    }

    /**
     * Zero width negative lookbehind, including supplementary
     * characters or unpaired surrogates.
     */
    public class NotBehindS : NotBehind 
    {
        public NotBehindS(Node cond, int rmax, int rmin) {
            base(cond, rmax, rmin);
        }
        public override bool match(Matcher matcher, int i, string seq) {
            int rmaxChars = countChars(seq, i, -rmax);
            int rminChars = countChars(seq, i, -rmin);
            int savedFrom = matcher.From;
            int savedLBT = matcher.LookbehindTo;
            bool conditionMatched = false;
            int startIndex = (!matcher.TransparentBounds) ?
                             matcher.From : 0;
            int from = int.max(i - rmaxChars, startIndex);
            matcher.LookbehindTo = i;
            // Relax transparent region boundaries for lookbehind
            if (matcher.TransparentBounds)
                matcher.From = 0;
            for (int j = i - rminChars;
                 !conditionMatched && j >= from;
                 j -= j>from ? countChars(seq, j, -1) : 1) {
                conditionMatched = cond.match(matcher, j, seq);
            }
            //Reinstate region boundaries
            matcher.From = savedFrom;
            matcher.LookbehindTo = savedLBT;
            return !conditionMatched && next.match(matcher, i, seq);
        }
    }

    /**
     * Returns the set union of two CharProperty nodes.
     */
    private static CharProperty union(CharProperty lhs,
                                      CharProperty rhs) {
        return new CharProperty() {
                isSatisfiedBy = (ch) => {
                    return lhs.isSatisfiedBy(ch) || rhs.isSatisfiedBy(ch);}};
    }

    /**
     * Returns the set intersection of two CharProperty nodes.
     */
    private static CharProperty intersection(CharProperty lhs,
                                             CharProperty rhs) {
        return new CharProperty() {
                isSatisfiedBy = (ch) => {
                    return lhs.isSatisfiedBy(ch) && rhs.isSatisfiedBy(ch);}};
    }

    /**
     * Returns the set difference of two CharProperty nodes.
     */
    private static CharProperty setDifference(CharProperty lhs,
                                              CharProperty rhs) {
        return new CharProperty() {
                isSatisfiedBy = (ch) => {
                    return ! rhs.isSatisfiedBy(ch) && lhs.isSatisfiedBy(ch);}};
    }

    /**
     * Handles word boundaries. Includes a field to allow this one class to
     * deal with the different types of word boundaries we can match. The word
     * characters include underscores, letters, and digits. Non spacing marks
     * can are also part of a word if they have a base character, otherwise
     * they are ignored for purposes of finding word boundaries.
     */
    public class Bound : Node 
    {
        public static int LEFT = 0x1;
        public static int RIGHT= 0x2;
        public static int BOTH = 0x3;
        public static int NONE = 0x4;
        public int type;
        public bool useUWORD;
        public Bound(int n, bool useUWORD) {
            type = n;
            this.useUWORD = useUWORD;
        }

        public bool isWord(int ch) {
            return useUWORD ? UnicodeProp.WORD.Is(ch)
                            : (ch == '_' || Character.IsLetterOrDigit(ch));
        }

        public int check(Matcher matcher, int i, string seq) {
            int ch;
            bool left = false;
            int startIndex = matcher.From;
            int endIndex = matcher.To;
            if (matcher.TransparentBounds) {
                startIndex = 0;
                endIndex = matcher.GetTextLength();
            }
            if (i > startIndex) {
                ch = Character.CodePointBefore(seq, i);
                left = (isWord(ch) ||
                    ((Character.GetType(ch) == UnicodeType.NON_SPACING_MARK)
                     && hasBaseCharacter(matcher, i-1, seq)));
            }
            bool right = false;
            if (i < endIndex) {
                ch = Character.CodePointAt(seq, i);
                right = (isWord(ch) ||
                    ((Character.GetType(ch) == UnicodeType.NON_SPACING_MARK)
                     && hasBaseCharacter(matcher, i, seq)));
            } else {
                // Tried to access char past the end
                matcher.HitEnd = true;
                // The addition of another char could wreck a boundary
                matcher.RequireEnd = true;
            }
            return ((left ^ right) ? (right ? LEFT : RIGHT) : NONE);
        }
        public override bool match(Matcher matcher, int i, string seq) {
            return (check(matcher, i, seq) & type) > 0
                && next.match(matcher, i, seq);
        }
    }

    /**
     * Non spacing marks only count as word characters in bounds calculations
     * if they have a base character.
     */
    private static bool hasBaseCharacter(Matcher matcher, int i,
                                            string seq)
    {
        int start = (!matcher.TransparentBounds) ?
            matcher.From : 0;
        for (int x=i; x >= start; x--) {
            int ch = Character.CodePointAt(seq, x);
            if (Character.IsLetterOrDigit(ch))
                return true;
            if (Character.GetType(ch) == UnicodeType.NON_SPACING_MARK)
                continue;
            return false;
        }
        return false;
    }

    /**
     * Attempts to match a slice in the input using the Boyer-Moore string
     * matching algorithm. The algorithm is based on the idea that the
     * pattern can be shifted farther ahead in the search text if it is
     * matched right to left.
     * <p>
     * The pattern is compared to the input one character at a time, from
     * the rightmost character in the pattern to the left. If the characters
     * all match the pattern has been found. If a character does not match,
     * the pattern is shifted right a distance that is the maximum of two
     * functions, the bad character shift and the good suffix shift. This
     * shift moves the attempted match position through the input more
     * quickly than a naive one position at a time check.
     * <p>
     * The bad character shift is based on the character from the text that
     * did not match. If the character does not appear in the pattern, the
     * pattern can be shifted completely beyond the bad character. If the
     * character does occur in the pattern, the pattern can be shifted to
     * line the pattern up with the next occurrence of that character.
     * <p>
     * The good suffix shift is based on the idea that some subset on the right
     * side of the pattern has matched. When a bad character is found, the
     * pattern can be shifted right by the pattern length if the subset does
     * not occur again in pattern, or by the amount of distance to the
     * next occurrence of the subset in the pattern.
     *
     * Boyer-Moore search methods adapted from code by Amy Yu.
     */
    public class BnM : Node 
    {
        public int[] buffer;
        public int[] lastOcc;
        public int[] optoSft;

        /**
         * Pre calculates arrays needed to generate the bad character
         * shift and the good suffix shift. Only the last seven bits
         * are used to see if chars match; This keeps the tables small
         * and covers the heavily used ASCII range, but occasionally
         * results in an aliased match for the bad character shift.
         */
        public static Node optimize(Node node) {
            if (!(node is Slice)) {
                return node;
            }

            int[] src = ((Slice) node).buffer;
            int patternLength = src.length;
            // The BM algorithm requires a bit of overhead;
            // If the pattern is short don't use it, since
            // a shift larger than the pattern length cannot
            // be used anyway.
            if (patternLength < 4) {
                return node;
            }
            int i, j, k;
            int[] lastOcc = new int[128];
            int[] optoSft = new int[patternLength];
            bool skip = false;
            // Precalculate part of the bad character shift
            // It is a table for where in the pattern each
            // lower 7-bit value occurs
            for (i = 0; i < patternLength; i++) {
                lastOcc[src[i]&0x7F] = i + 1;
            }
            // Precalculate the good suffix shift
            // i is the shift amount being considered
/* NEXT: */ for (i = patternLength; i > 0; i--) {
                // j is the beginning index of suffix being considered
                for (j = patternLength - 1; j >= i; j--) {
                    // Testing for good suffix
                    if (src[j] == src[j-i]) {
                        // src[j..len] is a good suffix
                        optoSft[j-1] = i;
                    } else {
                        // No match. The array has already been
                        // filled up with correct values before.
                        skip = true;
                        break;
                        // continue NEXT;
                    }
                }
                // This fills up the remaining of optoSft
                // any suffix can not have larger shift amount
                // then its sub-suffix. Why???
                if (skip) continue;
                while (j > 0) {
                    optoSft[--j] = i;
                }
            }
            // Set the guard value because of unicode compression
            optoSft[patternLength-1] = 1;
            if (node is SliceS)
                return new BnMS(src, lastOcc, optoSft, node.next);
            return new BnM(src, lastOcc, optoSft, node.next);
        }
        public BnM(int[] src, int[] lastOcc, int[] optoSft, Node next) {
            this.buffer = src;
            this.lastOcc = lastOcc;
            this.optoSft = optoSft;
            this.next = next;
        }
        public override bool match(Matcher matcher, int i, string seq) {
            int[] src = buffer;
            int patternLength = src.length;
            int last = matcher.To - patternLength;

            // Loop over all possible match positions in text
/* NEXT: */ while (i <= last) {
                var skip = false;
                // Loop over pattern from right to left
                for (int j = patternLength - 1; j >= 0; j--) {
                    int ch = (int)seq.get_char(i+j);
                    if (ch != src[j]) {
                        // Shift search to the right by the maximum of the
                        // bad character shift and the good suffix shift
                        i += int.max(j + 1 - lastOcc[ch&0x7F], optoSft[j]);
                        // continue NEXT;
                        skip = true;
                        break;
                    }
                }
                if (skip) continue;
                // Entire pattern matched starting at i
                matcher.First = i;
                bool ret = next.match(matcher, i + patternLength, seq);
                if (ret) {
                    matcher.First = i;
                    matcher.Groups[0] = matcher.First;
                    matcher.Groups[1] = matcher.Last;
                    return true;
                }
                i++;
            }
            // BnM is only used as the leading node in the unanchored case,
            // and it replaced its Start() which always searches to the end
            // if it doesn't find what it's looking for, so hitEnd is true.
            matcher.HitEnd = true;
            return false;
        }
        public override bool study(TreeInfo info) {
            info.minLength += buffer.length;
            info.maxValid = false;
            return next.study(info);
        }
    }

    /**
     * Supplementary support version of BnM(). Unpaired surrogates are
     * also handled by this class.
     */
    public class BnMS : BnM 
    {
        public int lengthInChars;

        public BnMS(int[] src, int[] lastOcc, int[] optoSft, Node next) {
            base(src, lastOcc, optoSft, next);
            for (int x = 0; x < buffer.length; x++) {
                lengthInChars += Character.CharCount(buffer[x]);
            }
        }
        public override bool match(Matcher matcher, int i, string seq) {
            int[] src = buffer;
            int patternLength = src.length;
            int last = matcher.To - lengthInChars;
            var skip = false;

            // Loop over all possible match positions in text
/* NEXT: */ while (i <= last) {
                // Loop over pattern from right to left
                int ch = 0;
                for (int j = countChars(seq, i, patternLength), x = patternLength - 1;
                     j > 0; j -= Character.CharCount(ch), x--) {
                    ch = Character.CodePointBefore(seq, i+j);
                    if (ch != src[x]) {
                        // Shift search to the right by the maximum of the
                        // bad character shift and the good suffix shift
                        int n = int.max(x + 1 - lastOcc[ch&0x7F], optoSft[x]);
                        i += countChars(seq, i, n);
                        // continue NEXT;
                        skip = true;
                        break;
                    }
                }
                if (skip) continue;
                // Entire pattern matched starting at i
                matcher.First = i;
                bool ret = next.match(matcher, i + lengthInChars, seq);
                if (ret) {
                    matcher.First = i;
                    matcher.Groups[0] = matcher.First;
                    matcher.Groups[1] = matcher.Last;
                    return true;
                }
                i += countChars(seq, i, 1);
            }
            matcher.HitEnd = true;
            return false;
        }
    }

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

    public static void Initialize() {
        CharPropertyNames.Initialize();
    }
    /**
     *  This must be the very first initializer.
     */
    public static Node Accept = new Node();

    public static Node LastAccept = new LastNode();

    public delegate CharProperty AbstractCharPropertyMake();

    public class CharPropertyNames : Object 
    {

        public static CharProperty charPropertyFor(string name) {
            CharPropertyFactory m = map.get(name);
            return m == null ? null : m.make();

            // var r = m == null ? null : m.make();
            // println("CharProperty - %s", r.get_type().name());
            // if (r.isSatisfiedBy == null) println("isSatisfiedBy == null");
            // return r;
        }

        public class CharPropertyFactory : Object 
        {
            public AbstractCharPropertyMake? make = null;
            // abstract CharProperty make();
        }

        private static void defCategory(string name,
                                        int typeMask) {
            map.set(name, new CharPropertyFactory() {
                    make = () => { return new Category(typeMask);}});
        }

        private static void defRange(string name,
                                     int lower, int upper) {
            map.set(name, new CharPropertyFactory() {
                    make = () => { return rangeFor(lower, upper);}});
        }

        private static void defCtype(string name,
                                     int ctype) {
            map.set(name, new CharPropertyFactory() {
                    make = () => { return new Ctype(ctype);}});
        }

        public class CloneableProperty : CharProperty, ICloneable
        {
            public new CloneableProperty Clone()
                throws System.Exception
            {
                var clone = base.Clone() as CloneableProperty;
                /*
                 * Implemented as a delegate property, not a virtual method,
                 * so 'isSatisfiedBy' needs to be explicitely copied:
                 */
                clone.isSatisfiedBy = this.isSatisfiedBy;
                return clone;
            }
        }

        private static void defClone(string name,
                                     CloneableProperty p) {
            map.set(name, new CharPropertyFactory() {
                    make = () => { return p.Clone();}});
        }

        private static Dictionary<string, CharPropertyFactory> map;
            // = new Dictionary<string, CharPropertyFactory>();

        public static void Initialize() {
            map = new Dictionary<string, CharPropertyFactory>();

            // Unicode character property aliases, defined in
            // http://www.unicode.org/Public/UNIDATA/PropertyValueAliases.txt
            defCategory("Cn", 1<<UnicodeType.UNASSIGNED);
            defCategory("Lu", 1<<UnicodeType.UPPERCASE_LETTER);
            defCategory("Ll", 1<<UnicodeType.LOWERCASE_LETTER);
            defCategory("Lt", 1<<UnicodeType.TITLECASE_LETTER);
            defCategory("Lm", 1<<UnicodeType.MODIFIER_LETTER);
            defCategory("Lo", 1<<UnicodeType.OTHER_LETTER);
            defCategory("Mn", 1<<UnicodeType.NON_SPACING_MARK);
            defCategory("Me", 1<<UnicodeType.ENCLOSING_MARK);
            defCategory("Mc", 1<<UnicodeType.COMBINING_MARK);
            defCategory("Nd", 1<<UnicodeType.DECIMAL_NUMBER);
            defCategory("Nl", 1<<UnicodeType.LETTER_NUMBER);
            defCategory("No", 1<<UnicodeType.OTHER_NUMBER);
            defCategory("Zs", 1<<UnicodeType.SPACE_SEPARATOR);
            defCategory("Zl", 1<<UnicodeType.LINE_SEPARATOR);
            defCategory("Zp", 1<<UnicodeType.PARAGRAPH_SEPARATOR);
            defCategory("Cc", 1<<UnicodeType.CONTROL);
            defCategory("Cf", 1<<UnicodeType.FORMAT);
            defCategory("Co", 1<<UnicodeType.PRIVATE_USE);
            defCategory("Cs", 1<<UnicodeType.SURROGATE);
            defCategory("Pd", 1<<UnicodeType.DASH_PUNCTUATION);
            defCategory("Ps", 1<<UnicodeType.OPEN_PUNCTUATION);
            defCategory("Pe", 1<<UnicodeType.CLOSE_PUNCTUATION);
            defCategory("Pc", 1<<UnicodeType.CONNECT_PUNCTUATION);
            defCategory("Po", 1<<UnicodeType.OTHER_PUNCTUATION);
            defCategory("Sm", 1<<UnicodeType.MATH_SYMBOL);
            defCategory("Sc", 1<<UnicodeType.CURRENCY_SYMBOL);
            defCategory("Sk", 1<<UnicodeType.MODIFIER_SYMBOL);
            defCategory("So", 1<<UnicodeType.OTHER_SYMBOL);
            defCategory("Pi", 1<<UnicodeType.INITIAL_PUNCTUATION);
            defCategory("Pf", 1<<UnicodeType.FINAL_PUNCTUATION);
            defCategory("L", ((1<<UnicodeType.UPPERCASE_LETTER) |
                              (1<<UnicodeType.LOWERCASE_LETTER) |
                              (1<<UnicodeType.TITLECASE_LETTER) |
                              (1<<UnicodeType.MODIFIER_LETTER)  |
                              (1<<UnicodeType.OTHER_LETTER)));
            defCategory("M", ((1<<UnicodeType.NON_SPACING_MARK) |
                              (1<<UnicodeType.ENCLOSING_MARK)   |
                              (1<<UnicodeType.COMBINING_MARK)));
            defCategory("N", ((1<<UnicodeType.DECIMAL_NUMBER) |
                              (1<<UnicodeType.LETTER_NUMBER)        |
                              (1<<UnicodeType.OTHER_NUMBER)));
            defCategory("Z", ((1<<UnicodeType.SPACE_SEPARATOR) |
                              (1<<UnicodeType.LINE_SEPARATOR)  |
                              (1<<UnicodeType.PARAGRAPH_SEPARATOR)));
            defCategory("C", ((1<<UnicodeType.CONTROL)     |
                              (1<<UnicodeType.FORMAT)      |
                              (1<<UnicodeType.PRIVATE_USE) |
                              (1<<UnicodeType.SURROGATE))); // Other
            defCategory("P", ((1<<UnicodeType.DASH_PUNCTUATION)      |
                              (1<<UnicodeType.OPEN_PUNCTUATION)     |
                              (1<<UnicodeType.CLOSE_PUNCTUATION)       |
                              (1<<UnicodeType.CONNECT_PUNCTUATION) |
                              (1<<UnicodeType.OTHER_PUNCTUATION)     |
                              (1<<UnicodeType.INITIAL_PUNCTUATION) |
                              (1<<UnicodeType.FINAL_PUNCTUATION)));
            defCategory("S", ((1<<UnicodeType.MATH_SYMBOL)     |
                              (1<<UnicodeType.CURRENCY_SYMBOL) |
                              (1<<UnicodeType.MODIFIER_SYMBOL) |
                              (1<<UnicodeType.OTHER_SYMBOL)));
            defCategory("LC", ((1<<UnicodeType.UPPERCASE_LETTER) |
                               (1<<UnicodeType.LOWERCASE_LETTER) |
                               (1<<UnicodeType.TITLECASE_LETTER)));
            defCategory("LD", ((1<<UnicodeType.UPPERCASE_LETTER) |
                               (1<<UnicodeType.LOWERCASE_LETTER) |
                               (1<<UnicodeType.TITLECASE_LETTER) |
                               (1<<UnicodeType.MODIFIER_LETTER)  |
                               (1<<UnicodeType.OTHER_LETTER)     |
                               (1<<UnicodeType.DECIMAL_NUMBER)));
            defRange("L1", 0x00, 0xFF); // Latin-1
            map.set("all", new CharPropertyFactory() {
                    make = () => { return new All(); }});

            // Posix regular expression character classes, defined in
            // http://www.unix.org/onlinepubs/009695399/basedefs/xbd_chap09.html
            defRange("ASCII", 0x00, 0x7F);   // ASCII
            defCtype("Alnum", ASCII.ALNUM);  // Alphanumeric characters
            defCtype("Alpha", ASCII.ALPHA);  // Alphabetic characters
            defCtype("Blank", ASCII.BLANK);  // Space and tab characters
            defCtype("Cntrl", ASCII.CNTRL);  // Control characters
            defRange("Digit", '0', '9');     // Numeric characters
            defCtype("Graph", ASCII.GRAPH);  // printable and visible
            defRange("Lower", 'a', 'z');     // Lower-case alphabetic
            defRange("Print", 0x20, 0x7E);   // Printable characters
            defCtype("Punct", ASCII.PUNCT);  // Punctuation characters
            defCtype("Space", ASCII.SPACE);  // Space characters
            defRange("Upper", 'A', 'Z');     // Upper-case alphabetic
            defCtype("XDigit",ASCII.XDIGIT); // hexadecimal digits

            // Java character properties, defined by methods in Character.java
            defClone("valaLowerCase", new CloneableProperty() {
                isSatisfiedBy = (ch) => {
                    return Character.IsLowerCase((int)ch);}});
            defClone("valaUpperCase", new CloneableProperty() {
                isSatisfiedBy = (ch) => {
                    return Character.IsUpperCase((int)ch);}});
            defClone("valaAlphabetic", new CloneableProperty() {
                isSatisfiedBy = (ch) => {
                    return Character.IsAlphabetic((int)ch);}});
            // defClone("valaIdeographic", new CloneableProperty() {
            //     isSatisfiedBy = (ch) => {
            //         return Character.isIdeographic(ch);}});
            defClone("valaTitleCase", new CloneableProperty() {
                isSatisfiedBy = (ch) => {
                    return Character.IsTitleCase((int)ch);}});
            defClone("valaDigit", new CloneableProperty() {
                isSatisfiedBy = (ch) => {
                    return Character.IsDigit((int)ch);}});
            defClone("valaDefined", new CloneableProperty() {
                isSatisfiedBy = (ch) => {
                    return Character.IsDefined((int)ch);}});
            defClone("valaLetter", new CloneableProperty() {
                isSatisfiedBy = (ch) => {
                    return Character.IsLetter((int)ch);}});
            defClone("valaLetterOrDigit", new CloneableProperty() {
                isSatisfiedBy = (ch) => {
                    return Character.IsLetterOrDigit((int)ch);}});
            // defClone("valaJavaIdentifierStart", new CloneableProperty() {
            //     isSatisfiedBy = (ch) => {
            //         return Character.isJavaIdentifierStart(ch);}});
            // defClone("valaJavaIdentifierPart", new CloneableProperty() {
            //     isSatisfiedBy = (ch) => {
            //         return Character.isJavaIdentifierPart(ch);}});
            // defClone("valaUnicodeIdentifierStart", new CloneableProperty() {
            //     isSatisfiedBy = (ch) => {
            //         return Character.isUnicodeIdentifierStart(ch);}});
            // defClone("valaUnicodeIdentifierPart", new CloneableProperty() {
            //     isSatisfiedBy = (ch) => {
            //         return Character.isUnicodeIdentifierPart(ch);}});
            // defClone("valaIdentifierIgnorable", new CloneableProperty() {
            //     isSatisfiedBy = (ch) => {
            //         return Character.isIdentifierIgnorable(ch);}});
            defClone("valaSpaceChar", new CloneableProperty() {
                isSatisfiedBy = (ch) => {
                    return Character.IsSpaceChar((int)ch);}});
            defClone("valaWhitespace", new CloneableProperty() {
                isSatisfiedBy = (ch) => {
                    return Character.IsWhitespace((int)ch);}});
            defClone("valaISOControl", new CloneableProperty() {
                isSatisfiedBy = (ch) => {
                    return Character.IsISOControl((int)ch);}});
            // defClone("valaMirrored", new CloneableProperty() {
            //     isSatisfiedBy = (ch) => {
            //         return Character.isMirrored(ch);}});
        }
    }

    /**
     * Creates a predicate which can be used to match a string.
     *
     * @return  The predicate which can be used for matching on a string
     * @since   1.8
     */
    // public Predicate<string> AsPredicate() {
    //     return s -> Matcher(s).Find();
    // }

    /**
     * Creates a stream from the given input sequence around matches of this
     * pattern.
     *
     * <p> The stream returned by this method contains each substring of the
     * input sequence that is terminated by another subsequence that matches
     * this pattern or is terminated by the end of the input sequence.  The
     * substrings in the stream are in the order in which they occur in the
     * input. Trailing empty strings will be discarded and not encountered in
     * the stream.
     *
     * <p> If this pattern does not match any subsequence of the input then
     * the resulting stream has just one element, namely the input sequence in
     * string form.
     *
     * <p> When there is a positive-width match at the beginning of the input
     * sequence then an empty leading substring is included at the beginning
     * of the stream. A zero-width match at the beginning however never produces
     * such empty leading substring.
     *
     * <p> If the input sequence is mutable, it must remain constant during the
     * execution of the terminal stream operation.  Otherwise, the result of the
     * terminal stream operation is undefined.
     *
     * @param   input
     *          The character sequence to be split
     *
     * @return  The stream of strings computed by splitting the input
     *          around matches of this pattern
     * @see     #split(string)
     * @since   1.8
     */
    // public Stream<string> splitAsStream(string input) {
    //     class MatcherIterator : Object, Iterator<string> {
    //         private Matcher matcher;
    //         // The start position of the next sub-sequence of input
    //         // when current == input.length there are no more elements
    //         private int current;
    //         // null if the next element, if any, needs to obtained
    //         private string nextElement;
    //         // > 0 if there are N next empty elements
    //         private int emptyElementCount;

    //         MatcherIterator() {
    //             this.matcher = Matcher(input);
    //         }

    //         public string next() {
    //             if (!hasNext())
    //                 throw new NoSuchElementException();

    //             if (emptyElementCount == 0) {
    //                 string n = nextElement;
    //                 nextElement = null;
    //                 return n;
    //             } else {
    //                 emptyElementCount--;
    //                 return "";
    //             }
    //         }

    //         public bool hasNext() {
    //             if (nextElement != null || emptyElementCount > 0)
    //                 return true;

    //             if (current == input.length())
    //                 return false;

    //             // Consume the next matching element
    //             // Count sequence of matching empty elements
    //             while (matcher.find()) {
    //                 nextElement = input.substr(current, matcher.start()).toString();
    //                 current = matcher.end();
    //                 if (!nextElement.isEmpty()) {
    //                     return true;
    //                 } else if (current > 0) { // no empty leading substring for zero-width
    //                                           // match at the beginning of the input
    //                     emptyElementCount++;
    //                 }
    //             }

    //             // Consume last matching element
    //             nextElement = input.substr(current, input.length()).toString();
    //             current = input.length();
    //             if (!nextElement.isEmpty()) {
    //                 return true;
    //             } else {
    //                 // Ignore a terminal sequence of matching empty elements
    //                 emptyElementCount = 0;
    //                 nextElement = null;
    //                 return false;
    //             }
    //         }
    //     }
    //     return StreamSupport.stream(Spliterators.spliteratorUnknownSize(
    //             new MatcherIterator(), Spliterator.ORDERED | Spliterator.NONNULL), false);
    // }
}
