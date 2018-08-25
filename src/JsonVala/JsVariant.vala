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
     * Wrap a Json object
     * 
     * Arrays are represented as ArrayList<JsVariant>
     * Objects are represented as Dictionary<string, JsVariant>
     */
    public class JsVariant : Object {

        public bool boolean;
        public double number;
        public string string;
        public Dictionary<string, JsVariant> object;
        public ArrayList<JsVariant> array;

        public JsType type;

        public JsVariant(JsType type, bool isNull = false) {
            this.type = type;
            switch (type) {
                case JsType.JS_BOOLEAN:
                    boolean = false;
                    break;
                case JsType.JS_NUMBER:
                    number = 0;
                    break;
                case JsType.JS_STRING:
                    string = "";
                    break;
                case JsType.JS_OBJECT:
                    object = isNull ? null : new Dictionary<string, JsVariant>();
                    break;
                case JsType.JS_ARRAY:
                    array = new ArrayList<JsVariant>();
                    break;
                    
                default:
                    break;
            }
        }

        public JsVariant.String(string value) {
            this.type = JsType.JS_STRING;
            this.string = value;
        }

        public JsVariant.Number(double value) {
            this.type = JsType.JS_NUMBER;
            this.number = value;
        }

        public JsVariant.Boolean(bool value) {
            this.type = JsType.JS_BOOLEAN;
            this.boolean = value;
        }

        public JsVariant at(int index) {
            return array[index];
        }

        public JsVariant get(string key) {
            return object[key];
        }
    }   
}

