/**
 * A character stream that collects its output in a string buffer, which can
 * then be used to construct a string.
 * <p>
 * Closing a <tt>StringWriter</tt> has no effect. The methods in this class
 * can be called after the stream has been closed without generating an
 * <tt>IOException</tt>.
 *
 * @author      Mark Reinhold
 * @since       JDK1.1
 */
public class System.IO.StringWriter : Writer
{

    private StringBuilder buf;

    /**
     * Create a new string writer using the default initial string-buffer
     * size.
     */
    public StringWriter() 
    {
        buf = new StringBuilder();
    }


    /**
     * Write a single character.
     */
    public void WriteOne(int c) 
    {
        buf.append_c((char) c);
    }

    /**
     * Write a portion of an array of characters.
     *
     * @param  cbuf  Array of characters
     * @param  off   Offset from which to start writing characters
     * @param  len   Number of characters to write
     */
    public override void Write(char[] cbuf, int off, int len) 
    {
        if ((off < 0) || (off > cbuf.length) || (len < 0) ||
            ((off + len) > cbuf.length) || ((off + len) < 0)) {
            throw new IOException.IndexOutOfBoundsException("");
        } else if (len == 0) {
            return;
        }
        buf.append(string.strndup(&cbuf[off], len));
    }

    /**
     * Write a portion of a string.
     *
     * @param  str  String to be written
     * @param  off  Offset from which to start writing characters
     * @param  len  Number of characters to write
     */
    public void WriteStr(string str, int off=0, int len=0)  
    {
        if (len == 0)
            buf.append(str);
        else
            buf.append(str.substring(off, off + len));
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
     * @since 1.5
     */
    public new Writer Append(string csq, int start=0, int end=0) throws IOException 
    {
        if (end == 0) end = csq.length;
        WriteStr(csq, start, end-start);
        return this;
    }
    public new Writer AppendChar(char c) throws IOException 
    {
        WriteOne(c);
        return this;
    }



    /**
     * Return the buffer's current value as a string.
     */
    public override string ToString() 
    {
        return buf.str;
    }

    /**
     * Return the string buffer itself.
     *
     * @return StringBuffer holding the current buffer value.
     */
    public unowned StringBuilder GetBuffer() 
    {
        return buf;
    }

    /**
     * Flush the stream.
     */
    public override void Flush() 
    {
    }

    /**
     * Closing a <tt>StringWriter</tt> has no effect. The methods in this
     * class can be called after the stream has been closed without generating
     * an <tt>IOException</tt>.
     */
    public override void Close() throws IOException 
    {
    }
}