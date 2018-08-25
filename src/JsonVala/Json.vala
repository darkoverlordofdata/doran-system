/* ******************************************************************************
 * Copyright 2017 darkoverlordofdata.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ******************************************************************************/
using System.Collections.Generic;

namespace System.Json
{
    /**
     * Simple Json Parser
     * 
     * based on JSON.parse
     * 
     * by [[Crockford]] [[https://github.com/douglascrockford/JSON-js]]
     */
    public class Json : Object {

        public static const string HEX_DIGIT = "0123456789abcdef";
        public static const string ESCAPE0 = "\"\\/bfnrt";
        public static const string[] ESCAPE1 = {"\"", "\\", "/", "\b", "\f", "\n", "\r", "\t"};
        public static string Gap;
        public static string Indent;
        
        private int at;
        private char ch;
        private string text;
        private JsDelegate _replacer;


        public Json(JsDelegate replacer = null) {
            _replacer = replacer;
        }

        public static JsVariant Parse(string source) {
            return new Json().ParseJson(source);
        }

        public static string Stringify(JsVariant value, JsDelegate replacer = null, string space = "") {
            // The stringify method takes a value and an optional Replacer, and an optional
            // space parameter, and returns a JSON text. The Replacer can be a function
            // that can replace values, or an array of strings that will select the keys.
            // A default Replacer method can be provided. Use of the space parameter can
            // produce text that is more easily readable.

            Gap = "";
            Indent = space;

            var holder = new JsVariant(JsType.JS_OBJECT);
            holder.object[""] = value;
            return new Json(replacer).Str("", holder);
        }

        public string Quote(string str) {
            return "\"" + str + "\"";
        }

        public JsVariant GetItem(JsVariant holder, string key) {
            switch (holder.type) {
                case JsType.JS_ARRAY:
                    return holder.array[int.parse(key)];
                case JsType.JS_OBJECT:
                    return holder.object[key];
                default:
                    return null;
            }
        }

        public string Str(string key, JsVariant holder) {
            // Produce a string from holder[key].

            var length = 0;
            var mind = Gap;
            JsVariant value = GetItem(holder, key);

            if (_replacer != null) {
                value = _replacer(holder, key, value);
            }

            switch (value.type) {

                case JsType.JS_STRING:
                    return Quote(value.string);

                case JsType.JS_NUMBER:
                    return value.number.to_string(); 

                case JsType.JS_BOOLEAN:
                    return value.boolean.to_string();

                case JsType.JS_OBJECT:
                    if (value.object == null) return "null";
                    Gap += Indent;
                    length = (int)value.object.Count;
                    var partial = new string[length];

                    // iterate through all of the keys in the object.
                    // var it = value.object.map_iterator ();
                    var i = 0;
                    foreach (var k in value.object.Keys)
                    {
                        partial[i++] = Quote(k) + (Gap.length>0 ? ": " : ":") + Str(k, value);
                    }
                    // for (var has_next = it.next (); has_next; has_next = it.next ())
                    // {
                    //     var k = it.get_key();
                    //     partial[i++] = Quote(k) + (Gap.length>0 ? ": " : ":") + Str(k, value);
                    // }
                    // Join all of the member texts together, separated with commas,
                    // and wrap them in braces.
                    var v = "";
                    if (partial.length == 0) {
                        v =  "{}";
                    } else if (Gap.length > 0) {
                        v = "{\n" + Gap + string.joinv(",\n" + Gap, partial) + "\n" + mind + "}";
                    } else {
                        v = "{" + string.joinv(",", partial) + "}";
                    }
                    Gap = mind;
                    return v;
                    

                case JsType.JS_ARRAY:
                    if (value.array == null) return "null";
                    Gap += Indent;
                    
                    // The value is an array. Stringify every element                    
                    length = (int)value.array.Count;
                    var partial = new string[length];
                    for (var i = 0; i < length; i++) {
                        partial[i] = Str(i.to_string(), value);
                    }
                    // Join all of the elements together, separated with commas, and wrap them in
                    // brackets.

                    var v = "";
                    if (partial.length == 0) {
                        v =  "[]";
                    } else if (Gap.length > 0) {
                        v = "[\n" + Gap + string.joinv(",\n" + Gap, partial) + "\n" + mind + "]";
                    } else {
                        v = "[" + string.joinv(",", partial) + "]";
                    }
                    Gap = mind;
                    return v;
            }
            return "";
        }

        public JsVariant ParseJson(string source) {

            text = source;
            at = 0;
            ch = ' ';
            var result = GetValue();
            SkipWhite();
            if (ch != 0) {
                throw new JsonException.SyntaxError("");
            }
            return result;
        }

        public char Next(char? c=null) 
        {
            // If a c parameter is provided, verify that it matches the current character.
            if (c != null && c != ch) 
            {
                throw new JsonException.UnexpectedCharacter("Expected '%s' instead of '%s'", c.to_string(), ch.to_string());
            }
            // Get the next character. When there are no more characters,
            // return the empty string.
            ch = text[at];
            at += 1;
            return ch;
        }

        public JsVariant GetValue() 
        {

            // Parse a JSON value. It could be an object, an array, a string, a number,
            // or a word.

            SkipWhite();
            switch (ch) {
                case '{':
                    return GetObject();
                case '[':
                    return GetArray();
                case '\"':
                    return GetString();
                case '-':
                    return GetNumber();
                default:
                    return (ch >= '0' && ch <= '9')
                        ? GetNumber()
                        : GetWord();
            }
        }

        public JsVariant GetNumber() {
            // Parse a number value.
            var string = "";

            if (ch == '-') {
                string = "-";
                Next('-');
            }

            while (ch >= '0' && ch <= '9') {
                string += ch.to_string();
                Next();
            }
            if (ch == '.') {
                string += ".";
                while (Next() != 0 && ch >= '0' && ch <= '9') {
                    string += ch.to_string();
                }
            }
            if (ch == 'e' || ch == 'E') {
                string += ch.to_string();
                Next();
                if (ch == '-' || ch == '+') {
                    string += ch.to_string();
                    Next();
                }
                while (ch >= '0' && ch <= '9') {
                    string += ch.to_string();
                    Next();
                }
            }
            return new JsVariant.Number((double)double.parse(string));
        }

        public JsVariant GetString() {
            // Parse a string value.
            var hex = 0;
            var i = 0;
            var string = "";
            var uffff = 0;
            // When parsing for string values, we must look for " and \ characters.

            if (ch == '\"') {
                while (Next() != 0) {
                    if (ch == '\"') {
                        Next();
                        return new JsVariant.String(string);
                    }
                    if (ch == '\\') {
                        Next();
                        if (ch == 'u') {
                            uffff = 0;
                            for (i = 0; i < 4; i += 1) {
                                hex = HEX_DIGIT.index_of(Next().to_string().down());
                                if (hex < 0) break;
                                uffff = uffff * 16 + hex;
                            }
                            string += ((char)uffff).to_string();
                        } else if ((i = ESCAPE0.index_of(ch.to_string())) >= 0) {
                            string += ESCAPE1[i];
                        } else {
                            break;
                        }
                    } else {
                        string += ch.to_string();
                    }
                }
            }
            throw new JsonException.InvalidString("");
        }


        public void SkipWhite() {

            // Skip whitespace.

            while (ch != 0 && ch <= ' ') {
                Next();
            }
        }

        public JsVariant GetWord() {

            switch (ch) {
                case 't':
                    Next('t');
                    Next('r');
                    Next('u');
                    Next('e');
                    return new JsVariant.Boolean(true);
                case 'f':
                    Next('f');
                    Next('a');
                    Next('l');
                    Next('s');
                    Next('e');
                    return new JsVariant.Boolean(false);
                case 'n':
                    Next('n');
                    Next('u');
                    Next('l');
                    Next('l');
                    return new JsVariant(JsType.JS_OBJECT, true);
            }
            throw new JsonException.UnexpectedCharacter("Unexpected '%s'", ch.to_string());

        }

        public JsVariant GetArray() {
            // Parse an array value.
            var result = new JsVariant(JsType.JS_ARRAY);

            if (ch == '[') {
                Next('[');
                SkipWhite();
                if (ch == ']') {
                    Next(']');
                    return result;
                }
                while (ch != 0) {
                    result.array.Add(GetValue());
                    SkipWhite();
                    if (ch == ']') {
                        Next(']');
                        return result;
                    }
                    Next(',');
                    SkipWhite();
                }
            }
            throw new JsonException.InvalidArray("");
        }

        public JsVariant GetObject() {
            // Parse an object value.
            var key = "";
            var result = new JsVariant(JsType.JS_OBJECT);

            if (ch == '{') {
                Next('{');
                SkipWhite();
                if (ch == '}') {
                    Next('}');
                    return result;
                }
                while (ch != 0) {
                    key = GetString().string;
                    SkipWhite();
                    Next(':');
                    if (result.object.ContainsKey(key)) {
                        throw new JsonException.DuplicateKey("");
                    }
                    result.object[key] = GetValue();
                    SkipWhite();
                    if (ch == '}') {
                        Next('}');
                        return result;
                    }
                    Next(',');
                    SkipWhite();
                }
            }
            throw new JsonException.InvalidObject("");

        }

    }
}

