/*
Copyright (c) 2006 JSON.org

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
using System.IO;
using System.Collections.Generic;
/**
 * JSONWriter provides a quick and convenient way of producing JSON text.
 * The texts produced strictly conform to JSON syntax rules. No whitespace is
 * added, so the results are ready for transmission or storage. Each instance of
 * JSONWriter can produce one JSON text.
 * <p>
 * A JSONWriter instance provides a <code>value</code> method for appending
 * values to the
 * text, and a <code>key</code>
 * method for adding keys before values in objects. There are <code>array</code>
 * and <code>endArray</code> methods that make and bound array values, and
 * <code>object</code> and <code>endObject</code> methods which make and bound
 * object values. All of these methods return the JSONWriter instance,
 * permitting a cascade style. For example, <pre>
 * new JSONWriter(myWriter)
 *     .object()
 *         .key("JSON")
 *         .value("Hello, World!")
 *     .endObject();</pre> which writes <pre>
 * {"JSON":"Hello, World!"}</pre>
 * <p>
 * The first method called must be <code>array</code> or <code>object</code>.
 * There are no methods for adding commas or colons. JSONWriter adds them for
 * you. Objects and arrays can be nested up to 200 levels deep.
 * <p>
 * This can sometimes be easier than using a JSONObject to build a string.
 * @author JSON.org
 * @version 2016-08-08
 */
public class System.JSON.JSONWriter 
{
    private static int maxdepth = 200;

    /**
     * The comma flag determines if a comma should be output before the next
     * value.
     */
    private bool comma;

    /**
     * The current mode. Values:
     * 'a' (array),
     * 'd' (done),
     * 'i' (initial),
     * 'k' (key),
     * 'o' (object).
     */
    protected char mode;

    /**
     * The object/array stack.
     */
    private JSONObject[] stack;

    /**
     * The stack top index. A value of 0 indicates that the stack is empty.
     */
    private int top;

    /**
     * The writer that will receive the output.
     */
    protected Appendable writer;

    /**
     * Make a fresh JSONWriter. It can be used to build one JSON text.
     */
    public JSONWriter(Appendable w) 
    {
        comma = false;
        mode = 'i';
        stack = new JSONObject[maxdepth];
        top = 0;
        writer = w;
    }

    /**
     * Append a value.
     * @param string A string value.
     * @return this
     * @throws JSONException If the value is out of sequence.
     */
    private JSONWriter Append(string string) throws JSONException 
    {
        if (string == null) {
            throw new JSONException.Exception("Null pointer");
        }
        if (mode == 'o' || mode == 'a') {
            try {
                if (comma && mode == 'a') {
                    writer.AppendChar(',');
                }
                writer.Append(string);
            } catch (IOException e) {
            	// Android as of API 25 does not support this exception constructor
            	// however we won't worry about it. If an exception is happening here
            	// it will just throw a "Method not found" exception instead.
                throw new JSONException.Exception(e.message);
            }
            if (mode == 'o') {
                mode = 'k';
            }
            comma = true;
            return this;
        }
        throw new JSONException.Exception("Value out of sequence.");
    }

    /**
     * Begin appending a new array. All values until the balancing
     * <code>endArray</code> will be appended to this array. The
     * <code>endArray</code> method must be called to mark the array's end.
     * @return this
     * @throws JSONException If the nesting is too deep, or if the object is
     * started in the wrong place (for example as a key or after the end of the
     * outermost array or object).
     */
    public JSONWriter Array() throws JSONException 
    {
        if (mode == 'i' || mode == 'o' || mode == 'a') {
            Push(null);
            Append("[");
            comma = false;
            return this;
        }
        throw new JSONException.Exception("Misplaced array.");
    }

    /**
     * End something.
     * @param m Mode
     * @param c Closing character
     * @return this
     * @throws JSONException If unbalanced.
     */
    private JSONWriter End(char m, char c) throws JSONException 
    {
        if (mode != m) {
            throw new JSONException.Exception(m == 'a'
                ? "Misplaced endArray."
                : "Misplaced endObject.");
        }
        Pop(m);
        try {
            writer.AppendChar(c);
        } catch (IOException e) {
        	// Android as of API 25 does not support this exception constructor
        	// however we won't worry about it. If an exception is happening here
        	// it will just throw a "Method not found" exception instead.
            throw new JSONException.Exception(e.message);
        }
        comma = true;
        return this;
    }

    /**
     * End an array. This method most be called to balance calls to
     * <code>array</code>.
     * @return this
     * @throws JSONException If incorrectly nested.
     */
    public JSONWriter EndArray() throws JSONException 
    {
        return End('a', ']');
    }

    /**
     * End an object. This method most be called to balance calls to
     * <code>object</code>.
     * @return this
     * @throws JSONException If incorrectly nested.
     */
    public JSONWriter EndObject() throws JSONException 
    {
        return End('k', '}');
    }

    /**
     * Append a key. The key will be associated with the next value. In an
     * object, every value must be preceded by a key.
     * @param string A key string.
     * @return this
     * @throws JSONException If the key is out of place. For example, keys
     *  do not belong in arrays or if the key is null.
     */
    public JSONWriter Key(string string) throws JSONException 
    {
        if (string == null) {
            throw new JSONException.Exception("Null key.");
        }
        if (mode == 'k') {
            try {
                JSONObject topObject = stack[top - 1];
                // don't use the built in putOnce method to maintain Android support
				if(topObject.Has(string)) {
					throw new JSONException.Exception(@"Duplicate key \"$string\"");
				}
                topObject.PutBoolean(string, true);
                if (comma) {
                    writer.AppendChar(',');
                }
                writer.Append(JSONObject.Quote(string));
                writer.AppendChar(':');
                comma = false;
                mode = 'o';
                return this;
            } catch (IOException e) {
            	// Android as of API 25 does not support this exception constructor
            	// however we won't worry about it. If an exception is happening here
            	// it will just throw a "Method not found" exception instead.
                throw new JSONException.Exception(e.message);
            }
        }
        throw new JSONException.Exception("Misplaced key.");
    }


    /**
     * Begin appending a new object. All keys and values until the balancing
     * <code>endObject</code> will be appended to this object. The
     * <code>endObject</code> method must be called to mark the object's end.
     * @return this
     * @throws JSONException If the nesting is too deep, or if the object is
     * started in the wrong place (for example as a key or after the end of the
     * outermost array or object).
     */
    public JSONWriter Object() throws JSONException 
    {
        if (mode == 'i') {
            mode = 'o';
        }
        if (mode == 'o' || mode == 'a') {
            Append("{");
            Push(new JSONObject.Empty());
            comma = false;
            return this;
        }
        throw new JSONException.Exception("Misplaced object.");

    }


    /**
     * Pop an array or object scope.
     * @param c The scope to close.
     * @throws JSONException If nesting is wrong.
     */
    private void Pop(char c) throws JSONException 
    {
        if (top <= 0) {
            throw new JSONException.Exception("Nesting error.");
        }
        char m = stack[top - 1] == null ? 'a' : 'k';
        if (m != c) {
            throw new JSONException.Exception("Nesting error.");
        }
        top -= 1;
        mode = top == 0
            ? 'd'
            : stack[top - 1] == null
            ? 'a'
            : 'k';
    }

    /**
     * Push an array or object scope.
     * @param jo The scope to open.
     * @throws JSONException If nesting is too deep.
     */
    private void Push(JSONObject jo) throws JSONException 
    {
        if (top >= maxdepth) {
            throw new JSONException.Exception("Nesting too deep.");
        }
        stack[top] = jo;
        mode = jo == null ? 'a' : 'k';
        top += 1;
    }

    /**
     * Make a JSON text of an Object value. If the object has an
     * value.toJSONString() method, then that method will be used to produce the
     * JSON text. The method is required to produce a strictly conforming text.
     * If the object does not contain a toJSONString method (which is the most
     * common case), then a text will be produced by other means. If the value
     * is an array or Collection, then a JSONArray will be made from it and its
     * toJSONString method will be called. If the value is a MAP, then a
     * JSONObject will be made from it and its toJSONString method will be
     * called. Otherwise, the value's toString method will be called, and the
     * result will be quoted.
     *
     * <p>
     * Warning: This method assumes that the data structure is acyclical.
     *
     * @param value
     *            The value to be serialized.
     * @return a printable, displayable, transmittable representation of the
     *         object, beginning with <code>{</code>&nbsp;<small>(left
     *         brace)</small> and ending with <code>}</code>&nbsp;<small>(right
     *         brace)</small>.
     * @throws JSONException
     *             If the value is or contains an invalid number.
     */
    public static string ValueToString(Object value) throws JSONException 
    {
        if (value == null) {
            return "null";
        }
        if (value is JSONString) {
            Object object;
            try {
                object = ((JSONString) value).ToJSONString();
            } catch (Exception e) {
                throw new JSONException.Exception(e.message);
            }
            if (object is String) {
                return ((String) object).ToString();
            }
            throw new JSONException.Exception("Bad value from toJSONString: " + object.ToString());
        }
        if (value is Number) {
            // not all Numbers may match actual JSON Numbers. i.e. Fractions or Complex
            string numberAsString = JSONObject.NumberToString((Number) value);
            return numberAsString;
        }
        if (value is Boolean || value is JSONObject
                || value is JSONArray) {
            return value.ToString();
        }
        if (value is Dictionary) {
            Dictionary<string, Object> map = (Dictionary<string, Object>) value;
            return new JSONObject.Map(map).ToString();
        }
        if (value is ArrayList) {
            ArrayList<Object> coll = (ArrayList<Object>) value;
            return new JSONArray.Collection(coll).ToString();
        }
        return JSONObject.Quote(value.ToString());
    }

    /**
     * Append either the value <code>true</code> or the value
     * <code>false</code>.
     * @param b A bool.
     * @return this
     * @throws JSONException
     */
    public JSONWriter ValueBool(bool b) throws JSONException 
    {
        return Append(b ? "true" : "false");
    }

    /**
     * Append a double value.
     * @param d A double.
     * @return this
     * @throws JSONException If the number is not finite.
     */
    public JSONWriter ValueDouble(double d) throws JSONException 
    {
        return Append(d.to_string());
    }

    /**
     * Append a long value.
     * @param l A long.
     * @return this
     * @throws JSONException
     */
    public JSONWriter ValueLong(long l) throws JSONException 
    {
        return Append(l.to_string());
    }


    /**
     * Append an object value.
     * @param object The object to append. It can be null, or a Boolean, Number,
     *   string, JSONObject, or JSONArray, or an object that implements JSONString.
     * @return this
     * @throws JSONException If the value is out of sequence.
     */
    public JSONWriter ValueObject(Object object) throws JSONException 
    {
        return Append(ValueToString(object));
    }
}
