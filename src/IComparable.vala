namespace System 
{

    public interface IComparable<T> : Object 
    {
        public abstract int CompareTo(T other);
    }
}