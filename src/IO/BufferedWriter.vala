/**
 * Writes text to a character-output stream, buffering characters so as to
 * provide for the efficient writing of single characters, arrays, and strings.
 *
 * <p> The buffer size may be specified, or the default size may be accepted.
 * The default is large enough for most purposes.
 *
 * <p> A newLine() method is provided, which uses the platform's own notion of
 * line separator as defined by the system property <tt>line.separator</tt>.
 * Not all platforms use the newline character ('\n') to terminate lines.
 * Calling this method to terminate each output line is therefore preferred to
 * writing a newline character directly.
 *
 * <p> In general, a Writer sends its output immediately to the underlying
 * character or byte stream.  Unless prompt output is required, it is advisable
 * to wrap a BufferedWriter around any Writer whose write() operations may be
 * costly, such as FileWriters and OutputStreamWriters.  For example,
 *
 * <pre>
 * PrintWriter out
 *   = new PrintWriter(new BufferedWriter(new FileWriter("foo.out")));
 * </pre>
 *
 * will buffer the PrintWriter's output to the file.  Without buffering, each
 * invocation of a print() method would cause characters to be converted into
 * bytes that would then be written immediately to the file, which can be very
 * inefficient.
 *
 * @see PrintWriter
 * @see FileWriter
 * @see OutputStreamWriter
 * @see java.nio.file.Files#newBufferedWriter
 *
 * @author      Mark Reinhold
 * @since       JDK1.1
 */

public class System.IO.BufferedWriter : Writer 
{

    private Writer out;
    private Object lock;

    private char[] cb;
    private int nChars;
    private int nextChar;

    public const int defaultCharBufferSize = 8192;

    /**
     * Line separator string.  This is the value of the line.separator
     * property at the moment that the stream was created.
     */
    private string lineSeparator;

    /**
     * Creates a new buffered character-output stream that uses an output
     * buffer of the given size.
     *
     * @param  out  A Writer
     * @param  sz   Output-buffer size, a positive integer
     *
     * @exception  IllegalArgumentException  If {@code sz <= 0}
     */
    public BufferedWriter(Writer ou, int sz = defaultCharBufferSize) 
    {
        this.lock = ou.lock;
        base(ou);
        if (sz <= 0)
            throw new IOException.IllegalArgumentException("Buffer size <= 0");
        this.out = ou;
        cb = new char[sz];
        nChars = sz;
        nextChar = 0;

        lineSeparator = "\r\n"; //java.security.AccessController.doPrivileged(
            // new sun.security.action.GetPropertyAction("line.separator"));
    }

    /** Checks to make sure that the stream has not been closed */
    private void EnsureOpen() throws IOException 
    {
        if (this.out == null)
            throw new IOException.Exception("Stream closed");
    }

    /**
     * Flushes the output buffer to the underlying character stream, without
     * flushing the stream itself.  This method is non-private only so that it
     * may be invoked by PrintStream.
     */
    public void FlushBuffer() throws IOException 
    {
        lock (lock) {
            EnsureOpen();
            if (nextChar == 0)
                return;
            this.out.Write(cb, 0, nextChar);
            nextChar = 0;
        }
    }

    /**
     * Writes a single character.
     *
     * @exception  IOException  If an I/O error occurs
     */
    public override void WriteOne(int c) throws IOException 
    {
        lock (lock) {
            EnsureOpen();
            if (nextChar >= nChars)
                FlushBuffer();
            cb[nextChar++] = (char) c;
        }
    }

    /**
     * Our own little min method, to avoid loading java.lang.Math if we've run
     * out of file descriptors and we're trying to print a stack trace.
     */
    private int min(int a, int b) 
    {
        if (a < b) return a;
        return b;
    }

    /**
     * Writes a portion of an array of characters.
     *
     * <p> Ordinarily this method stores characters from the given array into
     * this stream's buffer, flushing the buffer to the underlying stream as
     * needed.  If the requested length is at least as large as the buffer,
     * however, then this method will flush the buffer and write the characters
     * directly to the underlying stream.  Thus redundant
     * <code>BufferedWriter</code>s will not copy data unnecessarily.
     *
     * @param  cbuf  A character array
     * @param  off   Offset from which to start reading characters
     * @param  len   Number of characters to write
     *
     * @exception  IOException  If an I/O error occurs
     */
    public override void Write(char[] cbuf, int off=0, int len=0) throws IOException 
    {
        if (len == 0) len = cbuf.length;
        lock (lock) {
            EnsureOpen();
            if ((off < 0) || (off > cbuf.length) || (len < 0) ||
                ((off + len) > cbuf.length) || ((off + len) < 0)) {
                throw new IOException.IndexOutOfBoundsException("");
            } else if (len == 0) {
                return;
            }

            if (len >= nChars) {
                /* If the request length exceeds the size of the output buffer,
                   flush the buffer and then write the data directly.  In this
                   way buffered streams will cascade harmlessly. */
                FlushBuffer();
                this.out.Write(cbuf, off, len);
                return;
            }
            

            int b = off, t = off + len;
            while (b < t) {
                int d = min(nChars - nextChar, t - b);
                System.arraycopy<char>(cbuf, b, cb, nextChar, d);
                b += d;
                nextChar += d;
                if (nextChar >= nChars)
                    FlushBuffer();
            }
        }
    }

    /**
     * Writes a portion of a String.
     *
     * <p> If the value of the <tt>len</tt> parameter is negative then no
     * characters are written.  This is contrary to the specification of this
     * method in the {@linkplain java.io.Writer#write(java.lang.String,int,int)
     * superclass}, which requires that an {@link IndexOutOfBoundsException} be
     * thrown.
     *
     * @param  s     String to be written
     * @param  off   Offset from which to start reading characters
     * @param  len   Number of characters to be written
     *
     * @exception  IOException  If an I/O error occurs
     */
    public override void WriteStr(string s, int off=0, int len=0) throws IOException 
    {
        if (len == 0) len = s.length;
        lock (lock) {
            EnsureOpen();

            int b = off, t = off + len;
            while (b < t) {
                int d = min(nChars - nextChar, t - b);
                s.get_chars(b, b + d, cb, nextChar);
                b += d;
                nextChar += d;
                if (nextChar >= nChars)
                    FlushBuffer();
            }
        }
    }

    /**
     * Writes a line separator.  The line separator string is defined by the
     * system property <tt>line.separator</tt>, and is not necessarily a single
     * newline ('\n') character.
     *
     * @exception  IOException  If an I/O error occurs
     */
    public void NewLine() throws IOException 
    {
        WriteStr(lineSeparator);
    }

    /**
     * Flushes the stream.
     *
     * @exception  IOException  If an I/O error occurs
     */
    public override void Flush() throws IOException 
    {
        lock (lock) {
            FlushBuffer();
            this.out.Flush();
        }
    }

    public override void Close() throws IOException 
    {
        lock (lock) {
            if (this.out == null) {
                return;
            }
            try {
                FlushBuffer();
            } finally {
                this.out = null;
                this.cb = null;
            }
        }
    }
}
