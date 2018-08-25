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
        return new WinNTFileSystem();
    }
}
