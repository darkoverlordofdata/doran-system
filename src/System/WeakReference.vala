namespace System 
{
    
    public class WeakReference : Object
    {
        weak Object target;
        public WeakReference(Object target)
        {
            this.target = target;
        }
    }

}