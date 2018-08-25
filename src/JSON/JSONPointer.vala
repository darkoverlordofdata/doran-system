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
using System.Collections.Generic;
/**
 * A JSON Pointer is a simple query language defined for JSON documents by
 * <a href="https://tools.ietf.org/html/rfc6901">RFC 6901</a>.
 * 
 * In a nutshell, JSONPointer allows the user to navigate into a JSON document
 * using strings, and retrieve targeted objects, like a simple form of XPATH.
 * Path segments are separated by the '/' char, which signifies the root of
 * the document when it appears as the first char of the string. Array 
 * elements are navigated using ordinals, counting from 0. JSONPointer strings
 * may be extended to any arbitrary number of segments. If the navigation
 * is successful, the matched item is returned. A matched item may be a
 * JSONObject, a JSONArray, or a JSON value. If the JSONPointer string building 
 * fails, an appropriate exception is thrown. If the navigation fails to find
 * a match, a JSONPointerException is thrown. 
 * 
 * @author JSON.org
 * @version 2016-05-14
 */
public class System.JSON.JSONPointer : Object 
{

    // used for URL encoding and decoding
    private static string ENCODING = "utf-8";

    /**
     * This class allows the user to build a JSONPointer in steps, using
     * exactly one segment in each step.
     */
    public class Builder : Object 
    {

        // Segments for the eventual JSONPointer string
        private ArrayList<string> refTokens = new ArrayList<string>();

        /**
         * Creates a {@code JSONPointer} instance using the tokens previously set using the
         * {@link #append(string)} method calls.
         */
        public JSONPointer Build() 
        {
            return new JSONPointer.FromTokens(refTokens);
        }

        /**
         * Adds an arbitrary token to the list of reference tokens. It can be any non-null value.
         * 
         * Unlike in the case of JSON string or URI fragment representation of JSON pointers, the
         * argument of this method MUST NOT be escaped. If you want to query the property called
         * {@code "a~b"} then you should simply pass the {@code "a~b"} string as-is, there is no
         * need to escape it as {@code "a~0b"}.
         * 
         * @param token the new token to be appended to the list
         * @return {@code this}
         * @throws NullPointerException if {@code token} is null
         */
        public Builder Append(string token) 
        {
            if (token == null) {
                throw new Exception.NullPointerException("token cannot be null");
            }
            refTokens.Add(token);
            return this;
        }

        /**
         * Adds an integer to the reference token list. Although not necessarily, mostly this token will
         * denote an array index. 
         * 
         * @param arrayIndex the array index to be added to the token list
         * @return {@code this}
         */
        public Builder AppendInt(int arrayIndex) {
            refTokens.Add(arrayIndex.to_string());
            return this;
        }
    }

    /**
     * Static factory method for {@link Builder}. Example usage:
     * 
     * <pre><code>
     * JSONPointer pointer = JSONPointer.builder()
     *       .append("obj")
     *       .append("other~key").append("another/key")
     *       .append("\"")
     *       .append(0)
     *       .build();
     * </code></pre>
     * 
     *  @return a builder instance which can be used to construct a {@code JSONPointer} instance by chained
     *  {@link Builder#append(string)} calls.
     */
    public static Builder Create() 
    {
        return new Builder();
    }

    // Segments for the JSONPointer string
    private ArrayList<string> refTokens;

    /**
     * Pre-parses and initializes a new {@code JSONPointer} instance. If you want to
     * evaluate the same JSON Pointer on different JSON documents then it is recommended
     * to keep the {@code JSONPointer} instances due to performance considerations.
     * 
     * @param pointer the JSON string or URI Fragment representation of the JSON pointer.
     * @throws IllegalArgumentException if {@code pointer} is not a valid JSON pointer
     */
    public JSONPointer(string pointer) 
    {
        if (pointer == null) {
            throw new Exception.NullPointerException("pointer cannot be null");
        }
        if (pointer == "" || pointer == "#") {
            refTokens = new ArrayList<string>();
            return;
        }
        string refs;
        if (pointer.starts_with("#/")) {
            refs = pointer.substring(2);
            // try {
            //     refs = URLDecoder.decode(refs, ENCODING);
            // } catch (UnsupportedEncodingException e) {
            //     throw new RuntimeException(e);
            // }
        } else if (pointer.starts_with("/")) {
            refs = pointer.substring(1);
        } else {
            throw new Exception.IllegalArgumentException("a JSON pointer should start with '/' or '#/'");
        }
        refTokens = new ArrayList<string>();
        int slashIdx = -1;
        int prevSlashIdx = 0;
        do {
            prevSlashIdx = slashIdx + 1;
            slashIdx = refs.index_of("/", prevSlashIdx);
            if(prevSlashIdx == slashIdx || prevSlashIdx == refs.length) {
                // found 2 slashes in a row ( obj//next )
                // or single slash at the end of a string ( obj/test/ )
                refTokens.Add("");
            } else if (slashIdx >= 0) {
                string token = refs.substring(prevSlashIdx, slashIdx-prevSlashIdx);
                refTokens.Add(Unescape(token));
            } else {
                // last item after separator, or no separator at all.
                string token = refs.substring(prevSlashIdx);
                refTokens.Add(Unescape(token));
            }
        } while (slashIdx >= 0);
        // using split does not take into account consecutive separators or "ending nulls"
        //for (string token : refs.split("/")) {
        //    refTokens.add(unescape(token));
        //}
    }

    public JSONPointer.FromTokens(ArrayList<string> refTokens) 
    {
        this.refTokens = new ArrayList<string>();
        foreach (var token in refTokens)
            this.refTokens.Add(token);
    }

    private string Unescape(string token) 
    {
        return token.replace("~1", "/").replace("~0", "~")
                .replace("\\\"", "\"")
                .replace("\\\\", "\\");
    }

    /**
     * Evaluates this JSON Pointer on the given {@code document}. The {@code document}
     * is usually a {@link JSONObject} or a {@link JSONArray} instance, but the empty
     * JSON Pointer ({@code ""}) can be evaluated on any JSON values and in such case the
     * returned value will be {@code document} itself. 
     * 
     * @param document the JSON document which should be the subject of querying.
     * @return the result of the evaluation
     * @throws JSONPointerException if an error occurs during evaluation
     */
    public Object QueryFrom(Object document) throws JSONException 
    {
        if (refTokens.Count == 0) {
            return document;
        }
        Object current = document;
        foreach (string token in refTokens) {
            if (current is JSONObject) {
                current = ((JSONObject) current).Opt(Unescape(token));
            } else if (current is JSONArray) {
                current = ReadByIndexToken(current, token);
            } else {
                throw new JSONException.PointerException(
                        "value [%s] is not an array or object therefore its key %s cannot be resolved"
                        .printf(current.ToString(), token));
            }
        }
        return current;
    }

    /**
     * Matches a JSONArray element by ordinal position
     * @param current the JSONArray to be evaluated
     * @param indexToken the array index in string form
     * @return the matched object. If no matching item is found a
     * @throws JSONPointerException is thrown if the index is out of bounds
     */
    private Object ReadByIndexToken(Object current, string indexToken) throws JSONException 
    {
        try {
            int index = Integer.ParseInt(indexToken);
            JSONArray currentArr = (JSONArray) current;
            if (index >= currentArr.Length()) {
                throw new JSONException.PointerException("index %d is out of bounds - the array has %d elements".printf(index,
                        currentArr.Length()));
            }
            try {
				return currentArr[index];
			} catch (JSONException e) {
				throw new JSONException.PointerException(@"Error reading value at index position $index");
			}
        } catch (Exception e) {
            throw new JSONException.PointerException("%s is not an array index".printf(indexToken));
        }
    }

    /**
     * Returns a string representing the JSONPointer path value using string
     * representation
     */
    public override string ToString() {
        StringBuilder rval = new StringBuilder("");
        foreach (string token in refTokens) {
            rval.append_c('/').append(Escape(token));
        }
        return rval.str;
    }

    /**
     * Escapes path segment values to an unambiguous form.
     * The escape char to be inserted is '~'. The chars to be escaped 
     * are ~, which maps to ~0, and /, which maps to ~1. Backslashes
     * and double quote chars are also escaped.
     * @param token the JSONPointer segment value to be escaped
     * @return the escaped value for the token
     */
    private string Escape(string token) 
    {
        return token.replace("~", "~0")
                .replace("/", "~1")
                .replace("\\", "\\\\")
                .replace("\"", "\\\"");
    }
}
