namespace System
{
    public class Integer : Object
    {
        public int data;
        
        public Integer(int value)
        {
            data = value;
        }
        public int Get()
        {
            // print("data = %d\n", data);
            return data;
        }
    }
    public Variant Var<T>(T value)
    {
        return new Variant<T>(value);
    }
    public class Variant<T> : Object
    {
        public T data;

        public Variant(T value)
        {
            data = value;
        }

        public T Get<T>()
        {
            return data;
        }
        
        public void Set<T>(T value)
        {
            data = value;
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