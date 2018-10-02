/**
 *
 * @since 1.8
 */
public class System.IO.DefaultFileSystem 
{
    /**
     * Return the FileSystem object for Windows platform.
     */
    public static FileSystem GetFileSystem() 
    {
#if (__EMSCRIPTEN__)
        return null;
#else
        return new WinNTFileSystem();
#endif
    }
}
