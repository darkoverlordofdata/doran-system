/**
 * An abstract representation of file and directory pathnames.
 *
 * <p> User interfaces and operating systems use system-dependent <em>pathname
 * strings</em> to name files and directories.  This class presents an
 * abstract, system-independent view of hierarchical pathnames.  An
 * <em>abstract pathname</em> has two components:
 *
 * <ol>
 * <li> An optional system-dependent <em>prefix</em> string,
 *      such as a disk-drive specifier, <code>"/"</code>&nbsp;for the UNIX root
 *      directory, or <code>"\\\\"</code>&nbsp;for a Microsoft Windows UNC pathname, and
 * <li> A sequence of zero or more string <em>names</em>.
 * </ol>
 *
 * The first name in an abstract pathname may be a directory name or, in the
 * case of Microsoft Windows UNC pathnames, a hostname.  Each subsequent name
 * in an abstract pathname denotes a directory; the last name may denote
 * either a directory or a file.  The <em>empty</em> abstract pathname has no
 * prefix and an empty name sequence.
 *
 * <p> The conversion of a pathname string to or from an abstract pathname is
 * inherently system-dependent.  When an abstract pathname is converted into a
 * pathname string, each name is separated from the next by a single copy of
 * the default <em>separator character</em>.  The default name-separator
 * character is defined by the system property <code>file.separator</code>, and
 * is made available in the public static fields <code>{@link
 * #separator}</code> and <code>{@link #separatorChar}</code> of this class.
 * When a pathname string is converted into an abstract pathname, the names
 * within it may be separated by the default name-separator character or by any
 * other name-separator character that is supported by the underlying system.
 *
 * <p> A pathname, whether abstract or in string form, may be either
 * <em>absolute</em> or <em>relative</em>.  An absolute pathname is complete in
 * that no other information is required in order to locate the file that it
 * denotes.  A relative pathname, in contrast, must be interpreted in terms of
 * information taken from some other pathname.  By default the classes in the
 * <code>java.io</code> package always resolve relative pathnames against the
 * current user directory.  This directory is named by the system property
 * <code>user.dir</code>, and is typically the directory in which the Java
 * virtual machine was invoked.
 *
 * <p> The <em>parent</em> of an abstract pathname may be obtained by invoking
 * the {@link #getParent} method of this class and consists of the pathname's
 * prefix and each name in the pathname's name sequence except for the last.
 * Each directory's absolute pathname is an ancestor of any <tt>File</tt>
 * object with an absolute abstract pathname which begins with the directory's
 * absolute pathname.  For example, the directory denoted by the abstract
 * pathname <tt>"/usr"</tt> is an ancestor of the directory denoted by the
 * pathname <tt>"/usr/local/bin"</tt>.
 *
 * <p> The prefix concept is used to handle root directories on UNIX platforms,
 * and drive specifiers, root directories and UNC pathnames on Microsoft Windows platforms,
 * as follows:
 *
 * <ul>
 *
 * <li> For UNIX platforms, the prefix of an absolute pathname is always
 * <code>"/"</code>.  Relative pathnames have no prefix.  The abstract pathname
 * denoting the root directory has the prefix <code>"/"</code> and an empty
 * name sequence.
 *
 * <li> For Microsoft Windows platforms, the prefix of a pathname that contains a drive
 * specifier consists of the drive letter followed by <code>":"</code> and
 * possibly followed by <code>"\\"</code> if the pathname is absolute.  The
 * prefix of a UNC pathname is <code>"\\\\"</code>; the hostname and the share
 * name are the first two names in the name sequence.  A relative pathname that
 * does not specify a drive has no prefix.
 *
 * </ul>
 *
 * <p> Instances of this class may or may not denote an actual file-system
 * object such as a file or a directory.  If it does denote such an object
 * then that object resides in a <i>partition</i>.  A partition is an
 * operating system-specific portion of storage for a file system.  A single
 * storage device (e.g. a physical disk-drive, flash memory, CD-ROM) may
 * contain multiple partitions.  The object, if any, will reside on the
 * partition <a name="partName">named</a> by some ancestor of the absolute
 * form of this pathname.
 *
 * <p> A file system may implement restrictions to certain operations on the
 * actual file-system object, such as reading, writing, and executing.  These
 * restrictions are collectively known as <i>access permissions</i>.  The file
 * system may have multiple sets of access permissions on a single object.
 * For example, one set may apply to the object's <i>owner</i>, and another
 * may apply to all other users.  The access permissions on an object may
 * cause some methods in this class to fail.
 *
 * <p> Instances of the <code>File</code> class are immutable; that is, once
 * created, the abstract pathname represented by a <code>File</code> object
 * will never change.
 *
 * <h3>Interoperability with {@code java.nio.file} package</h3>
 *
 * <p> The <a href="../../java/nio/file/package-summary.html">{@code java.nio.file}</a>
 * package defines interfaces and classes for the Java virtual machine to access
 * files, file attributes, and file systems. This API may be used to overcome
 * many of the limitations of the {@code java.io.File} class.
 * The {@link #toPath toPath} method may be used to obtain a {@link
 * Path} that uses the abstract path represented by a {@code File} object to
 * locate a file. The resulting {@code Path} may be used with the {@link
 * java.nio.file.Files} class to provide more efficient and extensive access to
 * additional file operations, file attributes, and I/O exceptions to help
 * diagnose errors when an operation on a file fails.
 *
 * @author  unascribed
 * @since   JDK1.0
 */
// public class System.IO.File : Comparable<File> 
public class System.IO.File : Comparable<File> 
{
    /**
     * The FileSystem object representing the platform's local file system.
     */
    private static FileSystem fs = DefaultFileSystem.GetFileSystem();
	
    /**
     * This abstract pathname's normalized pathname string. A normalized
     * pathname string uses the default name-separator character and does not
     * contain any duplicate or redundant separators.
     *
     * @serial
     */
    private string path;

    /**
     * Enum type that indicates the status of a file path.
     */
    private enum PathStatus { UNCHECKED, INVALID, CHECKED }

    /**
     * The flag indicating whether the file path is invalid.
     */
    private PathStatus status = PathStatus.UNCHECKED;

    /**
     * Check if the file has an invalid path. Currently, the inspection of
     * a file path is very limited, and it only covers Nul character check.
     * Returning true means the path is definitely invalid/garbage. But
     * returning false does not guarantee that the path is valid.
     *
     * @return true if the file path is invalid.
     */
    public bool IsInvalid() 
    {
        if (status == PathStatus.UNCHECKED) {
            status = (this.path == null || this.path == "")
                ? PathStatus.INVALID 
                : PathStatus.CHECKED;
        }
        return status == PathStatus.INVALID;
    }

    /**
     * The length of this abstract pathname's prefix, or zero if it has no
     * prefix.
     */
    private int prefixLength;

    /**
     * Returns the length of this abstract pathname's prefix.
     * For use by FileSystem classes.
     */
    public int GetPrefixLength() 
    {
        return prefixLength;
    }

    /**
     * The system-dependent default name-separator character.  This field is
     * initialized to contain the first character of the value of the system
     * property <code>file.separator</code>.  On UNIX systems the value of this
     * field is <code>'/'</code>; on Microsoft Windows systems it is <code>'\\'</code>.
     *
     * @see     java.lang.System#getProperty(java.lang.String)
     */
    public static char SeparatorChar = fs.GetSeparator();

    /**
     * The system-dependent default name-separator character, represented as a
     * string for convenience.  This string contains a single character, namely
     * <code>{@link #separatorChar}</code>.
     */
    public static string Separator = string.char(SeparatorChar);
    /**
     * The system-dependent path-separator character.  This field is
     * initialized to contain the first character of the value of the system
     * property <code>path.separator</code>.  This character is used to
     * separate filenames in a sequence of files given as a <em>path list</em>.
     * On UNIX systems, this character is <code>':'</code>; on Microsoft Windows systems it
     * is <code>';'</code>.
     *
     * @see     java.lang.System#getProperty(java.lang.String)
     */
    public static char PathSeparatorChar = fs.GetPathSeparator();

    /**
     * The system-dependent path-separator character, represented as a string
     * for convenience.  This string contains a single character, namely
     * <code>{@link #pathSeparatorChar}</code>.
     */
    public static string PathSeparator = string.char(PathSeparatorChar);

    /* -- Constructors -- */

    /**
     * Internal constructor for already-normalized pathname strings.
     */
    private File.WithLength(string pathname, int prefixLength) 
    {
        this.path = pathname;
        this.prefixLength = prefixLength;
    }

    /**
     * Internal constructor for already-normalized pathname strings.
     * The parameter order is used to disambiguate this method from the
     * public(File, String) constructor.
     */
    private File.WithParent(string child, File parent) 
    {
        assert(parent.path != null);
        assert(parent.path != "");
        this.path = fs.Resolve(parent.path, child);
        this.prefixLength = parent.prefixLength;
    }

    /**
     * Creates a new <code>File</code> instance by converting the given
     * pathname string into an abstract pathname.  If the given string is
     * the empty string, then the result is the empty abstract pathname.
     *
     * Creates a new <code>File</code> instance from a parent pathname string
     * and a child pathname string.
     *
     * <p> If <code>parent</code> is <code>null</code> then the new
     * <code>File</code> instance is created as if by invoking the
     * single-argument <code>File</code> constructor on the given
     * <code>child</code> pathname string.
     *
     * <p> Otherwise the <code>parent</code> pathname string is taken to denote
     * a directory, and the <code>child</code> pathname string is taken to
     * denote either a directory or a file.  If the <code>child</code> pathname
     * string is absolute then it is converted into a relative pathname in a
     * system-dependent way.  If <code>parent</code> is the empty string then
     * the new <code>File</code> instance is created by converting
     * <code>child</code> into an abstract pathname and resolving the result
     * against a system-dependent default directory.  Otherwise each pathname
     * string is converted into an abstract pathname and the child abstract
     * pathname is resolved against the parent.
     *
     * @param   parent  The parent pathname string
     * @param   child   The child pathname string
     * @throws  NullPointerException
     *          If <code>child</code> is <code>null</code>
     */
	public File(string? parent, string? child = null) 
	{
        if (parent == null && child == null) 
            throw new Exception.NullPointerException("new File pathname");

        if (child == null)
        {
            this.path = fs.Normalize(parent);
        }
        else if (parent != null) {
            if (parent == "") {
                this.path = fs.Resolve(fs.GetDefaultParent(),
                                       fs.Normalize(child));
            } else {
                this.path = fs.Resolve(fs.Normalize(parent),
                                       fs.Normalize(child));
            }
        } else {
            this.path = fs.Normalize(child);
        }

        this.prefixLength = fs.PrefixLength(this.path);
	} 

    /**
     * Creates a new <code>File</code> instance from a parent abstract
     * pathname and a child pathname string.
     *
     * <p> If <code>parent</code> is <code>null</code> then the new
     * <code>File</code> instance is created as if by invoking the
     * single-argument <code>File</code> constructor on the given
     * <code>child</code> pathname string.
     *
     * <p> Otherwise the <code>parent</code> abstract pathname is taken to
     * denote a directory, and the <code>child</code> pathname string is taken
     * to denote either a directory or a file.  If the <code>child</code>
     * pathname string is absolute then it is converted into a relative
     * pathname in a system-dependent way.  If <code>parent</code> is the empty
     * abstract pathname then the new <code>File</code> instance is created by
     * converting <code>child</code> into an abstract pathname and resolving
     * the result against a system-dependent default directory.  Otherwise each
     * pathname string is converted into an abstract pathname and the child
     * abstract pathname is resolved against the parent.
     *
     * @param   parent  The parent abstract pathname
     * @param   child   The child pathname string
     * @throws  NullPointerException
     *          If <code>child</code> is <code>null</code>
     */
    public File.From(File? parent, string? child)
    {
        if (child == null) {
            throw new Exception.NullPointerException("new File child");
        }
        if (parent != null) {
            if (parent.path == "") {
                this.path = fs.Resolve(fs.GetDefaultParent(),
                                       fs.Normalize(child));
            } else {
                this.path = fs.Resolve(parent.path,
                                       fs.Normalize(child));
            }
        } else {
            this.path = fs.Normalize(child);
        }
        this.prefixLength = fs.PrefixLength(this.path);
    }

    /* -- Path-component accessors -- */

    /**
     * Returns the name of the file or directory denoted by this abstract
     * pathname.  This is just the last name in the pathname's name
     * sequence.  If the pathname's name sequence is empty, then the empty
     * string is returned.
     *
     * @return  The name of the file or directory denoted by this abstract
     *          pathname, or the empty string if this pathname's name sequence
     *          is empty
     */
	public string GetName() 
	{
        int index = path.last_index_of(Separator);
        if (index < prefixLength) return path.substring(prefixLength);
        return path.substring(index + 1);
	}

    /**
     * Returns the pathname string of this abstract pathname's parent, or
     * <code>null</code> if this pathname does not name a parent directory.
     *
     * <p> The <em>parent</em> of an abstract pathname consists of the
     * pathname's prefix, if any, and each name in the pathname's name
     * sequence except for the last.  If the name sequence is empty then
     * the pathname does not name a parent directory.
     *
     * @return  The pathname string of the parent directory named by this
     *          abstract pathname, or <code>null</code> if this pathname
     *          does not name a parent
     */
	public string GetParent() 
	{
        int index = path.last_index_of(Separator);
        if (index < prefixLength) {
            if ((prefixLength > 0) && (path.length > prefixLength))
                return path.substring(0, prefixLength);
            return null;
        }
        return path.substring(0, index);
	}

    /**
     * Returns the abstract pathname of this abstract pathname's parent,
     * or <code>null</code> if this pathname does not name a parent
     * directory.
     *
     * <p> The <em>parent</em> of an abstract pathname consists of the
     * pathname's prefix, if any, and each name in the pathname's name
     * sequence except for the last.  If the name sequence is empty then
     * the pathname does not name a parent directory.
     *
     * @return  The abstract pathname of the parent directory named by this
     *          abstract pathname, or <code>null</code> if this pathname
     *          does not name a parent
     *
     * @since 1.2
     */
    public File GetParentFile() 
    {
        string? p = this.GetParent();
        if (p == null) return null;
        return new File.WithLength(p, this.prefixLength);
    }


    /**
     * Converts this abstract pathname into a pathname string.  The resulting
     * string uses the {@link #separator default name-separator character} to
     * separate the names in the name sequence.
     *
     * @return  The string form of this abstract pathname
     */
	public string GetPath() 
	{
		return path;
	}

    /* -- Path operations -- */

    /**
     * Tests whether this abstract pathname is absolute.  The definition of
     * absolute pathname is system dependent.  On UNIX systems, a pathname is
     * absolute if its prefix is <code>"/"</code>.  On Microsoft Windows systems, a
     * pathname is absolute if its prefix is a drive specifier followed by
     * <code>"\\"</code>, or if its prefix is <code>"\\\\"</code>.
     *
     * @return  <code>true</code> if this abstract pathname is absolute,
     *          <code>false</code> otherwise
     */
    public bool IsAbsolute() 
    {
        return fs.IsAbsolute(this);
    }


    /**
     * Returns the absolute pathname string of this abstract pathname.
     *
     * <p> If this abstract pathname is already absolute, then the pathname
     * string is simply returned as if by the <code>{@link #getPath}</code>
     * method.  If this abstract pathname is the empty abstract pathname then
     * the pathname string of the current user directory, which is named by the
     * system property <code>user.dir</code>, is returned.  Otherwise this
     * pathname is resolved in a system-dependent way.  On UNIX systems, a
     * relative pathname is made absolute by resolving it against the current
     * user directory.  On Microsoft Windows systems, a relative pathname is made absolute
     * by resolving it against the current directory of the drive named by the
     * pathname, if any; if not, it is resolved against the current user
     * directory.
     *
     * @return  The absolute pathname string denoting the same file or
     *          directory as this abstract pathname
     *
     * @throws  SecurityException
     *          If a required system property value cannot be accessed.
     *
     * @see     java.io.File#isAbsolute()
     */
    public string GetAbsolutePath() 
    {
        return fs.ResolveFile(this);
    }

    /**
     * Returns the absolute form of this abstract pathname.  Equivalent to
     * <code>new&nbsp;File(this.{@link #getAbsolutePath})</code>.
     *
     * @return  The absolute abstract pathname denoting the same file or
     *          directory as this abstract pathname
     *
     * @throws  SecurityException
     *          If a required system property value cannot be accessed.
     *
     * @since 1.2
     */
    public File GetAbsoluteFile() 
    {
        string absPath = GetAbsolutePath();
        return new File.WithLength(absPath, fs.PrefixLength(absPath));
    }

    /**
     * Returns the canonical pathname string of this abstract pathname.
     *
     * <p> A canonical pathname is both absolute and unique.  The precise
     * definition of canonical form is system-dependent.  This method first
     * converts this pathname to absolute form if necessary, as if by invoking the
     * {@link #getAbsolutePath} method, and then maps it to its unique form in a
     * system-dependent way.  This typically involves removing redundant names
     * such as <tt>"."</tt> and <tt>".."</tt> from the pathname, resolving
     * symbolic links (on UNIX platforms), and converting drive letters to a
     * standard case (on Microsoft Windows platforms).
     *
     * <p> Every pathname that denotes an existing file or directory has a
     * unique canonical form.  Every pathname that denotes a nonexistent file
     * or directory also has a unique canonical form.  The canonical form of
     * the pathname of a nonexistent file or directory may be different from
     * the canonical form of the same pathname after the file or directory is
     * created.  Similarly, the canonical form of the pathname of an existing
     * file or directory may be different from the canonical form of the same
     * pathname after the file or directory is deleted.
     *
     * @return  The canonical pathname string denoting the same file or
     *          directory as this abstract pathname
     *
     * @throws  IOException
     *          If an I/O error occurs, which is possible because the
     *          construction of the canonical pathname may require
     *          filesystem queries
     *
     * @throws  SecurityException
     *          If a required system property value cannot be accessed, or
     *          if a security manager exists and its <code>{@link
     *          java.lang.SecurityManager#checkRead}</code> method denies
     *          read access to the file
     *
     * @since   JDK1.1
     * @see     Path#toRealPath
     */
    public string GetCanonicalPath() throws IOException 
    {
        if (IsInvalid()) {
            throw new IOException.Exception("Invalid file path");
        }
        return fs.Canonicalize(fs.ResolveFile(this));
    }

    /**
     * Returns the canonical form of this abstract pathname.  Equivalent to
     * <code>new&nbsp;File(this.{@link #getCanonicalPath})</code>.
     *
     * @return  The canonical pathname string denoting the same file or
     *          directory as this abstract pathname
     *
     * @throws  IOException
     *          If an I/O error occurs, which is possible because the
     *          construction of the canonical pathname may require
     *          filesystem queries
     *
     * @throws  SecurityException
     *          If a required system property value cannot be accessed, or
     *          if a security manager exists and its <code>{@link
     *          java.lang.SecurityManager#checkRead}</code> method denies
     *          read access to the file
     *
     * @since 1.2
     * @see     Path#toRealPath
     */
    public File GetCanonicalFile() throws IOException 
    {
        string canonPath = GetCanonicalPath();
        return new File.WithLength(canonPath, fs.PrefixLength(canonPath));
    }

    /* -- Attribute accessors -- */

    /**
     * Tests whether the application can read the file denoted by this
     * abstract pathname. On some platforms it may be possible to start the
     * Java virtual machine with special privileges that allow it to read
     * files that are marked as unreadable. Consequently this method may return
     * {@code true} even though the file does not have read permissions.
     *
     * @return  <code>true</code> if and only if the file specified by this
     *          abstract pathname exists <em>and</em> can be read by the
     *          application; <code>false</code> otherwise
     *
     * @throws  SecurityException
     *          If a security manager exists and its <code>{@link
     *          java.lang.SecurityManager#checkRead(java.lang.String)}</code>
     *          method denies read access to the file
     */
    public bool CanRead() 
    {
        if (IsInvalid()) {
            return false;
        }
        return fs.CheckAccess(this, FileSystem.ACCESS_READ);
    }

    /**
     * Tests whether the application can modify the file denoted by this
     * abstract pathname. On some platforms it may be possible to start the
     * Java virtual machine with special privileges that allow it to modify
     * files that are marked read-only. Consequently this method may return
     * {@code true} even though the file is marked read-only.
     *
     * @return  <code>true</code> if and only if the file system actually
     *          contains a file denoted by this abstract pathname <em>and</em>
     *          the application is allowed to write to the file;
     *          <code>false</code> otherwise.
     *
     * @throws  SecurityException
     *          If a security manager exists and its <code>{@link
     *          java.lang.SecurityManager#checkWrite(java.lang.String)}</code>
     *          method denies write access to the file
     */
    public bool CanWrite() 
    {
        if (IsInvalid()) {
            return false;
        }
        return fs.CheckAccess(this, FileSystem.ACCESS_WRITE);
    }

    /**
     * Tests whether the file or directory denoted by this abstract pathname
     * exists.
     *
     * @return  <code>true</code> if and only if the file or directory denoted
     *          by this abstract pathname exists; <code>false</code> otherwise
     *
     * @throws  SecurityException
     *          If a security manager exists and its <code>{@link
     *          java.lang.SecurityManager#checkRead(java.lang.String)}</code>
     *          method denies read access to the file or directory
     */
	public bool Exists() 
	{
        if (IsInvalid()) {
            return false;
        }
        return ((fs.GetBooleanAttributes(this) & FileSystem.BA_EXISTS) != 0);
	}

    /**
     * Tests whether the file denoted by this abstract pathname is a
     * directory.
     *
     * <p> Where it is required to distinguish an I/O exception from the case
     * that the file is not a directory, or where several attributes of the
     * same file are required at the same time, then the {@link
     * java.nio.file.Files#readAttributes(Path,Class,LinkOption[])
     * Files.readAttributes} method may be used.
     *
     * @return <code>true</code> if and only if the file denoted by this
     *          abstract pathname exists <em>and</em> is a directory;
     *          <code>false</code> otherwise
     *
     * @throws  SecurityException
     *          If a security manager exists and its <code>{@link
     *          java.lang.SecurityManager#checkRead(java.lang.String)}</code>
     *          method denies read access to the file
     */
	public bool IsDirectory() 
	{
        if (IsInvalid()) {
            return false;
        }
        return ((fs.GetBooleanAttributes(this) & FileSystem.BA_DIRECTORY) != 0);
	}

    /**
     * Tests whether the file denoted by this abstract pathname is a normal
     * file.  A file is <em>normal</em> if it is not a directory and, in
     * addition, satisfies other system-dependent criteria.  Any non-directory
     * file created by a Java application is guaranteed to be a normal file.
     *
     * <p> Where it is required to distinguish an I/O exception from the case
     * that the file is not a normal file, or where several attributes of the
     * same file are required at the same time, then the {@link
     * java.nio.file.Files#readAttributes(Path,Class,LinkOption[])
     * Files.readAttributes} method may be used.
     *
     * @return  <code>true</code> if and only if the file denoted by this
     *          abstract pathname exists <em>and</em> is a normal file;
     *          <code>false</code> otherwise
     *
     * @throws  SecurityException
     *          If a security manager exists and its <code>{@link
     *          java.lang.SecurityManager#checkRead(java.lang.String)}</code>
     *          method denies read access to the file
     */
	public bool IsFile() 
	{
        if (IsInvalid()) {
            return false;
        }
        return ((fs.GetBooleanAttributes(this) & FileSystem.BA_REGULAR) != 0);
	}

    /**
     * Returns the length of the file denoted by this abstract pathname.
     * The return value is unspecified if this pathname denotes a directory.
     *
     * <p> Where it is required to distinguish an I/O exception from the case
     * that {@code 0L} is returned, or where several attributes of the same file
     * are required at the same time, then the {@link
     * java.nio.file.Files#readAttributes(Path,Class,LinkOption[])
     * Files.readAttributes} method may be used.
     *
     * @return  The length, in bytes, of the file denoted by this abstract
     *          pathname, or <code>0L</code> if the file does not exist.  Some
     *          operating systems may return <code>0L</code> for pathnames
     *          denoting system-dependent entities such as devices or pipes.
     *
     * @throws  SecurityException
     *          If a security manager exists and its <code>{@link
     *          java.lang.SecurityManager#checkRead(java.lang.String)}</code>
     *          method denies read access to the file
     */
	public long Length() 
	{
        if (IsInvalid()) {
            return 0L;
        }
		return fs.GetLength(this);
	}
	
    /**
     * Returns an array of strings naming the files and directories in the
     * directory denoted by this abstract pathname.
     *
     * <p> If this abstract pathname does not denote a directory, then this
     * method returns {@code null}.  Otherwise an array of strings is
     * returned, one for each file or directory in the directory.  Names
     * denoting the directory itself and the directory's parent directory are
     * not included in the result.  Each string is a file name rather than a
     * complete path.
     *
     * <p> There is no guarantee that the name strings in the resulting array
     * will appear in any specific order; they are not, in particular,
     * guaranteed to appear in alphabetical order.
     *
     * <p> Note that the {@link java.nio.file.Files} class defines the {@link
     * java.nio.file.Files#newDirectoryStream(Path) newDirectoryStream} method to
     * open a directory and iterate over the names of the files in the directory.
     * This may use less resources when working with very large directories, and
     * may be more responsive when working with remote directories.
     *
     * @return  An array of strings naming the files and directories in the
     *          directory denoted by this abstract pathname.  The array will be
     *          empty if the directory is empty.  Returns {@code null} if
     *          this abstract pathname does not denote a directory, or if an
     *          I/O error occurs.
     *
     * @throws  SecurityException
     *          If a security manager exists and its {@link
     *          SecurityManager#checkRead(String)} method denies read access to
     *          the directory
     */
	public string[] List() 
	{
        if (IsInvalid()) {
            return null;
        }
        return fs.List(this);
	}

    /**
     * Compares two abstract pathnames lexicographically.  The ordering
     * defined by this method depends upon the underlying system.  On UNIX
     * systems, alphabetic case is significant in comparing pathnames; on Microsoft Windows
     * systems it is not.
     *
     * @param   pathname  The abstract pathname to be compared to this abstract
     *                    pathname
     *
     * @return  Zero if the argument is equal to this abstract pathname, a
     *          value less than zero if this abstract pathname is
     *          lexicographically less than the argument, or a value greater
     *          than zero if this abstract pathname is lexicographically
     *          greater than the argument
     *
     * @since   1.2
     */
    public override int CompareTo(File pathname) 
    {
        return fs.Compare(this, pathname);
    }
}