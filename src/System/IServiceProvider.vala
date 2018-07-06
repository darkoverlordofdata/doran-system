namespace System 
{

    public interface IServiceProvider : Object
    {
 	    public abstract Object GetService(Type? type); 
    }
}