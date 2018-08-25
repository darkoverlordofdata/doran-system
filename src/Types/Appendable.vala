/**
 * An object to which <tt>char</tt> sequences and values can be appended.  The
 * <tt>Appendable</tt> interface must be implemented by any class whose
 * instances are intended to receive formatted output from a {@link
 * java.util.Formatter}.
 *
 * <p> The characters to be appended should be valid Unicode characters as
 * described in <a href="Character.html#unicode">Unicode Character
 * Representation</a>.  Note that supplementary characters may be composed of
 * multiple 16-bit <tt>char</tt> values.
 *
 * <p> Appendables are not necessarily safe for multithreaded access.  Thread
 * safety is the responsibility of classes that extend and implement this
 * interface.
 *
 * <p> Since this interface may be implemented by existing classes
 * with different styles of error handling there is no guarantee that
 * errors will be propagated to the invoker.
 *
 * @since 1.5
 */
public interface System.Appendable : Object 
{

    /**
     * Appends a subsequence of the specified character sequence to this
     * <tt>Appendable</tt>.
     *
     * <p> An invocation of this method of the form <tt>out.append(csq, start,
     * end)</tt> when <tt>csq</tt> is not <tt>null</tt>, behaves in
     * exactly the same way as the invocation
     *
     * <pre>
     *     out.append(csq.subSequence(start, end)) </pre>
     *
     * @param  csq
     *         The character sequence from which a subsequence will be
     *         appended.  If <tt>csq</tt> is <tt>null</tt>, then characters
     *         will be appended as if <tt>csq</tt> contained the four
     *         characters <tt>"null"</tt>.
     *
     * @param  start
     *         The index of the first character in the subsequence
     *
     * @param  end
     *         The index of the character following the last character in the
     *         subsequence
     *
     * @return  A reference to this <tt>Appendable</tt>
     *
     * @throws  IndexOutOfBoundsException
     *          If <tt>start</tt> or <tt>end</tt> are negative, <tt>start</tt>
     *          is greater than <tt>end</tt>, or <tt>end</tt> is greater than
     *          <tt>csq.length()</tt>
     *
     * @throws  IOException
     *          If an I/O error occurs
     */
    public abstract Appendable Append(string csq, int start=0, int end=0) throws IOException;

    /**
     * Appends the specified character to this <tt>Appendable</tt>.
     *
     * @param  c
     *         The character to append
     *
     * @return  A reference to this <tt>Appendable</tt>
     *
     * @throws  IOException
     *          If an I/O error occurs
     */
    public abstract Appendable AppendChar(char c) throws IOException;
}
