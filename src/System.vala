/**
 * API Compatibility with the Microsoft System namespace
 */
namespace System 
{
    public void Initialize()
    {
        TimeSpan.Initialize();
        EventArgs.Initialize();
    }
}