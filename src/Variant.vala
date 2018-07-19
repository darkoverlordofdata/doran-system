/* ******************************************************************************
 * Copyright 2018 darkoverlordofdata.
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
namespace System
{
    public Variant Var<T>(T value)
    {
        return new Variant<T>(value);
    }
    public class Variant<T> : Object
    {
        private T data;

        public Variant(T value)
        {
            data = value;
        }

        public T Value<T>()
        {
            return data;
        }

        public string to_string()
        {
            switch(typeof(T))
            {
                case Type.BOOLEAN:
                    return ((bool)data).to_string();
                case Type.UCHAR:
                    return ((uchar)data).to_string();
                case Type.INT:
                    return ((int)data).to_string();
                case Type.UINT:
                    return ((uint)data).to_string();
                case Type.LONG:
                    return ((long)data).to_string();
                case Type.ULONG:
                    return ((ulong)data).to_string();
                case Type.INT64:
                    return ((int64)data).to_string();
                case Type.UINT64:
                    return ((uint64)data).to_string();
                case Type.FLOAT:
                    // can't cast a gpointer to float
                    float d = 0;
                    Memory.copy(&d, data, 4);
                    return "%f".printf(d);
                case Type.DOUBLE:
                    // can't cast a gpointer to double
                    double d = 0;
                    Memory.copy(&d, data, 8);
                    return "%f".printf(d);
                case Type.STRING:
                    return ((string)data).to_string();
                case Type.OBJECT:
                    return ((Object)data).to_string();
            }
            return "Unknown Variant Type";
        }
    }
}