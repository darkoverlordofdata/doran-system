/*
Copyright (c) 2002 JSON.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

The Software shall be used for Good, not Evil.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
 */

/**
 * A JSONTokener takes a source string and extracts characters and tokens from
 * it. It is used by the JSONObject and JSONArray constructors to parse
 * JSON source strings.
 * @author JSON.org
 * @version 2014-05-03
 */
using System.IO;
public class System.JSON.JSONTokener : Object 
{
    /** current read character position on the current line. */
    private long character;
    /** flag to indicate if the end of the input has been found. */
    private bool eof;
    /** current read index of the input. */
    private long index;
    /** current line of the input. */
    private long line;
    /** previous character read from the input. */
    private char previous;
    /** Reader for the input. */
    private Reader reader;
    /** flag to indicate that a previous character was requested. */
    private bool usePrevious;
    /** the number of characters read in the previous line. */
    private long characterPreviousLine;


    /**
     * Construct a JSONTokener from a Reader. The caller must close the Reader.
     *
     * @param reader     A reader.
     */
    public JSONTokener.FromReader(Reader reader) 
    {
        this.reader = reader.MarkSupported()
                ? reader
                : new BufferedReader(reader);
        eof = false;
        usePrevious = false;
        previous = 0;
        index = 0;
        character = 1;
        characterPreviousLine = 0;
        line = 1;
    }


    /**
     * Construct a JSONTokener from an InputStream. The caller must close the input stream.
     * @param inputStream The source.
     */
    public JSONTokener.FromStream(InputStream inputStream) 
    {
        this.FromReader(new InputStreamReader(inputStream));
    }


    /**
     * Construct a JSONTokener from a string.
     *
     * @param s     A source string.
     */
    public JSONTokener(string s) 
    {
        this.FromReader(new StringReader(s));
    }

    /**
     * Back up one character. This provides a sort of lookahead capability,
     * so that you can test for a digit or letter before attempting to parse
     * the next number or identifier.
     * @throws JSONException Thrown if trying to step back more than 1 step
     *  or if already at the start of the string
     */
    public void Back() throws JSONException 
    {
        if (usePrevious || index <= 0) {
            throw new JSONException.Exception("Stepping back two steps is not supported");
        }
        DecrementIndexes();
        usePrevious = true;
        eof = false;
    }

    /**
     * Decrements the indexes for the {@link #back()} method based on the previous character read.
     */
    private void DecrementIndexes() 
    {
        index--;
        if(previous=='\r' || previous == '\n') {
            line--;
            character=characterPreviousLine ;
        } else if(character > 0){
            character--;
        }
    }

    /**
     * Get the hex value of a character (base16).
     * @param c A character between '0' and '9' or between 'A' and 'F' or
     * between 'a' and 'f'.
     * @return  An int between 0 and 15, or -1 if c was not a hex digit.
     */
    public static int Dehexchar(char c) 
    {
        if (c >= '0' && c <= '9') {
            return c - '0';
        }
        if (c >= 'A' && c <= 'F') {
            return c - ('A' - 10);
        }
        if (c >= 'a' && c <= 'f') {
            return c - ('a' - 10);
        }
        return -1;
    }

    /**
     * Checks if the end of the input has been reached.
     *  
     * @return true if at the end of the file and we didn't step back
     */
    public bool End() 
    {
        return eof && !usePrevious;
    }


    /**
     * Determine if the source string still contains characters that next()
     * can consume.
     * @return true if not yet at the end of the source.
     * @throws JSONException thrown if there is an error stepping forward
     *  or backward while checking for more data.
     */
    public bool More() throws JSONException 
    {
        if(usePrevious) {
            return true;
        }
        try {
            reader.Mark(1);
        } catch (IOException e) {
            throw new JSONException.IOException("Unable to preserve stream position");
        }
        try {
            // -1 is EOF, but next() can not consume the null character '\0'
            if(reader.ReadOne() <= 0) {
                eof = true;
                return false;
            }
            reader.Reset();
        } catch (IOException e) {
            throw new JSONException.Exception("Unable to read the next character from the stream");
        }
        return true;
    }


    /**
     * Get the next character in the source string.
     *
     * @return The next character, or 0 if past the end of the source string.
     * @throws JSONException Thrown if there is an error reading the source string.
     */
    public char Next() throws JSONException 
    {
        int c;
        if (usePrevious) {
            usePrevious = false;
            c = previous;
        } else {
            try {
                c = reader.ReadOne();
            } catch (IOException exception) {
                throw new JSONException.IOException(exception.message);
            }
        }
        if (c <= 0) { // End of stream
            eof = true;
            return 0;
        }
        IncrementIndexes(c);
        previous = (char) c;
        return previous;
    }

    /**
     * Increments the internal indexes according to the previous character
     * read and the character passed as the current character.
     * @param c the current character read.
     */
    private void IncrementIndexes(int c) 
    {
        if(c > 0) {
            index++;
            if(c=='\r') {
                line++;
                characterPreviousLine = character;
                character=0;
            }else if (c=='\n') {
                if(previous != '\r') {
                    line++;
                    characterPreviousLine = character;
                }
                character=0;
            } else {
                character++;
            }
        }
    }

    /**
     * Consume the next character, and check that it matches a specified
     * character.
     * @param c The character to match.
     * @return The character.
     * @throws JSONException if the character does not match.
     */
    public char NextChar(char c) throws JSONException 
    {
        char n = Next();
        if (n != c) {
            if(n > 0) {
                throw SyntaxError(@"Expected $c and instead saw $n");
            }
            throw SyntaxError(@"Expected $c and instead saw ''");
        }
        return n;
    }


    /**
     * Get the next n characters.
     *
     * @param n     The number of characters to take.
     * @return      A string of n characters.
     * @throws JSONException
     *   Substring bounds error if there are not
     *   n characters remaining in the source string.
     */
    public string NextN(int n) throws JSONException 
    {
        if (n == 0) {
            return "";
        }

        char[] chars = new char[n];
        int pos = 0;

        while (pos < n) {
            chars[pos] = Next();
            if (End()) {
                throw SyntaxError("Substring bounds error");
            }
            pos += 1;
        }
        return string.strndup(chars, pos);
    }


    /**
     * Get the next char in the string, skipping whitespace.
     * @throws JSONException Thrown if there is an error reading the source string.
     * @return  A character, or 0 if there are no more characters.
     */
    public char NextClean() throws JSONException 
    {
        for (;;) {
            char c = Next();
            if (c == 0 || c > ' ') {
                return c;
            }
        }
    }


    /**
     * Return the characters up to the next close quote character.
     * Backslash processing is done. The formal JSON format does not
     * allow strings in single quotes, but an implementation is allowed to
     * accept them.
     * @param quote The quoting character, either
     *      <code>"</code>&nbsp;<small>(double quote)</small> or
     *      <code>'</code>&nbsp;<small>(single quote)</small>.
     * @return      A string.
     * @throws JSONException Unterminated string.
     */
    public String NextString(char quote) throws JSONException 
    {
        char c;
        StringBuilder sb = new StringBuilder();
        for (;;) {
            c = Next();
            switch (c) {
            case 0:
            case '\n':
            case '\r':
                throw SyntaxError("Unterminated string");
            case '\\':
                c = Next();
                switch (c) {
                case 'b':
                    sb.append_c('\b');
                    break;
                case 't':
                    sb.append_c('\t');
                    break;
                case 'n':
                    sb.append_c('\n');
                    break;
                case 'f':
                    sb.append_c('\f');
                    break;
                case 'r':
                    sb.append_c('\r');
                    break;
                // case 'u':
                //     try {
                //         sb.append_c((char)Integer.ParseInt(NextN(4), 16));
                //     } catch (Exception e) {
                //         throw SyntaxError("Illegal escape.");
                //     }
                //     break;
                case '"':
                case '\'':
                case '\\':
                case '/':
                    sb.append_c(c);
                    break;
                default:
                    throw SyntaxError("Illegal escape.");
                }
                break;
            default:
                if (c == quote) {
                    return new String(sb.str);
                }
                sb.append_c(c);
                break;
            }
        }
    }


    /**
     * Get the text up but not including the specified character or the
     * end of line, whichever comes first.
     * @param  delimiter A delimiter character.
     * @return   A string.
     * @throws JSONException Thrown if there is an error while searching
     *  for the delimiter
     */
    public string NextTo(char delimiter) throws JSONException 
    {
        StringBuilder sb = new StringBuilder();
        for (;;) {
            char c = Next();
            if (c == delimiter || c == 0 || c == '\n' || c == '\r') {
                if (c != 0) {
                    Back();
                }
                return sb.str.trim();
            }
            sb.append_c(c);
        }
    }


    /**
     * Get the text up but not including one of the specified delimiter
     * characters or the end of line, whichever comes first.
     * @param delimiters A set of delimiter characters.
     * @return A string, trimmed.
     * @throws JSONException Thrown if there is an error while searching
     *  for the delimiter
     */
    public string NextToN(string delimiters) throws JSONException 
    {
        char c;
        StringBuilder sb = new StringBuilder();
        for (;;) {
            c = Next();
            if (delimiters.index_of(string.char(c)) >= 0 || c == 0 ||
                    c == '\n' || c == '\r') {
                if (c != 0) {
                    Back();
                }
                return sb.str.trim();
            }
            sb.append_c(c);
        }
    }


    /**
     * Get the next value. The value can be a Boolean, Double, Integer,
     * JSONArray, JSONObject, Long, or string, or the JSONObject.NULL object.
     * @throws JSONException If syntax error.
     *
     * @return An object.
     */
    public Object NextValue() throws JSONException 
    {
        char c = NextClean();
        string str;

        switch (c) {
        case '"':
        case '\'':
            return NextString(c);
        case '{':
            Back();
            return new JSONObject.Tokener(this);
        case '[':
            Back();
            return new JSONArray.Tokener(this);
        }

        /*
         * Handle unquoted text. This could be the values true, false, or
         * null, or it can be a number. An implementation (such as this one)
         * is allowed to also accept non-standard forms.
         *
         * Accumulate characters until we reach the end of the text or a
         * formatting character.
         */

        StringBuilder sb = new StringBuilder();
        while (c >= ' ' && ",:]}/\\\"[{;=#".index_of(string.char(c)) < 0) {
            sb.append_c(c);
            c = Next();
        }
        Back();

        str = sb.str.trim();
        if ("" == str) {
            throw SyntaxError("Missing value");
        }
        return JSONObject.StringToValue(str);
    }


    /**
     * Skip characters until the next character is the requested character.
     * If the requested character is not found, no characters are skipped.
     * @param to A character to skip to.
     * @return The requested character, or zero if the requested character
     * is not found.
     * @throws JSONException Thrown if there is an error while searching
     *  for the to character
     */
    public char SkipTo(char to) throws JSONException 
    {
        char c = 0;
        try {
            long startIndex = index;
            long startCharacter = character;
            long startLine = line;
            reader.Mark(1000000);
            do {
                c = Next();
                if (c == 0) {
                    // in some readers, reset() may throw an exception if
                    // the remaining portion of the input is greater than
                    // the mark size (1,000,000 above).
                    reader.Reset();
                    index = startIndex;
                    character = startCharacter;
                    line = startLine;
                    return 0;
                }
            } while (c != to);
            reader.Mark(1);
        } catch (IOException exception) {
            throw new JSONException.IOException(exception.message);
        }
        Back();
        return c;
    }

    /**
     * Make a JSONException to signal a syntax error.
     *
     * @param message The error message.
     * @return  A JSONException object, suitable for throwing
     */
    public JSONException SyntaxError(string message) {
        return new JSONException.Exception(message + ToString());
    }

    /**
     * Make a printable string of this JSONTokener.
     *
     * @return " at {index} [character {character} line {line}]"
     */
    public override string ToString() {
        return @" at $(index) [character $(character) line $(line)]";
    }
}
