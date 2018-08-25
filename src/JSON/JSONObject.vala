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
using System.IO;
using System.Collections.Generic;
/**
 * A JSONObject is an unordered collection of name/value pairs. Its external
 * form is a string wrapped in curly braces with colons between the names and
 * values, and commas between the values and names. The internal form is an
 * object having <code>get</code> and <code>opt</code> methods for accessing
 * the values by name, and <code>put</code> methods for adding or replacing
 * values by name. The values can be any of these types: <code>Boolean</code>,
 * <code>JSONArray</code>, <code>JSONObject</code>, <code>Number</code>,
 * <code>string</code>, or the <code>JSONObject.NULL</code> object. A
 * JSONObject constructor can be used to convert an external form JSON text
 * into an internal form whose values can be retrieved with the
 * <code>get</code> and <code>opt</code> methods, or to convert values into a
 * JSON text using the <code>put</code> and <code>toString</code> methods. A
 * <code>get</code> method returns a value if one can be found, and throws an
 * exception if one cannot be found. An <code>opt</code> method returns a
 * default value instead of throwing an exception, and so is useful for
 * obtaining optional values.
 * <p>
 * The generic <code>get()</code> and <code>opt()</code> methods return an
 * object, which you can cast or query for type. There are also typed
 * <code>get</code> and <code>opt</code> methods that do type checking and type
 * coercion for you. The opt methods differ from the get methods in that they
 * do not throw. Instead, they return a specified value, such as null.
 * <p>
 * The <code>put</code> methods add or replace values in an object. For
 * example,
 *
 * <pre>
 * myString = new JSONObject()
 *         .Put(&quot;JSON&quot;, &quot;Hello, World!&quot;).ToString();
 * </pre>
 *
 * produces the string <code>{"JSON": "Hello, World"}</code>.
 * <p>
 * The texts produced by the <code>toString</code> methods strictly conform to
 * the JSON syntax rules. The constructors are more forgiving in the texts they
 * will accept:
 * <ul>
 * <li>An extra <code>,</code>&nbsp;<small>(comma)</small> may appear just
 * before the closing brace.</li>
 * <li>Strings may be quoted with <code>'</code>&nbsp;<small>(single
 * quote)</small>.</li>
 * <li>Strings do not need to be quoted at all if they do not begin with a
 * quote or single quote, and if they do not contain leading or trailing
 * spaces, and if they do not contain any of these characters:
 * <code>{ } [ ] / \ : , #</code> and if they do not look like numbers and
 * if they are not the reserved words <code>true</code>, <code>false</code>,
 * or <code>null</code>.</li>
 * </ul>
 *
 * @author JSON.org
 * @version 2016-08-15
 */
public class System.JSON.JSONObject : Object 
{
    /**
     * JSONObject.NULL is equivalent to the value that JavaScript calls null,
     * whilst Java's null is equivalent to the value that JavaScript calls
     * undefined.
     */
    public class Null : Object
    {

        /**
         * A Null object is equal to the null value and to itself.
         *
         * @param object
         *            An object to test for nullness.
         * @return true if the object parameter is the JSONObject.NULL object or
         *         null.
         */
        public override bool Equals(Object object) 
        {
            return object == null || object == this;
        }
        /**
         * A Null object is equal to the null value and to itself.
         *
         * @return always returns 0.
         */
        public override int GetHashCode() 
        {
            return 0;
        }

        /**
         * Get the "null" string value.
         *
         * @return The string "null".
         */
        public override string ToString() 
        {
            return "null";
        }
    }

    /**
     * The map where the JSONObject's properties are kept.
     */
    private Dictionary<string, Object> map;

    /**
     * It is sometimes more convenient and less ambiguous to have a
     * <code>NULL</code> object than to use Java's <code>null</code> value.
     * <code>JSONObject.NULL.equals(null)</code> returns <code>true</code>.
     * <code>JSONObject.NULL.ToString()</code> returns <code>"null"</code>.
     */
    public static Object NULL = new Null();

    /**
     * Construct an empty JSONObject.
     */
    public JSONObject.Empty() 
    {
        // HashMap is used on purpose to ensure that elements are unordered by 
        // the specification.
        // JSON tends to be a portable transfer format to allows the container 
        // implementations to rearrange their items for a faster element 
        // retrieval based on associative access.
        // Therefore, an implementation mustn't rely on the order of the item.
        map = new Dictionary<string, Object>();
    }

    /**
     * Construct a JSONObject from a subset of another JSONObject. An array of
     * strings is used to identify the keys that should be copied. Missing keys
     * are ignored.
     *
     * @param jo
     *            A JSONObject.
     * @param names
     *            An array of strings.
     */
    public JSONObject.Copy(JSONObject jo, string[] names) 
    {
        this.Empty();
        for (int i = 0; i < names.length; i += 1) {
            try {
                PutOnce(names[i], jo.Opt(names[i]));
            } catch (Exception ignore) {
            }
        }
    }

    /**
     * Construct a JSONObject from a JSONTokener.
     *
     * @param x
     *            A JSONTokener object containing the source string.
     * @throws JSONException
     *             If there is a syntax error in the source string or a
     *             duplicated key.
     */
    public JSONObject.Tokener(JSONTokener x) throws JSONException 
    {
        this.Empty();
        char c;
        string key;

        if (x.NextClean() != '{') {
            throw x.SyntaxError("A JSONObject text must begin with '{'");
        }
        for (;;) {
            c = x.NextClean();
            switch (c) {
            case 0:
                throw x.SyntaxError("A JSONObject text must end with '}'");
            case '}':
                return;
            default:
                x.Back();
                key = ((String)x.NextValue()).ToString();
                break;
            }

            // The key is followed by ':'.

            c = x.NextClean();
            if (c != ':') {
                throw x.SyntaxError("Expected a ':' after a key");
            }
            
            // Use syntaxError(..) to include error location
            
            if (key != null) {
                // Check if key exists
                if (Opt(key) != null) {
                    // key already exists
                    throw x.SyntaxError("Duplicate key \"" + key + "\"");
                }
                // Only add value if non-null
                Object value = x.NextValue();
                if (value!=null) {
                    this[key] = value;
                }
            }

            // Pairs are separated by ','.

            switch (x.NextClean()) {
            case ';':
            case ',':
                if (x.NextClean() == '}') {
                    return;
                }
                x.Back();
                break;
            case '}':
                return;
            default:
                throw x.SyntaxError("Expected a ',' or '}'");
            }
        }
    }

    /**
     * Construct a JSONObject from a Map.
     *
     * @param m
     *            A map object that can be used to initialize the contents of
     *            the JSONObject.
     * @throws JSONException
     *            If a value in the map is non-finite number.
     * @throws NullPointerException
     *            If a key in the map is <code>null</code>
     */
    public JSONObject.Map(Dictionary<string, Object> m) 
    {
        map = new Dictionary<string, Object>();
        foreach (var k in m.Keys) {
            if(k == null) {
                throw new Exception.NullPointerException("Null key.");
            }
            Object value = m[k];
            if (value != null) {
                map[k] = Wrap(value);
            }
        }
    }


    /**
     * Construct a JSONObject from a source JSON text string. This is the most
     * commonly used JSONObject constructor.
     *
     * @param source
     *            A string beginning with <code>{</code>&nbsp;<small>(left
     *            brace)</small> and ending with <code>}</code>
     *            &nbsp;<small>(right brace)</small>.
     * @exception JSONException
     *                If there is a syntax error in the source string or a
     *                duplicated key.
     */
    public JSONObject(string source) throws JSONException 
    {
        this.Tokener(new JSONTokener(source));
    }


    /**
     * Accumulate values under a key. It is similar to the put method except
     * that if there is already an object stored under the key then a JSONArray
     * is stored under the key to hold all of the accumulated values. If there
     * is already a JSONArray, then the new value is appended to it. In
     * contrast, the put method replaces the previous value.
     *
     * If only one value is accumulated that is not a JSONArray, then the result
     * will be the same as using put. But if multiple values are accumulated,
     * then the result will be like append.
     *
     * @param key
     *            A key string.
     * @param value
     *            An object to be accumulated under the key.
     * @return 
     * @throws JSONException
     *            If the value is non-finite number.
     * @throws NullPointerException
     *            If the key is <code>null</code>.
     */
    public JSONObject Accumulate(string key, Object value) throws JSONException 
    {
        TestValidity(value);
        Object object = Opt(key);
        if (object == null) {
            this[key] = (value is JSONArray) 
                        ? new JSONArray().Add(value)
                        : value;
        } else if (object is JSONArray) {
            ((JSONArray) object).Add(value);
        } else {
            this[key] = new JSONArray().Add(object).Add(value);
        }
        return this;
    }

    /**
     * Append values to the array under a key. If the key does not exist in the
     * JSONObject, then the key is put in the JSONObject with its value being a
     * JSONArray containing the value parameter. If the key was already
     * associated with a JSONArray, then the value parameter is appended to it.
     *
     * @param key
     *            A key string.
     * @param value
     *            An object to be accumulated under the key.
     * @return 
     * @throws JSONException
     *            If the value is non-finite number or if the current value associated with
     *             the key is not a JSONArray.
     * @throws NullPointerException
     *            If the key is <code>null</code>.
     */
    public JSONObject Append(string key, Object value) throws JSONException 
    {
        TestValidity(value);
        Object object = Opt(key);
        if (object == null) {
            this[key] = new JSONArray().Add(value);
        } else if (object is JSONArray) {
            this[key] = ((JSONArray) object).Add(value);
        } else {
            throw new JSONException.Exception(@"JSONObject[$key] is not a JSONArray.");
        }
        return this;
    }

    /**
     * Produce a string from a double. The string "null" will be returned if the
     * number is not finite.
     *
     * @param d
     *            A double.
     * @return A string.
     */
    public static string DoubleToString(double d) 
    {
        if (!d.is_finite() || d.is_nan()) {
            return "null";
        }

        // Shave off trailing zeros and decimal point, if possible.

        // string string = Double.ToString(d);
        string string = d.to_string();
        if (string.index_of(".") > 0 && string.index_of("e") < 0
                && string.index_of("E") < 0) {
            while (string.ends_with("0")) {
                string = string.substring(0, string.length - 1);
            }
            if (string.ends_with(".")) {
                string = string.substring(0, string.length - 1);
            }
        }
        return string;
    }

    /**
     * Get the value object associated with a key.
     *
     * @param key
     *            A key string.
     * @return The object associated with the key.
     * @throws JSONException
     *             if the key is not found.
     */
    public Object get(string key) throws JSONException 
    {
        if (key == null) {
            throw new JSONException.Exception("Null key.");
        }
        Object object = Opt(key);
        if (object == null) {
            throw new JSONException.Exception(@"JSONObject[$(Quote(key))] not found.");
        }
        return object;
    }

    /**
     * Get the bool value associated with a key.
     *
     * @param key
     *            A key string.
     * @return The truth.
     * @throws JSONException
     *             if the value is not a Boolean or the string "true" or
     *             "false".
     */
    public bool GetBoolean(string key) throws JSONException 
    {
        Object object = this[key];
        if (object.Equals(Boolean.FALSE)
                || (object is String) 
                && (object.ToString() == "false")) {
            return false;
        } else if (object.Equals(Boolean.TRUE)
                || (object is String) 
                && (object.ToString() == "true")) {
            return true;
        }
        throw new JSONException.Exception("JSONObject[$(Quote(key))] is not a Boolean.");
    }


    /**
     * Get the double value associated with a key.
     *
     * @param key
     *            A key string.
     * @return The numeric value.
     * @throws JSONException
     *             if the key is not found or if the value is not a Number
     *             object and cannot be converted to a number.
     */
    public double GetDouble(string key) throws JSONException 
    {
        Object object = this[key];
        try {
            return (object is Number) 
                    ? ((Number) object).DoubleValue()
                    : Double.ParseDouble(object.ToString());
        } catch (Exception e) {
            throw new JSONException.Exception(@"JSONObject[$(Quote(key))] is not a number.");
        }
    }

    /**
     * Get the float value associated with a key.
     *
     * @param key
     *            A key string.
     * @return The numeric value.
     * @throws JSONException
     *             if the key is not found or if the value is not a Number
     *             object and cannot be converted to a number.
     */
    public float GetFloat(string key) throws JSONException 
    {
        Object object = this[key];
        try {
            return (object is Number) 
                    ? ((Number) object).FloatValue()
                    : Float.ParseFloat(object.ToString());
        } catch (Exception e) {
            throw new JSONException.Exception(@"JSONObject[$(Quote(key))] is not a number.");
        }
    }

    /**
     * Get the int value associated with a key.
     *
     * @param key
     *            A key string.
     * @return The integer value.
     * @throws JSONException
     *             if the key is not found or if the value cannot be converted
     *             to an integer.
     */
    public int GetInt(string key) throws JSONException 
    {
        Object object = this[key];
        try {
            return (object is Number)
                    ? ((Number) object).IntValue()
                    : Integer.ParseInt((string) object);
        } catch (Exception e) {
            throw new JSONException.Exception(@"JSONObject[$(Quote(key))] is not an int.");
        }
    }

    /**
     * Get the JSONArray value associated with a key.
     *
     * @param key
     *            A key string.
     * @return A JSONArray which is the value.
     * @throws JSONException
     *             if the key is not found or if the value is not a JSONArray.
     */
    public JSONArray GetJSONArray(string key) throws JSONException 
    {
        Object object = this[key];
        if (object is JSONArray) {
            return (JSONArray) object;
        }
        throw new JSONException.Exception(@"JSONObject[$(Quote(key))] is not a JSONArray.");
    }

    /**
     * Get the JSONObject value associated with a key.
     *
     * @param key
     *            A key string.
     * @return A JSONObject which is the value.
     * @throws JSONException
     *             if the key is not found or if the value is not a JSONObject.
     */
    public JSONObject GetJSONObject(string key) throws JSONException 
    {
        Object object = this[key];
        if (object is JSONObject) {
            return (JSONObject) object;
        }
        throw new JSONException.Exception(@"JSONObject[$(Quote(key))] is not a JSONObject.");
    }

    /**
     * Get the long value associated with a key.
     *
     * @param key
     *            A key string.
     * @return The long value.
     * @throws JSONException
     *             if the key is not found or if the value cannot be converted
     *             to a long.
     */
    public long GetLong(string key) throws JSONException 
    {
        Object object = this[key];
        try {
            return (object is Number) 
                    ? ((Number) object).LongValue()
                    : Long.ParseLong((string) object);
        } catch (Exception e) {
            throw new JSONException.Exception(@"JSONObject[$(Quote(key))] is not a long.");
        }
    }

    /**
     * Get an array of field names from a JSONObject.
     *
     * @return An array of field names, or null if there are no names.
     */
    public static string[] GetNames(JSONObject jo) 
    {
        if (jo.IsEmpty()) {
            return null;
        }
        return jo.KeySet().ToArray();
    }

    /**
     * Get the string associated with a key.
     *
     * @param key
     *            A key string.
     * @return A string which is the value.
     * @throws JSONException
     *             if there is no string value for the key.
     */
    public String GetString(string key) throws JSONException 
    {
        Object object = this[key];
        if (object is String) {
            return ((String) object);//.ToString();
        }
        throw new JSONException.Exception("JSONObject[$(Quote(key))] not a string.");
    }

    /**
     * Determine if the JSONObject contains a specific key.
     *
     * @param key
     *            A key string.
     * @return true if the key exists in the JSONObject.
     */
    public bool Has(string key) 
    {
        return map.ContainsKey(key);
    }

    /**
     * Increment a property of a JSONObject. If there is no such property,
     * create one with a value of 1. If there is such a property, and if it is
     * an Integer, Long, Double, or Float, then add one to it.
     *
     * @param key
     *            A key string.
     * @return 
     * @throws JSONException
     *             If there is already a property with this name that is not an
     *             Integer, Long, Double, or Float.
     */
    public JSONObject Increment(string key) throws JSONException 
    {
        Object value = Opt(key);
        if (value == null) {
            this[key] = new Integer(1);
        } else if (value is Integer) {
            this[key] = new Integer(((Integer) value).IntValue() + 1);
        } else if (value is Long) {
            this[key] = new Long(((Long) value).LongValue() + 1L);
        } else if (value is Double) {
            this[key] = new Double(((Double) value).DoubleValue() + 1d);
        } else if (value is Float) {
            this[key] = new Float(((Float) value).FloatValue() + 1f);
        } else {
            throw new JSONException.Exception("Unable to increment [${Quote(key)}.");
        }
        return this;
    }

    /**
     * Determine if the value associated with the key is <code>null</code> or if there is no
     * value.
     *
     * @param key
     *            A key string.
     * @return true if there is no value associated with the key or if the value
     *        is the JSONObject.NULL object.
     */
    public bool IsNull(string key) 
    {
        return JSONObject.NULL.Equals(Opt(key));
    }

    /**
     * Get an enumeration of the keys of the JSONObject. Modifying this key Set will also
     * modify the JSONObject. Use with caution.
     *
     * @see Set#iterator()
     * 
     * @return An iterator of the keys.
     */
    public Iterator<string> keys() 
    {
        return KeySet().iterator();
    }

    /**
     * Get a set of keys of the JSONObject. Modifying this key Set will also modify the
     * JSONObject. Use with caution.
     *
     * @see Map#keySet()
     *
     * @return A keySet.
     */
    public Set<string> KeySet() 
    {
        return map.Keys;
    }

    /**
     * Get a set of entries of the JSONObject. These are raw values and may not
     * match what is returned by the JSONObject get* and opt* functions. Modifying 
     * the returned EntrySet or the Entry objects contained therein will modify the
     * backing JSONObject. This does not return a clone or a read-only view.
     * 
     * Use with caution.
     *
     * @see Map#entrySet()
     *
     * @return An Entry Set
     */
    protected Collection<Object> EntrySet() 
    {
        return map.Values;
    }

    /**
     * Get the number of keys stored in the JSONObject.
     *
     * @return The number of keys in the JSONObject.
     */
    public int Length() 
    {
        return map.Count;
    }

    /**
     * Check if JSONObject is empty.
     *
     * @return true if JSONObject is empty, otherwise false.
     */
    public bool IsEmpty() 
    {
        return map.Count == 0;
    }

    /**
     * Produce a JSONArray containing the names of the elements of this
     * JSONObject.
     *
     * @return A JSONArray containing the key strings, or null if the JSONObject
     *        is empty.
     */
    public JSONArray Names() 
    {
    	if(map.Count == 0) {
    		return null;
    	}
        Object[] names = new Object[map.Count];
        int i=0;
        foreach (var name in map.Keys)
            names[i++] = (Object)new String(name);
        return new JSONArray.Array(names);
    }

    /**
     * Produce a string from a Number.
     *
     * @param number
     *            A Number
     * @return A string.
     * @throws JSONException
     *             If n is a non-finite number.
     */
    public static string NumberToString(Number number) throws JSONException 
    {
        if (number == null) {
            throw new JSONException.Exception("Null pointer");
        }
        TestValidity(number);

        // Shave off trailing zeros and decimal point, if possible.

        string string = number.ToString();
        if (string.index_of(".") > 0 && string.index_of("e") < 0
                && string.index_of("E") < 0) {
            while (string.ends_with("0")) {
                string = string.substring(0, string.length - 1);
            }
            if (string.ends_with(".")) {
                string = string.substring(0, string.length - 1);
            }
        }
        return string;
    }

    /**
     * Get an optional value associated with a key.
     *
     * @param key
     *            A key string.
     * @return An object which is the value, or null if there is no value.
     */
    public Object Opt(string key) 
    {
        return key == null ? null : map[key];
    }

    /**
     * Get an optional bool associated with a key. It returns the
     * defaultValue if there is no such key, or if it is not a Boolean or the
     * string "true" or "false" (case insensitive).
     *
     * @param key
     *            A key string.
     * @param defaultValue
     *            The default.
     * @return The truth.
     */
    public bool OptBoolean(string key, bool defaultValue = false) 
    {
        Object val = Opt(key);
        if (NULL.Equals(val)) {
            return defaultValue;
        }
        if (val is Boolean){
            return ((Boolean) val).BooleanValue();
        }
        try {
            // we'll use the get anyway because it does string conversion.
            return GetBoolean(key);
        } catch (Exception e) {
            return defaultValue;
        }
    }

    /**
     * Get an optional double associated with a key, or the defaultValue if
     * there is no such key or if its value is not a number. If the value is a
     * string, an attempt will be made to evaluate it as a number.
     *
     * @param key
     *            A key string.
     * @param defaultValue
     *            The default.
     * @return An object which is the value.
     */
    public double OptDouble(string key, double defaultValue = double.NAN) 
    {
        Object val = Opt(key);
        if (NULL.Equals(val)) {
            return defaultValue;
        }
        if (val is Number){
            return ((Number) val).DoubleValue();
        }
        if (val is String){
            try {
                return Double.ParseDouble(((String) val).ToString());
            } catch (Exception e) {
                return defaultValue;
            }
        }
        return defaultValue;
    }


    /**
     * Get the optional double value associated with an index. The defaultValue
     * is returned if there is no value for the index, or if the value is not a
     * number and cannot be converted to a number.
     *
     * @param key
     *            A key string.
     * @param defaultValue
     *            The default value.
     * @return The value.
     */
    public float OptFloat(string key, float defaultValue = float.NAN) 
    {
        Object val = Opt(key);
        if (JSONObject.NULL.Equals(val)) {
            return defaultValue;
        }
        if (val is Number){
            return ((Number) val).FloatValue();
        }
        if (val is String){
            try {
                return Float.ParseFloat(((String) val).ToString());
            } catch (Exception e) {
                return defaultValue;
            }
        }
        return defaultValue;
    }

    /**
     * Get an optional int value associated with a key, or the default if there
     * is no such key or if the value is not a number. If the value is a string,
     * an attempt will be made to evaluate it as a number.
     *
     * @param key
     *            A key string.
     * @param defaultValue
     *            The default.
     * @return An object which is the value.
     */
    public int OptInt(string key, int defaultValue = 0) 
    {
        Object val = Opt(key);
        if (NULL.Equals(val)) {
            return defaultValue;
        }
        if (val is Number){
            return ((Number) val).IntValue();
        }
        
        if (val is String){
            try {
                return Integer.ParseInt(((String) val).ToString());
            } catch (Exception e) {
                return defaultValue;
            }
        }
        return defaultValue;
    }

    /**
     * Get an optional JSONArray associated with a key. It returns null if there
     * is no such key, or if its value is not a JSONArray.
     *
     * @param key
     *            A key string.
     * @return A JSONArray which is the value.
     */
    public JSONArray OptJSONArray(string key) 
    {
        Object o = Opt(key);
        return o as JSONArray;
    }

    /**
     * Get an optional JSONObject associated with a key. It returns null if
     * there is no such key, or if its value is not a JSONObject.
     *
     * @param key
     *            A key string.
     * @return A JSONObject which is the value.
     */
    public JSONObject OptJSONObject(string key) 
    {
        Object o = Opt(key);
        return o as JSONObject;
    }


    /**
     * Get an optional long value associated with a key, or the default if there
     * is no such key or if the value is not a number. If the value is a string,
     * an attempt will be made to evaluate it as a number.
     *
     * @param key
     *            A key string.
     * @param defaultValue
     *            The default.
     * @return An object which is the value.
     */
    public long OptLong(string key, long defaultValue = 0) 
    {
        Object val = Opt(key);
        if (NULL.Equals(val)) {
            return defaultValue;
        }
        if (val is Number){
            return ((Number) val).LongValue();
        }
        
        if (val is String){
            try {
                return Long.ParseLong(((String) val).ToString());
            } catch (Exception e) {
                return defaultValue;
            }
        }
        return defaultValue;
    }
    
    /**
     * Get an optional {@link Number} value associated with a key, or the default if there
     * is no such key or if the value is not a number. If the value is a string,
     * an attempt will be made to evaluate it as a number. This method
     * would be used in cases where type coercion of the number value is unwanted.
     *
     * @param key
     *            A key string.
     * @param defaultValue
     *            The default.
     * @return An object which is the value.
     */
    public Number OptNumber(string key, Number defaultValue = null) 
    {
        Object val = Opt(key);
        if (NULL.Equals(val)) {
            return defaultValue;
        }
        if (val is Number){
            return (Number) val;
        }
        
        if (val is String){
            try {
                return StringToNumber(((String) val).ToString());
            } catch (Exception e) {
                return defaultValue;
            }
        }
        return defaultValue;
    }
    
    /**
     * Get an optional string associated with a key. It returns the defaultValue
     * if there is no such key.
     *
     * @param key
     *            A key string.
     * @param defaultValue
     *            The default.
     * @return A string which is the value.
     */
    public string OptString(string key, string defaultValue = "") 
    {
        Object object = Opt(key);
        return NULL.Equals(object) ? defaultValue : object.ToString();
    }

    /**
     * Put a key/bool pair in the JSONObject.
     *
     * @param key
     *            A key string.
     * @param value
     *            A bool which is the value.
     * @return 
     * @throws JSONException
     *            If the value is non-finite number.
     * @throws NullPointerException
     *            If the key is <code>null</code>.
     */
    public JSONObject PutBoolean(string key, bool value) throws JSONException 
    {
        this[key] = value ? Boolean.TRUE : Boolean.FALSE;
        return this;
    }

    /**
     * Put a key/value pair in the JSONObject, where the value will be a
     * JSONArray which is produced from a Collection.
     *
     * @param key
     *            A key string.
     * @param value
     *            A Collection value.
     * @return 
     * @throws JSONException
     *            If the value is non-finite number.
     * @throws NullPointerException
     *            If the key is <code>null</code>.
     */
    public JSONObject PutCollection(string key, Collection<Object> value) throws JSONException 
    {
        this[key] = new JSONArray.Collection(value);
        return this;
    }

    /**
     * Put a key/double pair in the JSONObject.
     *
     * @param key
     *            A key string.
     * @param value
     *            A double which is the value.
     * @return 
     * @throws JSONException
     *            If the value is non-finite number.
     * @throws NullPointerException
     *            If the key is <code>null</code>.
     */
    public JSONObject PutDouble(string key, double value) throws JSONException 
    {
        this[key] = Double.Value(value);
        return this;
    }
    // public static Double valueOf(String s) throws NumberFormatException {
    //     return new Double(parseDouble(s));
    // }
    
    /**
     * Put a key/float pair in the JSONObject.
     *
     * @param key
     *            A key string.
     * @param value
     *            A float which is the value.
     * @return 
     * @throws JSONException
     *            If the value is non-finite number.
     * @throws NullPointerException
     *            If the key is <code>null</code>.
     */
    public JSONObject PutFloat(string key, float value) throws JSONException 
    {
        this[key] = Float.Value(value);
        return this;
    }

    /**
     * Put a key/int pair in the JSONObject.
     *
     * @param key
     *            A key string.
     * @param value
     *            An int which is the value.
     * @return 
     * @throws JSONException
     *            If the value is non-finite number.
     * @throws NullPointerException
     *            If the key is <code>null</code>.
     */
    public JSONObject PutInt(string key, int value) throws JSONException 
    {
        this[key] = Integer.Value(value);
        return this;
    }

    /**
     * Put a key/long pair in the JSONObject.
     *
     * @param key
     *            A key string.
     * @param value
     *            A long which is the value.
     * @return 
     * @throws JSONException
     *            If the value is non-finite number.
     * @throws NullPointerException
     *            If the key is <code>null</code>.
     */
    public JSONObject PutLong(string key, long value) throws JSONException 
    {
        this[key] = Long.Value(value);
        return this;
    }

    /**
     * Put a key/value pair in the JSONObject, where the value will be a
     * JSONObject which is produced from a Map.
     *
     * @param key
     *            A key string.
     * @param value
     *            A Map value.
     * @return 
     * @throws JSONException
     *            If the value is non-finite number.
     * @throws NullPointerException
     *            If the key is <code>null</code>.
     */
    public JSONObject PutDict(string key, Dictionary<string, Object> value) throws JSONException 
    {
        this[key] = new JSONObject.Map(value);
        return this;
    }

    /**
     * Put a key/value pair in the JSONObject. If the value is <code>null</code>, then the
     * key will be removed from the JSONObject if it is present.
     *
     * @param key
     *            A key string.
     * @param value
     *            An object which is the value. It should be of one of these
     *            types: Boolean, Double, Integer, JSONArray, JSONObject, Long,
     *            string, or the JSONObject.NULL object.
     * @return 
     * @throws JSONException
     *            If the value is non-finite number.
     * @throws NullPointerException
     *            If the key is <code>null</code>.
     */
    public void set(string key, Object value) throws JSONException 
    {
        if (key == null) {
            throw new Exception.NullPointerException("Null key.");
        }
        if (value != null) {
            TestValidity(value);
            map[key] = value;
        } else {
            Remove(key);
        }
    }

    public JSONObject Put(string key, Object value) throws JSONException
    {
        this[key] = value;
        return this;
    }

    /**
     * Put a key/value pair in the JSONObject, but only if the key and the value
     * are both non-null, and only if there is not already a member with that
     * name.
     *
     * @param key string
     * @param value object
     * @return 
     * @throws JSONException
     *             if the key is a duplicate
     */
    public JSONObject PutOnce(string key, Object value) throws JSONException 
    {
        if (key != null && value != null) {
            if (Opt(key) != null) {
                throw new JSONException.Exception("Duplicate key \"" + key + "\"");
            }
            this[key] = value;
            return (JSONObject)value;
        }
        return this;
    }

    /**
     * Put a key/value pair in the JSONObject, but only if the key and the value
     * are both non-null.
     *
     * @param key
     *            A key string.
     * @param value
     *            An object which is the value. It should be of one of these
     *            types: Boolean, Double, Integer, JSONArray, JSONObject, Long,
     *            string, or the JSONObject.NULL object.
     * @return 
     * @throws JSONException
     *             If the value is a non-finite number.
     */
    public JSONObject PutOpt(string key, Object value) throws JSONException 
    {
        if (key != null && value != null) {
            this[key] = value;
        }
        return this;
    }

    /**
     * Creates a JSONPointer using an initialization string and tries to 
     * match it to an item within this JSONObject. For example, given a
     * JSONObject initialized with this document:
     * <pre>
     * {
     *     "a":{"b":"c"}
     * }
     * </pre>
     * and this JSONPointer string: 
     * <pre>
     * "/a/b"
     * </pre>
     * Then this method will return the string "c".
     * A JSONPointerException may be thrown from code called by this method.
     *   
     * @param jsonPointer string that can be used to create a JSONPointer
     * @return the item matched by the JSONPointer, otherwise null
     */
    public Object Query(string jsonPointer) 
    {
        return QueryPtr(new JSONPointer(jsonPointer));
    }
    /**
     * Uses a user initialized JSONPointer  and tries to 
     * match it to an item within this JSONObject. For example, given a
     * JSONObject initialized with this document:
     * <pre>
     * {
     *     "a":{"b":"c"}
     * }
     * </pre>
     * and this JSONPointer: 
     * <pre>
     * "/a/b"
     * </pre>
     * Then this method will return the string "c".
     * A JSONPointerException may be thrown from code called by this method.
     *   
     * @param jsonPointer string that can be used to create a JSONPointer
     * @return the item matched by the JSONPointer, otherwise null
     */
    public Object QueryPtr(JSONPointer jsonPointer) 
    {
        return jsonPointer.QueryFrom(this);
    }
    
    /**
     * Queries and returns a value from this object using {@code jsonPointer}, or
     * returns null if the query fails due to a missing key.
     * 
     * @param jsonPointer the string representation of the JSON pointer
     * @return the queried value or {@code null}
     * @throws IllegalArgumentException if {@code jsonPointer} has invalid syntax
     */
    public Object OptQuery(string jsonPointer) 
    {
    	return OptQueryPtr(new JSONPointer(jsonPointer));
    }
    
    /**
     * Queries and returns a value from this object using {@code jsonPointer}, or
     * returns null if the query fails due to a missing key.
     * 
     * @param jsonPointer The JSON pointer
     * @return the queried value or {@code null}
     * @throws IllegalArgumentException if {@code jsonPointer} has invalid syntax
     */
    public Object OptQueryPtr(JSONPointer jsonPointer) 
    {
        try {
            return jsonPointer.QueryFrom(this);
        } catch (JSONException.PointerException e) {
            return null;
        }
    }

    /**
     * Produce a string in double quotes with backslash sequences in all the
     * right places. A backslash will be inserted within </, producing <\/,
     * allowing JSON text to be delivered in HTML. In JSON text, a string cannot
     * contain a control character or an unescaped quote or backslash.
     *
     * @param string
     *            A string
     * @return A string correctly formatted for insertion in a JSON text.
     */
    public static string Quote(string string) 
    {
        var sw = new StringWriter();
        return QuoteWriter(string, sw).ToString();
    }

    public static Writer QuoteWriter(string string, Writer w) throws IOException 
    {
        if (string == null || string == "") {
            w.Append("\"\"");
            return w;
        }

        char b;
        char c = 0;
        string hhhh;
        int i;
        int len = string.length;

        w.AppendChar('"');
        for (i = 0; i < len; i += 1) {
            b = c;
            c = string[i];
            switch (c) {
            case '\\':
            case '"':
                w.AppendChar('\\');
                w.AppendChar(c);
                break;
            case '/':
                if (b == '<') {
                    w.AppendChar('\\');
                }
                w.AppendChar(c);
                break;
            case '\b':
                w.Append("\\b");
                break;
            case '\t':
                w.Append("\\t");
                break;
            case '\n':
                w.Append("\\n");
                break;
            case '\f':
                w.Append("\\f");
                break;
            case '\r':
                w.Append("\\r");
                break;
            default:
                w.AppendChar(c);
                break;
            }
        }
        w.AppendChar('"');
        return w;
    }

    /**
     * Remove a name and its value, if present.
     *
     * @param key
     *            The name to be removed.
     * @return The value that was associated with the name, or null if there was
     *         no value.
     */
    public Object? Remove(string key) 
    {
        Object? result = null;
        if (map.ContainsKey(key))
        {
            result = map[key];
            map.Remove(key);
        }
        return result;
    }

    /**
     * Determine if two JSONObjects are similar.
     * They must contain the same set of names which must be associated with
     * similar values.
     *
     * @param other The other JSONObject
     * @return true if they are equal
     */
    public bool Similar(Object other) 
    {
        try {
            if (!(other is JSONObject)){
                return false;
            }
            if (!KeySet().Equals(((JSONObject)other).KeySet())) {
                return false;
            }
            foreach (var name in KeySet()) {
                Object valueThis = Opt(name);
                Object valueOther = ((JSONObject)other)[name];
                if(valueThis == valueOther) {
                	continue;
                }
                if(valueThis == null) {
                	return false;
                }
                if (valueThis is JSONObject){
                    if (!((JSONObject)valueThis).Similar(valueOther)) {
                        return false;
                    }
                } else if (valueThis is JSONArray){
                    if (!((JSONArray)valueThis).Similar(valueOther)) {
                        return false;
                    }
                } else if (!valueThis.Equals(valueOther)) {
                    return false;
                }
            }
            return true;
        } catch (Error exception) {
            return false;
        }
    }
    
    /**
     * Tests if the value should be tried as a decimal. It makes no test if there are actual digits.
     * 
     * @param val value to test
     * @return true if the string is "-0" or if it contains '.', 'e', or 'E', false otherwise.
     */
    protected static bool IsDecimalNotation(string val) 
    {
        return val.index_of(".") > -1 || val.index_of("e") > -1
                || val.index_of("E") > -1 || "-0" == val;
    }
    
    /**
     * Converts a string to a number using the narrowest possible type. Possible 
     * returns for this function are BigDecimal, Double, BigInteger, Long, and Integer.
     * When a Double is returned, it should always be a valid Double and not NaN or +-infinity.
     * 
     * @param val value to convert
     * @return Number representation of the value.
     * @throws NumberFormatException thrown if the value is not a valid number. A public
     *      caller should catch this and wrap it in a {@link JSONException} if applicable.
     */
    internal static Number StringToNumber(string val) throws Exception 
    {
        char initial = val[0];
        if ((initial >= '0' && initial <= '9') || initial == '-') {
            // decimal representation
            if (IsDecimalNotation(val)) {
                Double d = Double.ValueOf(val);
                // if (d.is_infinity() || d.is_nan()) {
                //     // if we can't parse it as a double, go up to BigDecimal
                //     // this is probably due to underflow like 4.32e-678
                //     // or overflow like 4.65e5324. The size of the string is small
                //     // but can't be held in a Double.
                //     return new Double(val);
                // }
                return d;
            }
            // integer representation.
            // This will narrow any values to the smallest reasonable Object representation
            // (Integer, Long, or BigInteger)
            
            // string version
            // The compare string length method reduces GC,
            // but leads to smaller integers being placed in larger wrappers even though not
            // needed. i.e. 1,000,000,000 -> Long even though it's an Integer
            // 1,000,000,000,000,000,000 -> BigInteger even though it's a Long
            //if(val.length()<=9){
            //    return Integer.valueOf(val);
            //}
            //if(val.length()<=18){
            //    return Long.valueOf(val);
            //}
            //return new BigInteger(val);
            
            // BigInteger version: We use a similar bitLenth compare as
            // BigInteger#intValueExact uses. Increases GC, but objects hold
            // only what they need. i.e. Less runtime overhead if the value is
            // long lived. Which is the better tradeoff? This is closer to what's
            // in stringToValue.
            return Long.ValueOf(val);
        }
        throw new Exception.NumberFormatException(@"val [$val] is not a valid number.");
    }

    /**
     * Try to convert a string into a number, bool, or null. If the string
     * can't be converted, return the string.
     *
     * @param string
     *            A string.
     * @return A simple JSON value.
     */
    // Changes to this method must be copied to the corresponding method in
    // the XML class to keep full support for Android
    public static Object StringToValue(string string) 
    {
        if (string == "") {
            return new String(string);
        }
        if (string.down() == "true") {
            return Boolean.TRUE;
        }
        if (string.down() == "false") {
            return Boolean.FALSE;
        }
        if (string.down() == "null") {
            return JSONObject.NULL;
        }

        /*
         * If it might be a number, try converting it. If a number cannot be
         * produced, then the value will just be a string.
         */

        char initial = string[0];
        if ((initial >= '0' && initial <= '9') || initial == '-') {
            try {
                // if we want full Big Number support this block can be replaced with:
                // return stringToNumber(string);
                if (IsDecimalNotation(string)) {
                    Double d = Double.ValueOf(string);
                    if (!d.IsInfinite() && !d.IsNaN()) {
                        return d;
                    }
                } else {
                    Long myLong = Long.ValueOf(string);
                    if (string == myLong.ToString()) {
                        if (myLong.LongValue() == myLong.IntValue()) {
                            return Integer.Value(myLong.IntValue());
                        }
                        return myLong;
                    }
                }
            } catch (Exception ignore) {
            }
        }
        return new String(string);
    }

    /**
     * Throw an exception if the object is a NaN or infinite number.
     *
     * @param o
     *            The object to test.
     * @throws JSONException
     *             If o is a non-finite number.
     */
    public static void TestValidity(Object o) throws JSONException 
    {
        if (o != null) {
            if (o is Double) { 
                if (((Double) o).IsInfinite() || ((Double) o).IsNaN()) {
                    throw new JSONException.Exception(
                            "JSON does not allow non-finite numbers.");
                }
            } else if (o is Float) { 
                if (((Float) o).IsInfinite() || ((Float) o).IsNaN()) {
                    throw new JSONException.Exception(
                            "JSON does not allow non-finite numbers.");
                }
            }
        }
    }

    /**
     * Produce a JSONArray containing the values of the members of this
     * JSONObject.
     *
     * @param names
     *            A JSONArray containing a list of key strings. This determines
     *            the sequence of the values in the result.
     * @return A JSONArray of values.
     * @throws JSONException
     *             If any of the values are non-finite numbers.
     */
    public JSONArray ToJSONArray(JSONArray names) throws JSONException 
    {
        if (names == null || names.IsEmpty()) {
            return null;
        }
        JSONArray ja = new JSONArray();
        for (int i = 0; i < names.Length(); i += 1) {
            ja.Add(Opt(names.GetString(i).ToString()));
        }
        return ja;
    }

    /**
     * Make a JSON text of this JSONObject. For compactness, no whitespace is
     * added. If this would not result in a syntactically correct JSON text,
     * then null will be returned instead.
     * <p><b>
     * Warning: This method assumes that the data structure is acyclical.
     * </b>
     * 
     * @return a printable, displayable, portable, transmittable representation
     *         of the object, beginning with <code>{</code>&nbsp;<small>(left
     *         brace)</small> and ending with <code>}</code>&nbsp;<small>(right
     *         brace)</small>.
     */
    // public override string ToString() 
    // {
    //     return ToString2(0);
    // }

    public override string ToString() 
    {
        StringWriter w = new StringWriter();
        return Write(w, 0, 0).ToString();
    }
    /**
     * Make a pretty-printed JSON text of this JSONObject.
     * 
     * <p>If <code>indentFactor > 0</code> and the {@link JSONObject}
     * has only one key, then the object will be output on a single line:
     * <pre>{@code {"key": 1}}</pre>
     * 
     * <p>If an object has 2 or more keys, then it will be output across
     * multiple lines: <code><pre>{
     *  "key1": 1,
     *  "key2": "value 2",
     *  "key3": 3
     * }</pre></code>
     * <p><b>
     * Warning: This method assumes that the data structure is acyclical.
     * </b>
     *
     * @param indentFactor
     *            The number of spaces to add to each level of indentation.
     * @return a printable, displayable, portable, transmittable representation
     *         of the object, beginning with <code>{</code>&nbsp;<small>(left
     *         brace)</small> and ending with <code>}</code>&nbsp;<small>(right
     *         brace)</small>.
     * @throws JSONException
     *             If the object contains an invalid number.
     */
    private string ToString2(int indentFactor) throws JSONException 
    {
        StringWriter w = new StringWriter();
        return Write(w, indentFactor, 0).ToString();
    }

    /**
     * Make a JSON text of an Object value. If the object has an
     * value.ToJSONString() method, then that method will be used to produce the
     * JSON text. The method is required to produce a strictly conforming text.
     * If the object does not contain a ToJSONString method (which is the most
     * common case), then a text will be produced by other means. If the value
     * is an array or Collection, then a JSONArray will be made from it and its
     * ToJSONString method will be called. If the value is a MAP, then a
     * JSONObject will be made from it and its ToJSONString method will be
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
    	// moves the implementation to JSONWriter as:
    	// 1. It makes more sense to be part of the writer class
    	// 2. For Android support this method is not available. By implementing it in the Writer
    	//    Android users can use the writer with the built in Android JSONObject implementation.
        return JSONWriter.ValueToString(value);
    }

    /**
     * Wrap an object, if necessary. If the object is <code>null</code>, return the NULL
     * object. If it is an array or collection, wrap it in a JSONArray. If it is
     * a map, wrap it in a JSONObject. If it is a standard property (Double,
     * string, et al) then it is already wrapped. Otherwise, if it comes from
     * one of the java packages, turn it into a string. And if it doesn't, try
     * to wrap it in a JSONObject. If the wrapping fails, then null is returned.
     *
     * @param object
     *            The object to wrap
     * @return The wrapped value
     */
    public static Object Wrap(Object object) 
    {
        try {
            if (object == null) {
                return NULL;
            }
            if (NULL.Equals(object)
                    || object is JSONObject
                    || object is JSONArray
                    || object is JSONString
                    || object is Character
                    || object is Short
                    || object is Integer
                    || object is Long
                    || object is Boolean
                    || object is Float
                    || object is Double
                    || object is String) {
                return object;
            }

            if (object is Collection) {
                Collection<Object> coll = (Collection<Object>) object;
                return new JSONArray.Collection(coll);
            }
            if (object is Dictionary) {
                Dictionary<string, Object> map = (Dictionary<string, Object>) object;
                return new JSONObject.Map(map);
            }
            return null; //new JSONObject(object);
        } catch (Exception exception) {
            return null;
        }
    }

    public static Writer WriteValue(
        Writer writer, 
        Object value,
        int indentFactor, 
        int indent
        ) throws JSONException, IOException 
    {
        if (value == null || value.Equals(null)) {
            writer.Append("null");
        } else if (value is JSONString) {
            Object o;
            try {
                o = ((JSONString) value).ToJSONString();
            } catch (Exception e) {
                throw new JSONException.Exception(e.message);
            }
            writer.Append(o != null ? o.ToString() : Quote(value.ToString()));
        } else if (value is Number) {
            // not all Numbers may match actual JSON Numbers. i.e. fractions or Imaginary
            string numberAsString = NumberToString((Number) value);
            writer.Append(numberAsString);
        } else if (value is Boolean) {
            writer.Append(value.ToString());
        } else if (value is JSONObject) {
            ((JSONObject) value).Write(writer, indentFactor, indent);
        } else if (value is JSONArray) {
            ((JSONArray) value).Write(writer, indentFactor, indent);
        } else if (value is Dictionary) {
            Dictionary<string, Object> map = (Dictionary<string, Object>) value;
            new JSONObject.Map(map).Write(writer, indentFactor, indent);
        } else if (value is Collection) {
            Collection<Object> coll = (Collection<Object>) value;
            new JSONArray.Collection(coll).Write(writer, indentFactor, indent);
        } else {
            QuoteWriter(value.ToString(), writer);
        }
        return writer;
    }

    public static void Indent(Writer writer, int indent) throws IOException 
    {
        for (int i = 0; i < indent; i += 1) {
            writer.AppendChar(' ');
        }
    }

    /**
     * Write the contents of the JSONObject as JSON text to a writer.
     * 
     * <p>If <code>indentFactor > 0</code> and the {@link JSONObject}
     * has only one key, then the object will be output on a single line:
     * <pre>{@code {"key": 1}}</pre>
     * 
     * <p>If an object has 2 or more keys, then it will be output across
     * multiple lines: <code><pre>{
     *  "key1": 1,
     *  "key2": "value 2",
     *  "key3": 3
     * }</pre></code>
     * <p><b>
     * Warning: This method assumes that the data structure is acyclical.
     * </b>
     *
     * @param writer
     *            Writes the serialized JSON
     * @param indentFactor
     *            The number of spaces to add to each level of indentation.
     * @param indent
     *            The indentation of the top level.
     * @return The writer.
     * @throws JSONException
     */
    public Writer Write(Writer writer, int indentFactor = 0, int indent = 0)
            throws JSONException 
    {
        try {
            bool commanate = false;
            int length = Length();
            writer.AppendChar('{');

            if (length == 1) {
                var it = KeySet().iterator();
                it.next();
                string key = it.get();
                writer.Append(Quote(key));
                writer.AppendChar(':');
                if (indentFactor > 0) {
                    writer.AppendChar(' ');
                }
                try{
                    WriteValue(writer, Opt(key), indentFactor, indent);
                } catch (Exception e) {
                    throw new JSONException.Exception("Unable to write JSONObject value for key: " + key, e);
                }
            } else if (length != 0) {
                int newindent = indent + indentFactor;
                foreach (var key in KeySet()) {
                    if (commanate) {
                        writer.AppendChar(',');
                    }
                    if (indentFactor > 0) {
                        writer.AppendChar('\n');
                    }
                    Indent(writer, newindent);
                    writer.Append(Quote(key));
                    writer.AppendChar(':');
                    if (indentFactor > 0) {
                        writer.AppendChar(' ');
                    }
                    try {
                        WriteValue(writer, Opt(key), indentFactor, newindent);
                    } catch (Exception e) {
                        throw new JSONException.Exception("Unable to write JSONObject value for key: " + key, e);
                    }
                    commanate = true;
                }
                if (indentFactor > 0) {
                    writer.AppendChar('\n');
                }
                Indent(writer, indent);
            }
            writer.AppendChar('}');
            return writer;
        } catch (IOException ex) {
            throw new JSONException.IOException(ex.message);
        }
    }

    /**
     * Returns a java.util.Map containing all of the entries in this object.
     * If an entry in the object is a JSONArray or JSONObject it will also
     * be converted.
     * <p>
     * Warning: This method assumes that the data structure is acyclical.
     *
     * @return a java.util.Map containing the entries of this object
     */
    public Dictionary<string, Object> ToMap() 
    {
        Dictionary<string, Object> results = new Dictionary<string, Object>();
        foreach (var key in KeySet()) {
            Object value;
            if (Opt(key) == null || NULL.Equals(Opt(key))) {
                value = null;
            } else if (Opt(key) is JSONObject) {
                value = ((JSONObject) Opt(key)).ToMap();
            } else if (Opt(key) is JSONArray) {
                value = ((JSONArray) Opt(key)).ToList();
            } else {
                value = Opt(key);
            }
            results[key] = value;
        }
        return results;
    }
}
