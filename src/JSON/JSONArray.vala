
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
 * A JSONArray is an ordered sequence of values. Its external text form is a
 * string wrapped in square brackets with commas separating the values. The
 * internal form is an object having <code>get</code> and <code>opt</code>
 * methods for accessing the values by index, and <code>put</code> methods for
 * adding or replacing values. The values can be any of these types:
 * <code>Boolean</code>, <code>JSONArray</code>, <code>JSONObject</code>,
 * <code>Number</code>, <code>string</code>, or the
 * <code>JSONObject.NULL object</code>.
 * <p>
 * The constructor can convert a JSON text into a Java object. The
 * <code>toString</code> method converts to JSON text.
 * <p>
 * A <code>get</code> method returns a value if one can be found, and throws an
 * exception if one cannot be found. An <code>opt</code> method returns a
 * default value instead of throwing an exception, and so is useful for
 * obtaining optional values.
 * <p>
 * The generic <code>get()</code> and <code>opt()</code> methods return an
 * object which you can cast or query for type. There are also typed
 * <code>get</code> and <code>opt</code> methods that do type checking and type
 * coercion for you.
 * <p>
 * The texts produced by the <code>toString</code> methods strictly conform to
 * JSON syntax rules. The constructors are more forgiving in the texts they will
 * accept:
 * <ul>
 * <li>An extra <code>,</code>&nbsp;<small>(comma)</small> may appear just
 * before the closing bracket.</li>
 * <li>The <code>null</code> value will be inserted when there is <code>,</code>
 * &nbsp;<small>(comma)</small> elision.</li>
 * <li>Strings may be quoted with <code>'</code>&nbsp;<small>(single
 * quote)</small>.</li>
 * <li>Strings do not need to be quoted at all if they do not begin with a quote
 * or single quote, and if they do not contain leading or trailing spaces, and
 * if they do not contain any of these characters:
 * <code>{ } [ ] / \ : , #</code> and if they do not look like numbers and
 * if they are not the reserved words <code>true</code>, <code>false</code>, or
 * <code>null</code>.</li>
 * </ul>
 *
 * @author JSON.org
 * @version 2016-08/15
 */
public class System.JSON.JSONArray : Iterable<Object> 
{

    /**
     * The arrayList where the JSONArray's properties are kept.
     */
    private ArrayList<Object> myArrayList;

    /**
     * Construct an empty JSONArray.
     */
    public JSONArray() 
    {
        myArrayList = new ArrayList<Object>();
    }

    /**
     * Construct a JSONArray from a JSONTokener.
     *
     * @param x
     *            A JSONTokener
     * @throws JSONException
     *             If there is a syntax error.
     */
    public JSONArray.Tokener(JSONTokener x) throws JSONException 
    {
        this();
        if (x.NextClean() != '[') {
            throw x.SyntaxError("A JSONArray text must start with '['");
        }
        
        char nextChar = x.NextClean();
        if (nextChar == 0) {
            // array is unclosed. No ']' found, instead EOF
            throw x.SyntaxError("Expected a ',' or ']'");
        }
        if (nextChar != ']') {
            x.Back();
            for (;;) {
                if (x.NextClean() == ',') {
                    x.Back();
                    myArrayList.Add(JSONObject.NULL);
                } else {
                    x.Back();
                    myArrayList.Add(x.NextValue());
                }
                switch (x.NextClean()) {
                case 0:
                    // array is unclosed. No ']' found, instead EOF
                    throw x.SyntaxError("Expected a ',' or ']'");
                case ',':
                    nextChar = x.NextClean();
                    if (nextChar == 0) {
                        // array is unclosed. No ']' found, instead EOF
                        throw x.SyntaxError("Expected a ',' or ']'");
                    }
                    if (nextChar == ']') {
                        return;
                    }
                    x.Back();
                    break;
                case ']':
                    return;
                default:
                    throw x.SyntaxError("Expected a ',' or ']'");
                }
            }
        }
    }

    /**
     * Construct a JSONArray from a source JSON text.
     *
     * @param source
     *            A string that begins with <code>[</code>&nbsp;<small>(left
     *            bracket)</small> and ends with <code>]</code>
     *            &nbsp;<small>(right bracket)</small>.
     * @throws JSONException
     *             If there is a syntax error.
     */
    public JSONArray.String(string source) throws JSONException 
    {
        this.Tokener(new JSONTokener(source));
    }

    /**
     * Construct a JSONArray from a Collection.
     *
     * @param collection
     *            A Collection.
     */
    public JSONArray.Collection(Collection<Object> collection) 
    {
        if (collection == null) {
            myArrayList = new ArrayList<Object>();
        } else {
            myArrayList = new ArrayList<Object>();
        	foreach (Object o in collection){
        		myArrayList.Add(JSONObject.Wrap(o));
        	}
        }
    }

    /**
     * Construct a JSONArray from an array
     *
     * @throws JSONException
     *             If not an array or if an array value is non-finite number.
     */
    public JSONArray.Array(Object[] array) throws JSONException 
    {
        this();
        int length = array.length;
        for (int i = 0; i < length; i += 1) {
            Add(JSONObject.Wrap(array[i]));
        }
    }

    public override Iterator<Object> iterator() 
    {
        return myArrayList.iterator();
    }

    public override Type get_element_type () 
    {
        return typeof (Object);
    }

    /**
     * Get the object value associated with an index.
     *
     * @param index
     *            The index must be between 0 and length() - 1.
     * @return An object value.
     * @throws JSONException
     *             If there is no value for the index.
     */
    public Object get(int index) throws JSONException 
    {
        Object object = Opt(index);
        if (object == null) {
            throw new JSONException.Exception(@"JSONArray[$index] not found.");
        }
        return object;
    }

    /**
     * Get the bool value associated with an index. The string values "true"
     * and "false" are converted to bool.
     *
     * @param index
     *            The index must be between 0 and length() - 1.
     * @return The truth.
     * @throws JSONException
     *             If there is no value for the index or if the value is not
     *             convertible to bool.
     */
    public bool GetBoolean(int index) throws JSONException 
    {
        Object object = this[index];
        if (object.Equals(Boolean.FALSE)
                || (object is String)
                && (object.ToString() == "false")) {
            return false;
        } else if (object.Equals(Boolean.TRUE)
                || (object is String)
                && (object.ToString() == "true")) {
            return true;
        }
        throw new JSONException.Exception(@"JSONArray[$index] is not a bool.");
    }

    /**
     * Get the double value associated with an index.
     *
     * @param index
     *            The index must be between 0 and length() - 1.
     * @return The value.
     * @throws JSONException
     *             If the key is not found or if the value cannot be converted
     *             to a number.
     */
    public double GetDouble(int index) throws JSONException 
    {
        Object object = this[index];
        try {
            return (object is Number) 
                    ? ((Number) object).DoubleValue()
                    : Double.ParseDouble(object.ToString());
        } catch (Exception e) {
            throw new JSONException.Exception(@"JSONArray[$index] is not a number.");
        }
    }

    /**
     * Get the float value associated with a key.
     *
     * @param index
     *            The index must be between 0 and length() - 1.
     * @return The numeric value.
     * @throws JSONException
     *             if the key is not found or if the value is not a Number
     *             object and cannot be converted to a number.
     */
    public float GetFloat(int index) throws JSONException 
    {
        Object object = this[index];
        try {
            return (object is Number)
                    ? ((Number) object).FloatValue()
                    : Float.ParseFloat(object.ToString());
        } catch (Exception e) {
            throw new JSONException.Exception(@"JSONArray[$index] is not a number.");
        }
    }

    /**
     * Get the Number value associated with a key.
     *
     * @param index
     *            The index must be between 0 and length() - 1.
     * @return The numeric value.
     * @throws JSONException
     *             if the key is not found or if the value is not a Number
     *             object and cannot be converted to a number.
     */
    public Number GetNumber(int index) throws JSONException 
    {
        Object object = this[index];
        try {
            if (object is Number) {
                return (Number)object;
            }
            return JSONObject.StringToNumber(object.ToString());
        } catch (Exception e) {
            throw new JSONException.Exception(@"JSONArray[$index] is not a number.");
        }
    }

    /**
     * Get the int value associated with an index.
     *
     * @param index
     *            The index must be between 0 and length() - 1.
     * @return The value.
     * @throws JSONException
     *             If the key is not found or if the value is not a number.
     */
    public int GetInt(int index) throws JSONException 
    {
        Object object = this[index];
        try {
            return (object is Number) 
                    ? ((Number) object).IntValue()
                    : Integer.ParseInt((string) object);
        } catch (Exception e) {
            throw new JSONException.Exception(@"JSONArray[$index] is not a number.");
        }
    }

    /**
     * Get the JSONArray associated with an index.
     *
     * @param index
     *            The index must be between 0 and length() - 1.
     * @return A JSONArray value.
     * @throws JSONException
     *             If there is no value for the index. or if the value is not a
     *             JSONArray
     */
    public JSONArray GetJSONArray(int index) throws JSONException 
    {
        Object object = this[index];
        if (object is JSONArray) {
            return (JSONArray) object;
        }
        throw new JSONException.Exception(@"JSONArray[$index] is not a JSONArray.");
    }

    /**
     * Get the JSONObject associated with an index.
     *
     * @param index
     *            subscript
     * @return A JSONObject value.
     * @throws JSONException
     *             If there is no value for the index or if the value is not a
     *             JSONObject
     */
    public JSONObject GetJSONObject(int index) throws JSONException 
    {
        Object object = this[index];
        if (object is JSONObject) {
            return (JSONObject) object;
        }
        throw new JSONException.Exception(@"JSONArray[$index] is not a JSONObject.");
    }

    /**
     * Get the long value associated with an index.
     *
     * @param index
     *            The index must be between 0 and length() - 1.
     * @return The value.
     * @throws JSONException
     *             If the key is not found or if the value cannot be converted
     *             to a number.
     */
    public long GetLong(int index) throws JSONException 
    {
        Object object = this[index];
        try {
            return (object is Number)
                    ? ((Number) object).LongValue()
                    : Long.ParseLong((string) object);
        } catch (Exception e) {
            throw new JSONException.Exception(@"JSONArray[$index] is not a number.");
        }
    }

    /**
     * Get the string associated with an index.
     *
     * @param index
     *            The index must be between 0 and length() - 1.
     * @return A string value.
     * @throws JSONException
     *             If there is no string value for the index.
     */
    public String GetString(int index) throws JSONException 
    {
        Object object = this[index];
        if (object is String) {
            return (String) object;
        }
        throw new JSONException.Exception(@"JSONArray[$index] not a string.");
    }

    /**
     * Determine if the value is <code>null</code>.
     *
     * @param index
     *            The index must be between 0 and length() - 1.
     * @return true if the value at the index is <code>null</code>, or if there is no value.
     */
    public bool IsNull(int index) 
    {
        return JSONObject.NULL.Equals(Opt(index));
    }

    /**
     * Make a string from the contents of this JSONArray. The
     * <code>separator</code> string is inserted between each element. Warning:
     * This method assumes that the data structure is acyclical.
     *
     * @param separator
     *            A string that will be inserted between the elements.
     * @return a string.
     * @throws JSONException
     *             If the array contains an invalid number.
     */
    public string Join(string separator) throws JSONException 
    {
        int len = Length();
        StringWriter sb = new StringWriter();

        for (int i = 0; i < len; i += 1) {
            if (i > 0) {
                sb.Append(separator);
            }
            sb.Append(JSONObject.ValueToString(myArrayList[i]));
        }
        return sb.ToString();
    }

    /**
     * Get the number of elements in the JSONArray, included nulls.
     *
     * @return The length (or size).
     */
    public int Length() 
    {
        return myArrayList.Count;
    }

    /**
     * Get the optional object value associated with an index.
     *
     * @param index
     *            The index must be between 0 and length() - 1. If not, null is returned.
     * @return An object value, or null if there is no object at that index.
     */
    public Object Opt(int index) 
    {
        return (index < 0 || index >= Length()) ? null : myArrayList[index];
    }

    /**
     * Get the optional bool value associated with an index. It returns the
     * defaultValue if there is no value at that index or if it is not a Boolean
     * or the string "true" or "false" (case insensitive).
     *
     * @param index
     *            The index must be between 0 and length() - 1.
     * @param defaultValue
     *            A bool default.
     * @return The truth.
     */
    public bool OptBoolean(int index, bool defaultValue = false) 
    {
        try {
            return GetBoolean(index);
        } catch (Exception e) {
            return defaultValue;
        }
    }

    /**
     * Get the optional double value associated with an index. The defaultValue
     * is returned if there is no value for the index, or if the value is not a
     * number and cannot be converted to a number.
     *
     * @param index
     *            subscript
     * @param defaultValue
     *            The default value.
     * @return The value.
     */
    public double OptDouble(int index, double defaultValue = double.NAN) 
    {
        Object val = this[index];
        if (JSONObject.NULL.Equals(val)) {
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
     * Get the optional float value associated with an index. The defaultValue
     * is returned if there is no value for the index, or if the value is not a
     * number and cannot be converted to a number.
     *
     * @param index
     *            subscript
     * @param defaultValue
     *            The default value.
     * @return The value.
     */
    public float OptFloat(int index, float defaultValue = float.NAN) 
    {
        Object val = this[index];
        if (JSONObject.NULL.Equals(val)) {
            return defaultValue;
        }
        if (val is Number){
            return ((Number) val).FloatValue();
        }
        if (val is String) {
            try {
                return Float.ParseFloat(((String) val).ToString());
            } catch (Exception e) {
                return defaultValue;
            }
        }
        return defaultValue;
    }

    /**
     * Get the optional int value associated with an index. The defaultValue is
     * returned if there is no value for the index, or if the value is not a
     * number and cannot be converted to a number.
     *
     * @param index
     *            The index must be between 0 and length() - 1.
     * @param defaultValue
     *            The default value.
     * @return The value.
     */
    public int OptInt(int index, int defaultValue = 0) 
    {
        Object val = this[index];
        if (JSONObject.NULL.Equals(val)) {
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
     * Get the optional JSONArray associated with an index.
     *
     * @param index
     *            subscript
     * @return A JSONArray value, or null if the index has no value, or if the
     *         value is not a JSONArray.
     */
    public JSONArray OptJSONArray(int index) 
    {
        Object o = this[index];
        return o as JSONArray;
    }

    /**
     * Get the optional JSONObject associated with an index. Null is returned if
     * the key is not found, or null if the index has no value, or if the value
     * is not a JSONObject.
     *
     * @param index
     *            The index must be between 0 and length() - 1.
     * @return A JSONObject value.
     */
    public JSONObject OptJSONObject(int index) 
    {
        Object o = this[index];
        return o as JSONObject;
    }

    /**
     * Get the optional long value associated with an index. The defaultValue is
     * returned if there is no value for the index, or if the value is not a
     * number and cannot be converted to a number.
     *
     * @param index
     *            The index must be between 0 and length() - 1.
     * @param defaultValue
     *            The default value.
     * @return The value.
     */
    public long OptLong(int index, long defaultValue = 0) 
    {
        Object val = this[index];
        if (JSONObject.NULL.Equals(val)) {
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
     * an attempt will be made to evaluate it as a number ({@link BigDecimal}). This method
     * would be used in cases where type coercion of the number value is unwanted.
     *
     * @param index
     *            The index must be between 0 and length() - 1.
     * @param defaultValue
     *            The default.
     * @return An object which is the value.
     */
    public Number OptNumber(int index, Number defaultValue = null) 
    {
        Object val = this[index];
        if (JSONObject.NULL.Equals(val)) {
            return defaultValue;
        }
        if (val is Number){
            return (Number) val;
        }
        
        if (val is String){
            try {
                return JSONObject.StringToNumber(((String) val).ToString());
            } catch (Exception e) {
                return defaultValue;
            }
        }
        return defaultValue;
    }

    /**
     * Get the optional string associated with an index. The defaultValue is
     * returned if the key is not found.
     *
     * @param index
     *            The index must be between 0 and length() - 1.
     * @param defaultValue
     *            The default value.
     * @return A string value.
     */
    public string OptString(int index, string defaultValue = "") 
    {
        Object object = this[index];
        return JSONObject.NULL.Equals(object) ? defaultValue : object.ToString();
    }

    /**
     * Append a bool value. This increases the array's length by one.
     *
     * @param value
     *            A bool value.
     * @return 
     */
    public JSONArray AddBoolean(bool value) 
    {
        return Add(value ? Boolean.TRUE : Boolean.FALSE);
    }

    /**
     * Put a value in the JSONArray, where the value will be a JSONArray which
     * is produced from a Collection.
     *
     * @param value
     *            A Collection value.
     * @return 
     * @throws JSONException
     *            If the value is non-finite number.
     */
    public JSONArray AddCollection(Collection<Object> value) 
    {
        return Add(new JSONArray.Collection(value));
    }

    /**
     * Append a double value. This increases the array's length by one.
     *
     * @param value
     *            A double value.
     * @return 
     * @throws JSONException
     *             if the value is not finite.
     */
    public JSONArray AdddDouble(double value) throws JSONException 
    {
        return Add(Double.Value(value));
    }
    
    /**
     * Append a float value. This increases the array's length by one.
     *
     * @param value
     *            A float value.
     * @return 
     * @throws JSONException
     *             if the value is not finite.
     */
    public JSONArray AddFloat(float value) throws JSONException 
    {
        return Add(Float.Value(value));
    }

    /**
     * Append an int value. This increases the array's length by one.
     *
     * @param value
     *            An int value.
     * @return 
     */
    public JSONArray AddInt(int value) 
    {
        return Add(Integer.Value(value));
    }

    /**
     * Append an long value. This increases the array's length by one.
     *
     * @param value
     *            A long value.
     * @return 
     */
    public JSONArray AddLong(long value) 
    {
        return Add(Long.Value(value));
    }

    /**
     * Put a value in the JSONArray, where the value will be a JSONObject which
     * is produced from a Map.
     *
     * @param value
     *            A Map value.
     * @return 
     * @throws JSONException
     *            If a value in the map is non-finite number.
     * @throws NullPointerException
     *            If a key in the map is <code>null</code>
     */
    public JSONArray AddMap(Dictionary<string, Object> value) 
    {
        return Add(new JSONObject.Map(value));
    }

    /**
     * Append an object value. This increases the array's length by one.
     *
     * @param value
     *            An object value. The value should be a Boolean, Double,
     *            Integer, JSONArray, JSONObject, Long, or string, or the
     *            JSONObject.NULL object.
     * @return 
     * @throws JSONException
     *            If the value is non-finite number.
     */
    public JSONArray Add(Object value) 
    {
        JSONObject.TestValidity(value);
        myArrayList.Add(value);
        return this;
    }

    /**
     * Put or replace a bool value in the JSONArray. If the index is greater
     * than the length of the JSONArray, then null elements will be added as
     * necessary to pad it out.
     *
     * @param index
     *            The subscript.
     * @param value
     *            A bool value.
     * @return 
     * @throws JSONException
     *             If the index is negative.
     */
    public JSONArray PutBoolean(int index, bool value) throws JSONException 
    {
        this[index] = value ? Boolean.TRUE : Boolean.FALSE;
        return this;
    }

    /**
     * Put a value in the JSONArray, where the value will be a JSONArray which
     * is produced from a Collection.
     *
     * @param index
     *            The subscript.
     * @param value
     *            A Collection value.
     * @return 
     * @throws JSONException
     *             If the index is negative or if the value is non-finite.
     */
    public JSONArray PutCollection(int index, Collection<Object> value) throws JSONException 
    {
        this[index] = new JSONArray.Collection(value);
        return this;
    }

    /**
     * Put or replace a double value. If the index is greater than the length of
     * the JSONArray, then null elements will be added as necessary to pad it
     * out.
     *
     * @param index
     *            The subscript.
     * @param value
     *            A double value.
     * @return 
     * @throws JSONException
     *             If the index is negative or if the value is non-finite.
     */
    public JSONArray PutDouble(int index, double value) throws JSONException 
    {
        this[index] = Double.Value(value);
        return this;
    }

    /**
     * Put or replace a float value. If the index is greater than the length of
     * the JSONArray, then null elements will be added as necessary to pad it
     * out.
     *
     * @param index
     *            The subscript.
     * @param value
     *            A float value.
     * @return 
     * @throws JSONException
     *             If the index is negative or if the value is non-finite.
     */
    public JSONArray PutFloat(int index, float value) throws JSONException 
    {
        this[index] = Float.Value(value);
        return this;
    }

    /**
     * Put or replace an int value. If the index is greater than the length of
     * the JSONArray, then null elements will be added as necessary to pad it
     * out.
     *
     * @param index
     *            The subscript.
     * @param value
     *            An int value.
     * @return 
     * @throws JSONException
     *             If the index is negative.
     */
    public JSONArray PutInt(int index, int value) throws JSONException 
    {
        this[index] = Integer.Value(value);
        return this;
    }

    /**
     * Put or replace a long value. If the index is greater than the length of
     * the JSONArray, then null elements will be added as necessary to pad it
     * out.
     *
     * @param index
     *            The subscript.
     * @param value
     *            A long value.
     * @return 
     * @throws JSONException
     *             If the index is negative.
     */
    public JSONArray PutLong(int index, long value) throws JSONException 
    {
        this[index] = Long.Value(value);
        return this;
    }

    /**
     * Put a value in the JSONArray, where the value will be a JSONObject that
     * is produced from a Map.
     *
     * @param index
     *            The subscript.
     * @param value
     *            The Map value.
     * @return 
     * @throws JSONException
     *             If the index is negative or if the the value is an invalid
     *             number.
     * @throws NullPointerException
     *             If a key in the map is <code>null</code>
     */
    public JSONArray PutMap(int index, Dictionary<string, Object> value) throws JSONException 
    {
        this[index] = new JSONObject.Map(value);
        return this;
    }

    /**
     * Put or replace an object value in the JSONArray. If the index is greater
     * than the length of the JSONArray, then null elements will be added as
     * necessary to pad it out.
     *
     * @param index
     *            The subscript.
     * @param value
     *            The value to put into the array. The value should be a
     *            Boolean, Double, Integer, JSONArray, JSONObject, Long, or
     *            string, or the JSONObject.NULL object.
     * @return 
     * @throws JSONException
     *             If the index is negative or if the the value is an invalid
     *             number.
     */
    public void set(int index, Object value) throws JSONException 
    {
        if (index < 0) {
            throw new JSONException.Exception(@"JSONArray[index] not found.");
        }
        if (index < Length()) {
            JSONObject.TestValidity(value);
            myArrayList[index] = value;
            return;
        }
        if(index == Length()){
            // simple append
            Add(value);
        }
        // if we are inserting past the length, we want to grow the array all at once
        // instead of incrementally.
        // myArrayList.ensureCapacity(index + 1);
        while (index != Length()) {
            // we don't need to test validity of NULL objects
            myArrayList.Add(JSONObject.NULL);
        }
        Add(value);
    }
    
    /**
     * Creates a JSONPointer using an initialization string and tries to 
     * match it to an item within this JSONArray. For example, given a
     * JSONArray initialized with this document:
     * <pre>
     * [
     *     {"b":"c"}
     * ]
     * </pre>
     * and this JSONPointer string: 
     * <pre>
     * "/0/b"
     * </pre>
     * Then this method will return the string "c"
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
     * Uses a uaer initialized JSONPointer  and tries to 
     * match it to an item whithin this JSONArray. For example, given a
     * JSONArray initialized with this document:
     * <pre>
     * [
     *     {"b":"c"}
     * ]
     * </pre>
     * and this JSONPointer: 
     * <pre>
     * "/0/b"
     * </pre>
     * Then this method will return the string "c"
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
     * Remove an index and close the hole.
     *
     * @param index
     *            The index of the element to be removed.
     * @return The value that was associated with the index, or null if there
     *         was no value.
     */
    public Object Remove(int index) 
    {
        return index >= 0 && index < Length()
            ? myArrayList.RemoveAt(index)
            : null;
    }

    /**
     * Determine if two JSONArrays are similar.
     * They must contain similar sequences.
     *
     * @param other The other JSONArray
     * @return true if they are equal
     */
    public bool Similar(Object other) 
    {
        if (!(other is JSONArray)) {
            return false;
        }
        int len = Length();
        if (len != ((JSONArray)other).Length()) {
            return false;
        }
        for (int i = 0; i < len; i += 1) {
            Object valueThis = myArrayList[i];
            Object valueOther = ((JSONArray)other).myArrayList[i];
            if(valueThis == valueOther) {
            	continue;
            }
            if(valueThis == null) {
            	return false;
            }
            if (valueThis is JSONObject) {
                if (!((JSONObject)valueThis).Similar(valueOther)) {
                    return false;
                }
            } else if (valueThis is JSONArray) {
                if (!((JSONArray)valueThis).Similar(valueOther)) {
                    return false;
                }
            } else if (!valueThis.Equals(valueOther)) {
                return false;
            }
        }
        return true;
    }

    /**
     * Produce a JSONObject by combining a JSONArray of names with the values of
     * this JSONArray.
     *
     * @param names
     *            A JSONArray containing a list of key strings. These will be
     *            paired with the values.
     * @return A JSONObject, or null if there are no names or if this JSONArray
     *         has no values.
     * @throws JSONException
     *             If any of the names are null.
     */
    public JSONObject ToJSONObject(JSONArray names) throws JSONException 
    {
        if (names == null || names.IsEmpty() || IsEmpty()) {
            return null;
        }
        JSONObject jo = new JSONObject.Empty();
        for (int i = 0; i < names.Length(); i += 1) {
            jo[names.GetString(i).ToString()] = Opt(i);
        }
        return jo;
    }

    /**
     * Make a JSON text of this JSONArray. For compactness, no unnecessary
     * whitespace is added. If it is not possible to produce a syntactically
     * correct JSON text then null will be returned instead. This could occur if
     * the array contains an invalid number.
     * <p><b>
     * Warning: This method assumes that the data structure is acyclical.
     * </b>
     *
     * @return a printable, displayable, transmittable representation of the
     *         array.
     */
    public override string ToString() 
    {
        try {
            return ToString2(0);
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * Make a pretty-printed JSON text of this JSONArray.
     * 
     * <p>If <code>indentFactor > 0</code> and the {@link JSONArray} has only
     * one element, then the array will be output on a single line:
     * <pre>{@code [1]}</pre>
     * 
     * <p>If an array has 2 or more elements, then it will be output across
     * multiple lines: <pre>{@code
     * [
     * 1,
     * "value 2",
     * 3
     * ]
     * }</pre>
     * <p><b>
     * Warning: This method assumes that the data structure is acyclical.
     * </b>
     * 
     * @param indentFactor
     *            The number of spaces to add to each level of indentation.
     * @return a printable, displayable, transmittable representation of the
     *         object, beginning with <code>[</code>&nbsp;<small>(left
     *         bracket)</small> and ending with <code>]</code>
     *         &nbsp;<small>(right bracket)</small>.
     * @throws JSONException
     */
    private string ToString2(int indentFactor) throws JSONException 
    {
        StringWriter sw = new StringWriter();
        return Write(sw, indentFactor, 0).ToString();
    }

    /**
     * Write the contents of the JSONArray as JSON text to a writer.
     * 
     * <p>If <code>indentFactor > 0</code> and the {@link JSONArray} has only
     * one element, then the array will be output on a single line:
     * <pre>{@code [1]}</pre>
     * 
     * <p>If an array has 2 or more elements, then it will be output across
     * multiple lines: <pre>{@code
     * [
     * 1,
     * "value 2",
     * 3
     * ]
     * }</pre>
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
            writer.AppendChar('[');

            if (length == 1) {
                try {
                    JSONObject.WriteValue(writer, myArrayList[0],
                            indentFactor, indent);
                } catch (Exception e) {
                    throw new JSONException.Exception(@"Unable to write JSONArray value at index: 0");
                }
            } else if (length != 0) {
                int newindent = indent + indentFactor;

                for (int i = 0; i < length; i += 1) {
                    if (commanate) {
                        writer.AppendChar(',');
                    }
                    if (indentFactor > 0) {
                        writer.AppendChar('\n');
                    }
                    JSONObject.Indent(writer, newindent);
                    try {
                        JSONObject.WriteValue(writer, myArrayList[i],
                                indentFactor, newindent);
                    } catch (Exception e) {
                        throw new JSONException.Exception(@"Unable to write JSONArray value at index: $i");
                    }
                    commanate = true;
                }
                if (indentFactor > 0) {
                    writer.AppendChar('\n');
                }
                JSONObject.Indent(writer, indent);
            }
            writer.AppendChar(']');
            return writer;
        } catch (IOException e) {
            throw new JSONException.IOException(e.message);
        }
    }

    /**
     * Returns a java.util.List containing all of the elements in this array.
     * If an element in the array is a JSONArray or JSONObject it will also
     * be converted.
     * <p>
     * Warning: This method assumes that the data structure is acyclical.
     *
     * @return a java.util.List containing the elements of this array
     */
    public ArrayList<Object> ToList() 
    {
        ArrayList<Object> results = new ArrayList<Object>();
        foreach (Object element in myArrayList) {
            if (element == null || JSONObject.NULL.Equals(element)) {
                results.Add(null);
            } else if (element is JSONArray) {
                results.Add(((JSONArray) element).ToList());
            } else if (element is JSONObject) {
                results.Add(((JSONObject) element).ToMap());
            } else {
                results.Add(element);
            }
        }
        return results;
    }

    /**
     * Check if JSONArray is empty.
     *
     * @return true if JSONArray is empty, otherwise false.
     */
    public bool IsEmpty() 
    {
        return myArrayList.Count == 0;
    }
}
