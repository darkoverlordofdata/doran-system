/**
 * Package-private abstract class for the local filesystem abstraction.
 */

public abstract class System.IO.FileSystem : Object 
{

    public static bool UseCanonCaches      = false;
    public static bool UseCanonPrefixCache = false;
    /* -- Normalization and construction -- */

    /**
     * Return the local filesystem's name-separator character.
     */
    public abstract char GetSeparator();

    /**
     * Return the local filesystem's path-separator character.
     */
    public abstract char GetPathSeparator();

    /**
     * Convert the given pathname string to normal form.  If the string is
     * already in normal form then it is simply returned.
     */
    public abstract string Normalize(string path);

    /**
     * Compute the length of this pathname string's prefix.  The pathname
     * string must be in normal form.
     */
    public abstract int PrefixLength(string path);

    /**
     * Resolve the child pathname string against the parent.
     * Both strings must be in normal form, and the result
     * will be in normal form.
     */
    public abstract string Resolve(string parent, string child);

    /**
     * Return the parent pathname string to be used when the parent-directory
     * argument in one of the two-argument File constructors is the empty
     * pathname.
     */
    public abstract string GetDefaultParent();

    /**
     * Post-process the given URI path string if necessary.  This is used on
     * win32, e.g., to transform "/c:/foo" into "c:/foo".  The path string
     * still has slash separators; code in the File class will translate them
     * after this method returns.
     */
    public abstract string FromURIPath(string path);


    /* -- Path operations -- */

    /**
     * Tell whether or not the given abstract pathname is absolute.
     */
    public abstract bool IsAbsolute(File f);

    /**
     * Resolve the given abstract pathname into absolute form.  Invoked by the
     * getAbsolutePath and getCanonicalPath methods in the File class.
     */
    public abstract string ResolveFile(File f);

    public abstract string Canonicalize(string path) throws IOException;


    /* -- Attribute accessors -- */

    /* Constants for simple boolean attributes */
    public static int BA_EXISTS    = 0xffff;
    public static int BA_FIFO      = 0x1000;
    public static int BA_CHAR      = 0x2000;
    public static int BA_BLOCK     = 0x3000;
    public static int BA_DIRECTORY = 0x4000;
    public static int BA_REGULAR   = 0x8000;

    /**
     * Return the simple boolean attributes for the file or directory denoted
     * by the given abstract pathname, or zero if it does not exist or some
     * other I/O error occurs.
     */
    public abstract int GetBooleanAttributes(File f);

    public static int ACCESS_READ    = 0400;
    public static int ACCESS_WRITE   = 0200;
    public static int ACCESS_EXECUTE = 0100;

    /**
     * Check whether the file or directory denoted by the given abstract
     * pathname may be accessed by this process.  The second argument specifies
     * which access, ACCESS_READ, ACCESS_WRITE or ACCESS_EXECUTE, to check.
     * Return false if access is denied or an I/O error occurs
     */
    public abstract bool CheckAccess(File f, int access);
    /**
     * Set on or off the access permission (to owner only or to all) to the file
     * or directory denoted by the given abstract pathname, based on the parameters
     * enable, access and oweronly.
     */
    public abstract bool SetPermission(File f, int access, bool enable, bool owneronly);

    /**
     * Return the time at which the file or directory denoted by the given
     * abstract pathname was last modified, or zero if it does not exist or
     * some other I/O error occurs.
     */
    public abstract long GetLastModifiedTime(File f);

    /**
     * Return the length in bytes of the file denoted by the given abstract
     * pathname, or zero if it does not exist, is a directory, or some other
     * I/O error occurs.
     */
    public abstract long GetLength(File f);


    /* -- File operations -- */

    /**
     * Create a new empty file with the given pathname.  Return
     * <code>true</code> if the file was created and <code>false</code> if a
     * file or directory with the given pathname already exists.  Throw an
     * IOException if an I/O error occurs.
     */
    public abstract bool CreateFileExclusively(string pathname)
        throws IOException;

    /**
     * Delete the file or directory denoted by the given abstract pathname,
     * returning <code>true</code> if and only if the operation succeeds.
     */
    public abstract bool Delete(File f);

    /**
     * List the elements of the directory denoted by the given abstract
     * pathname.  Return an array of strings naming the elements of the
     * directory if successful; otherwise, return <code>null</code>.
     */
    public abstract string[] List(File f);

    /**
     * Create a new directory denoted by the given abstract pathname,
     * returning <code>true</code> if and only if the operation succeeds.
     */
    public abstract bool CreateDirectory(File f);

    /**
     * Rename the file or directory denoted by the first abstract pathname to
     * the second abstract pathname, returning <code>true</code> if and only if
     * the operation succeeds.
     */
    public abstract bool Rename(File f1, File f2);

    /**
     * Set the last-modified time of the file or directory denoted by the
     * given abstract pathname, returning <code>true</code> if and only if the
     * operation succeeds.
     */
    public abstract bool SetLastModifiedTime(File f, long time);

    /**
     * Mark the file or directory denoted by the given abstract pathname as
     * read-only, returning <code>true</code> if and only if the operation
     * succeeds.
     */
    public abstract bool SetReadOnly(File f);


    /* -- Filesystem interface -- */

    /**
     * List the available filesystem roots.
     */
    public abstract File[] ListRoots();

    /* -- Disk usage -- */
   public static int SPACE_TOTAL  = 0;
   public static int SPACE_FREE   = 1;
   public static int SPACE_USABLE = 2;

    public abstract long GetSpace(File f, int t);

    /* -- Basic infrastructure -- */

    /**
     * Compare two abstract pathnames lexicographically.
     */
    public abstract int Compare(File f1, File f2);

    /**
     * Compute the hash code of an abstract pathname.
     */
    public abstract int HashCode(File f);


}
