/**
 *
 * @since 1.8
 */
public class System.IO.DefaultFileSystem : Object
{
    /**
     * Return the FileSystem object for Windows platform.
     */
    public static FileSystem GetFileSystem() 
    {
#if (__EMSCRIPTEN__)
        print("Create new EmscriptenFileSystem\n");
        var fs = new EmscriptenFileSystem();
        print("return EmscriptenFileSystem\n");
        return fs;
#else
        return new WinNTFileSystem();
#endif
    }
}
