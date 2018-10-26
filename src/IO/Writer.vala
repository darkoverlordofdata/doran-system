/**
 * Abstract class for writing to character streams.  The only methods that a
 * subclass must implement are write(char[], int, int), flush(), and close().
 * Most subclasses, however, will override some of the methods defined here in
 * order to provide higher efficiency, additional functionality, or both.
 *
 * @see Writer
 * @see   BufferedWriter
 * @see   CharArrayWriter
 * @see   FilterWriter
 * @see   OutputStreamWriter
 * @see     FileWriter
 * @see   PipedWriter
 * @see   PrintWriter
 * @see   StringWriter
 * @see Reader
 *
 * @author      Mark Reinhold
 * @since       JDK1.1
 */


// public abstract class System.IO.Writer : Object, Appendable//, Closeable, Flushable 
public abstract class System.IO.Writer : Appendable//, Closeable, Flushable 
{

    /**
     * Temporary buffer used to hold writes of strings and single characters
     */
    private char[] writeBuffer;

    /**
     * Size of writeBuffer, must be >= 1
     */
    private const int WRITE_BUFFER_SIZE = 1024;

    /**
     * The object used to synchronize operations on this stream.  For
     * efficiency, a character-stream object may use an object other than
     * itself to protect critical sections.  A subclass should therefore use
     * the object in this field rather than <tt>this</tt> or a synchronized
     * method.
     */
    protected Object lock;

    /**
     * Creates a new character-stream writer whose critical sections will
     * synchronize on the given object.
     *
     * @param  lock
     *         Object to synchronize on
     */
    protected Writer(Object? lock = null) 
    {
        if (lock == null) {
            this.lock = this;
        }
        else
            this.lock = lock;
    }

    /**
     * Writes a single character.  The character to be written is contained in
     * the 16 low-order bits of the given integer value; the 16 high-order bits
     * are ignored.
     *
     * <p> Subclasses that intend to support efficient single-character output
     * should override this method.
     *
     * @param  c
     *         int specifying a character to be written
     *
     * @throws  IOException
     *          If an I/O error occurs
     */
    public virtual void WriteOne(int c) throws IOException 
    {
        lock (lock) {
            if (writeBuffer == null){
                writeBuffer = new char[WRITE_BUFFER_SIZE];
            }
            writeBuffer[0] = (char) c;
            Write(writeBuffer, 0, 1);
        }
    }

    /**
     * Writes a portion of an array of characters.
     *
     * @param  cbuf
     *         Array of characters
     *
     * @param  off
     *         Offset from which to start writing characters
     *
     * @param  len
     *         Number of characters to write
     *
     * @throws  IOException
     *          If an I/O error occurs
     */
    public abstract void Write(char[] cbuf, int off=0, int len=0) throws IOException;

    /**
     * Writes a portion of a string.
     *
     * @param  str
     *         A String
     *
     * @param  off
     *         Offset from which to start writing characters
     *
     * @param  len
     *         Number of characters to write
     *
     * @throws  IndexOutOfBoundsException
     *          If <tt>off</tt> is negative, or <tt>len</tt> is negative,
     *          or <tt>off+len</tt> is negative or greater than the length
     *          of the given string
     *
     * @throws  IOException
     *          If an I/O error occurs
     */
    public virtual void WriteStr(string str, int off=0, int len=0) throws IOException 
    {
        if (len == 0) len = str.length;
        lock (lock) {
            char[] cbuf;
            if (len <= WRITE_BUFFER_SIZE) {
                if (writeBuffer == null) {
                    writeBuffer = new char[WRITE_BUFFER_SIZE];
                }
                cbuf = writeBuffer;
            } else {    // Don't permanently allocate very large buffers.
                cbuf = new char[len];
            }
            str.get_chars(off, (off + len), cbuf, 0);
            Write(cbuf, 0, len);
        }
    }

    /**
     * Appends the specified character to this writer.
     *
     * <p> An invocation of this method of the form <tt>out.append(c)</tt>
     * behaves in exactly the same way as the invocation
     *
     * <pre>
     *     out.write(c) </pre>
     *
     * @param  c
     *         The 16-bit character to append
     *
     * @return  This writer
     *
     * @throws  IOException
     *          If an I/O error occurs
     *
     * @since 1.5
     */
    public override Appendable Append(string csq, int start=0, int end=0) throws IOException 
    {
        if (end == 0) end = csq.length;
        WriteStr(csq, start, end-start);
        return this;
    }
    public override Appendable AppendChar(char c) throws IOException 
    {
        WriteOne(c);
        return this;
    }

    /**
     * Flushes the stream.  If the stream has saved any characters from the
     * various write() methods in a buffer, write them immediately to their
     * intended destination.  Then, if that destination is another character or
     * byte stream, flush it.  Thus one flush() invocation will flush all the
     * buffers in a chain of Writers and OutputStreams.
     *
     * <p> If the intended destination of this stream is an abstraction provided
     * by the underlying operating system, for example a file, then flushing the
     * stream guarantees only that bytes previously written to the stream are
     * passed to the operating system for writing; it does not guarantee that
     * they are actually written to a physical device such as a disk drive.
     *
     * @throws  IOException
     *          If an I/O error occurs
     */
    public abstract void Flush() throws IOException;

    /**
     * Closes the stream, flushing it first. Once the stream has been closed,
     * further write() or flush() invocations will cause an IOException to be
     * thrown. Closing a previously closed stream has no effect.
     *
     * @throws  IOException
     *          If an I/O error occurs
     */
    public abstract void Close() throws IOException;

}
