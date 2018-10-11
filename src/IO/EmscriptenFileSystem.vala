#if (__EMSCRIPTEN__)
using System.Collections.Generic;
/**
 * FileSystem for Windows NT/2000.
 *
 * @author Konstantin Kladko
 * @since 1.4
 */
public class System.IO.EmscriptenFileSystem : FileSystem 
{
    private char slash;
    private char altSlash;
    private char semicolon;

    public EmscriptenFileSystem() 
    {
        slash = '/';
        semicolon = ';';
        altSlash = (this.slash == '\\') ? '/' : '\\';
    }

    private bool IsSlash(char c) 
    {
        return (c == '\\') || (c == '/');
    }

    private bool IsLetter(char c) 
    {
        return ((c >= 'a') && (c <= 'z')) || ((c >= 'A') && (c <= 'Z'));
    }

    private string Slashify(string p) 
    {
        if ((p.length > 0) && (p[0] != slash)) return string.char(slash) + p;
        else return p;
    }

    /* -- Normalization and construction -- */

    public override char GetSeparator() 
    {
        return slash;
    }

    public override char GetPathSeparator() 
    {
        return semicolon;
    }

    /* Check that the given pathname is normal.  If not, invoke the real
       normalizer on the part of the pathname that requires normalization.
       This way we iterate through the whole pathname string only once. */
    public override string Normalize(string path) 
    {
        int n = path.length;
        char slash = this.slash;
        char altSlash = this.altSlash;
        char prev = 0;
        for (int i = 0; i < n; i++) {
            char c = path[i];
            if (c == altSlash)
                return Normalize2(path, n, (prev == slash) ? i - 1 : i);
            if ((c == slash) && (prev == slash) && (i > 1))
                return Normalize2(path, n, i - 1);
            if ((c == ':') && (i > 1))
                return Normalize2(path, n, 0);
            prev = c;
        }
        if (prev == slash) return Normalize2(path, n, n - 1);
        return path;
    }

    /* Normalize the given pathname, whose length is len, starting at the given
       offset; everything before this offset is already normal. */
    private string Normalize2(string path, int len, int off) 
    {
        if (len == 0) return path;
        if (off < 3) off = 0;   /* Avoid fencepost cases with UNC pathnames */
        int src;
        char slash = this.slash;
        StringBuilder sb = new StringBuilder();

        if (off == 0) {
            /* Complete normalization, including prefix */
            src = NormalizePrefix(path, len, sb);
        } else {
            /* Partial normalization */
            src = off;
            sb.append(path.substring(0, off));
        }

        /* Remove redundant slashes from the remainder of the path, forcing all
           slashes into the preferred slash */
        while (src < len) {
            char c = path[src++];
            if (IsSlash(c)) {
                while ((src < len) && IsSlash(path[src])) src++;
                if (src == len) {
                    /* Check for trailing separator */
                    int sn = (int)sb.len;
                    if ((sn == 2) && (sb.data[1] == ':')) {
                        /* "z:\\" */
                        sb.append_c(slash);
                        break;
                    }
                    if (sn == 0) {
                        /* "\\" */
                        sb.append_c(slash);
                        break;
                    }
                    if ((sn == 1) && (IsSlash((char)sb.data[0]))) {
                        /* "\\\\" is not collapsed to "\\" because "\\\\" marks
                           the beginning of a UNC pathname.  Even though it is
                           not, by itself, a valid UNC pathname, we leave it as
                           is in order to be consistent with the win32 APIs,
                           which treat this case as an invalid UNC pathname
                           rather than as an alias for the root directory of
                           the current drive. */
                        sb.append_c(slash);
                        break;
                    }
                    /* Path does not denote a root directory, so do not append
                       trailing slash */
                    break;
                } else {
                    sb.append_c(slash);
                }
            } else {
                sb.append_c(c);
            }
        }

        string rv = sb.str;
        return rv;
    }

    /* A normal Win32 pathname contains no duplicate slashes, except possibly
       for a UNC prefix, and does not end with a slash.  It may be the empty
       string.  Normalized Win32 pathnames have the convenient property that
       the length of the prefix almost uniquely identifies the type of the path
       and whether it is absolute or relative:

           0  relative to both drive and directory
           1  drive-relative (begins with '\\')
           2  absolute UNC (if first char is '\\'),
                else directory-relative (has form "z:foo")
           3  absolute local pathname (begins with "z:\\")
     */
    private int NormalizePrefix(string path, int len, StringBuilder sb) 
    {
        int src = 0;
        while ((src < len) && IsSlash(path[src])) src++;
        char c = 0;
        if ((len - src >= 2)
            && IsLetter(c = path[src])
            && path[src + 1] == ':') {
            /* Remove leading slashes if followed by drive specifier.
               This hack is necessary to support file URLs containing drive
               specifiers (e.g., "file://c:/path").  As a side effect,
               "/c:/path" can be used as an alternative to "c:/path". */
            sb.append_c(c);
            sb.append_c(':');
            src += 2;
        } else {
            src = 0;
            if ((len >= 2)
                && IsSlash(path[0])
                && IsSlash(path[1])) {
                /* UNC pathname: Retain first slash; leave src pointed at
                   second slash so that further slashes will be collapsed
                   into the second slash.  The result will be a pathname
                   beginning with "\\\\" followed (most likely) by a host
                   name. */
                src = 1;
                sb.append_c(slash);
            }
        }
        return src;
    }

    public override int PrefixLength(string path) 
    {
        char slash = this.slash;
        int n = path.length;
        if (n == 0) return 0;
        char c0 = path[0];
        char c1 = (n > 1) ? path[1] : 0;
        if (c0 == slash) {
            if (c1 == slash) return 2;  /* Absolute UNC pathname "\\\\foo" */
            return 1;                   /* Drive-relative "\\foo" */
        }
        if (IsLetter(c0) && (c1 == ':')) {
            if ((n > 2) && (path[2] == slash))
                return 3;               /* Absolute local pathname "z:\\foo" */
            return 2;                   /* Directory-relative "z:foo" */
        }
        return 0;                       /* Completely relative */
    }

    public override string Resolve(string parent, string child) 
    {
        int pn = parent.length;
        if (pn == 0) return child;
        int cn = child.length;
        if (cn == 0) return parent;

        string c = child;
        int childStart = 0;
        int parentEnd = pn;

        if ((cn > 1) && (c[0] == slash)) {
            if (c[1] == slash) {
                /* Drop prefix when child is a UNC pathname */
                childStart = 2;
            } else {
                /* Drop prefix when child is drive-relative */
                childStart = 1;

            }
            if (cn == childStart) { // Child is double slash
                if (parent[pn - 1] == slash)
                    return parent.substring(0, pn - 1);
                return parent;
            }
        }

        if (parent[pn - 1] == slash)
            parentEnd--;

        int len = parentEnd + cn - childStart;
        char[] theChars = null;
        if (child[childStart] == slash) {
            theChars = new char[len];
            parent.get_chars(0, parentEnd, theChars, 0);
            child.get_chars(childStart, cn, theChars, parentEnd);
        } else {
            theChars = new char[len + 1];
            parent.get_chars(0, parentEnd, theChars, 0);
            theChars[parentEnd] = slash;
            child.get_chars(childStart, cn, theChars, parentEnd + 1);
        }
        return string.strndup(theChars, theChars.length);
    }

    public override string GetDefaultParent() 
    {
        return "" + string.char(slash);
    }

    public override string FromURIPath(string path) 
    {
        string p = path;
        if ((p.length > 2) && (p[2] == ':')) {
            // "/c:/foo" --> "c:/foo"
            p = p.substring(1);
            // "c:/foo/" --> "c:/foo", but "c:/" --> "c:/"
            if ((p.length > 3) && p.ends_with("/"))
                p = p.substring(0, p.length - 1);
        } else if ((p.length > 1) && p.ends_with("/")) {
            // "/foo/" --> "/foo"
            p = p.substring(0, p.length - 1);
        }
        return p;
    }

    /* -- Path operations -- */

    public override bool IsAbsolute(File f) 
    {
        int pl = f.GetPrefixLength();
        return (((pl == 2) && (f.GetPath()[0] == slash))
                || (pl == 3));
    }

    public override string ResolveFile(File f) 
    {
        string path = f.GetPath();
        int pl = f.GetPrefixLength();
        if ((pl == 2) && (path[0] == slash))
            return path;                        /* UNC */
        if (pl == 3)
            return path;                        /* Absolute local */
        if (pl == 0)
            return GetUserPath() + Slashify(path); /* Completely relative */
        if (pl == 1) {                          /* Drive-relative */
            string up = GetUserPath();
            string ud = GetDrive(up);
            if (ud != null) return ud + path;
            return up + path;                   /* User dir is a UNC path */
        }
        if (pl == 2) {                          /* Directory-relative */
            string up = GetUserPath();
            string ud = GetDrive(up);
            if ((ud != null) && path.starts_with(ud))
                return up + Slashify(path.substring(2));
            char drive = path[0];
            string dir = GetDriveDirectory(drive);
            string np;
            if (dir != null) {
                /* When resolving a directory-relative path that refers to a
                   drive other than the current drive, insist that the caller
                   have read permission on the result */
                string p = string.char(drive) + ":" + dir + Slashify(path.substring(2));
                return p;
            }
            return string.char(drive) + ":" + Slashify(path.substring(2)); /* fake it */
        }
        throw new IOException.InternalError("Unresolvable path: " + path);
    }

    private string GetUserPath() 
    {
        /* For both compatibility and security,
           we must look this up every time */
        return Normalize(".");
        // return Normalize(System.getProperty("user.dir"));
    }

    private string GetDrive(string path) 
    {
        int pl = PrefixLength(path);
        return (pl == 3) ? path.substring(0, 2) : null;
    }

    private static string[] driveDirCache = new string[26];

    private static int DriveIndex(char d) 
    {
        if ((d >= 'a') && (d <= 'z')) return d - 'a';
        if ((d >= 'A') && (d <= 'Z')) return d - 'A';
        return -1;
    }

    private string GetDriveDirectory(char drive) 
    {
        int i = DriveIndex(drive);
        if (i < 0) return null;
        string s = driveDirCache[i];
        if (s != null) return s;
        // s = getDriveDirectory(i + 1);
        // driveDirCache[i] = s;
        return s;
    }

    // Caches for canonicalization results to improve startup performance.
    // The first cache handles repeated canonicalizations of the same path
    // name. The prefix cache handles repeated canonicalizations within the
    // same directory, and must not create results differing from the true
    // canonicalization algorithm in canonicalize_md.c. For this reason the
    // prefix cache is conservative and is not used for complex path names.
    private Dictionary<string,string> Cache       = new Dictionary<string,string>();
    private Dictionary<string,string> PrefixCache = new Dictionary<string,string>();

    public override string Canonicalize(string path) throws IOException 
    {
        // If path is a drive letter only then skip canonicalization
        int len = path.length;
        if ((len == 2) &&
            (IsLetter(path[0])) &&
            (path[1] == ':')) {
            char c = path[0];
            if ((c >= 'A') && (c <= 'Z'))
                return path;
            return "" + string.char(c-32) + ":";
        } else if ((len == 3) &&
                   (IsLetter(path[0])) &&
                   (path[1] == ':') &&
                   (path[2] == '\\')) {
            char c = path[0];
            if ((c >= 'A') && (c <= 'Z'))
                return path;
            return "" + string.char(c-32) + ":\\";
        }
        if (!UseCanonCaches) {
            return canonicalize0(path);
        } else {
            string res = Cache[path];
            if (res == null) {
                string dir = null;
                string resDir = null;
                if (UseCanonPrefixCache) {
                    dir = ParentOrNull(path);
                    if (dir != null) {
                        resDir = PrefixCache[dir];
                        if (resDir != null) {
                            /*
                             * Hit only in prefix cache; full path is canonical,
                             * but we need to get the canonical name of the file
                             * in this directory to get the appropriate
                             * capitalization
                             */
                            string filename = path.substring(1 + dir.length);
                            res = CanonicalizeWithPrefix(resDir, filename);
                            Cache[dir + File.Separator + filename] = res;
                        }
                    }
                }
                if (res == null) {
                    res = canonicalize0(path);
                    Cache[path] = res;
                    if (UseCanonPrefixCache && dir != null) {
                        resDir = ParentOrNull(res);
                        if (resDir != null) {
                            File f = new File(res);
                            if (f.Exists() && !f.IsDirectory()) {
                                PrefixCache[dir] = resDir;
                            }
                        }
                    }
                }
            }
            return res;
        }
    }

    private string CanonicalizeWithPrefix(string canonicalPrefix,
            string filename) throws IOException
    {
        return canonicalizeWithPrefix0(canonicalPrefix,
                canonicalPrefix + File.Separator + filename);
    }

    // Best-effort attempt to get parent of this path; used for
    // optimization of filename canonicalization. This must return null for
    // any cases where the code in canonicalize_md.c would throw an
    // exception or otherwise deal with non-simple pathnames like handling
    // of "." and "..". It may conservatively return null in other
    // situations as well. Returning null will cause the underlying
    // (expensive) canonicalization routine to be called.
    private static string ParentOrNull(string path) 
    {
        if (path == null) return null;
        char sep = File.SeparatorChar;
        char altSep = '/';
        int last = path.length - 1;
        int idx = last;
        int adjacentDots = 0;
        int nonDotCount = 0;
        while (idx > 0) {
            char c = path[idx];
            if (c == '.') {
                if (++adjacentDots >= 2) {
                    // Punt on pathnames containing . and ..
                    return null;
                }
                if (nonDotCount == 0) {
                    // Punt on pathnames ending in a .
                    return null;
                }
            } else if (c == sep) {
                if (adjacentDots == 1 && nonDotCount == 0) {
                    // Punt on pathnames containing . and ..
                    return null;
                }
                if (idx == 0 ||
                    idx >= last - 1 ||
                    path[idx - 1] == sep ||
                    path[idx - 1] == altSep) {
                    // Punt on pathnames containing adjacent slashes
                    // toward the end
                    return null;
                }
                return path.substring(0, idx);
            } else if (c == altSep) {
                // Punt on pathnames containing both backward and
                // forward slashes
                return null;
            } else if (c == '*' || c == '?') {
                // Punt on pathnames containing wildcards
                return null;
            } else {
                ++nonDotCount;
                adjacentDots = 0;
            }
            --idx;
        }
        return null;
    }

    /* -- Attribute accessors -- */

    private string canonicalize0(string path)
            throws IOException 
    {
        return path;
    }

    // Run the canonicalization operation assuming that the prefix
    // (everything up to the last filename) is canonical; just gets
    // the canonical name of the last element of the path
    private string canonicalizeWithPrefix0(string canonicalPrefix,
            string pathWithCanonicalPrefix)
            throws IOException 
    {
        return pathWithCanonicalPrefix;
    }

    public override int GetBooleanAttributes(File f)
    {
        Stdio.FILE handle;
		Stdio.Stat s;
		handle = Stdio.fopen(f.GetPath(), "r");
		// Stdio.fstat(handle.fileno(), out s);
		// return (int)s.st_mode;
        return 0;
    }

    public override bool CheckAccess(File f, int access)
    {
        Stdio.FILE handle;
		Stdio.Stat s;
		handle = Stdio.fopen(f.GetPath(), "r");
		// Stdio.fstat(handle.fileno(), out s);
        // return ((int)s.st_mode & access) != 0;
        return false;
    }

    public override long GetLastModifiedTime(File f)
    {
        return 0;
    }

    public override long GetLength(File f) 
    {
        Stdio.FILE handle;
		Stdio.Stat s;
		handle = Stdio.fopen(f.GetPath(), "r");
		// Stdio.fstat(handle.fileno(), out s);
		// return (int)s.st_size;
        return 0;
    }

    public override bool SetPermission(File f, int access, bool enable,
            bool owneronly)
    {
        return false;
    }

    /* -- File operations -- */

    public override bool CreateFileExclusively(string path)
            throws IOException 
    {
        return false;
    }

    public override string[] List(File f)
    {
        return new string[0];
    }

    public override bool CreateDirectory(File f)
    {
        return false;
    }

    public override bool SetLastModifiedTime(File f, long time)
    {
        return false;
    }

    public override bool SetReadOnly(File f)
    {
        return false;
    }

    // private bool delete0(File f){}

    // private bool rename0(File f1, File f2){}

    // private static int listRoots0(){}

    // private long getSpace0(File f, int t){}

    // private static void initIDs(){}

    // static construct {
    //     initIDs();
    // }

    public override bool Delete(File f) 
    {
        // Keep canonicalization caches in sync after file deletion
        // and renaming operations. Could be more clever than this
        // (i.e., only remove/update affected entries) but probably
        // not worth it since these entries expire after 30 seconds
        // anyway.
        Cache.Clear();
        PrefixCache.Clear();
        // return delete0(f);
        return false;
    }

    public override bool Rename(File f1, File f2) 
    {
        // Keep canonicalization caches in sync after file deletion
        // and renaming operations. Could be more clever than this
        // (i.e., only remove/update affected entries) but probably
        // not worth it since these entries expire after 30 seconds
        // anyway.
        Cache.Clear();
        PrefixCache.Clear();
        // return rename0(f1, f2);
        return false;
    }

    /* -- Filesystem interface -- */

    public override File[] ListRoots() 
    {
        int ds = 0; //listRoots0();
        int n = 0;
        for (int i = 0; i < 26; i++) {
            if (((ds >> i) & 1) != 0) {
                char drive = 'A' + (char)i;
                if (!Access(string.char(drive) + ":" + string.char(slash)))
                    ds &= ~(1 << i);
                else
                    n++;
            }
        }
        File[] fs = new File[n];
        int j = 0;
        char slash = this.slash;
        for (int i = 0; i < 26; i++) {
            if (((ds >> i) & 1) != 0) {
                char drive = 'A' + (char)i;
                fs[j++] = new File(string.char(drive) + ":" + string.char(slash));
            }
        }
        return fs;
    }

    private bool Access(string path) 
    {
        return path.down() == "c:"+string.char(slash);
        // try {
        //     SecurityManager security = System.getSecurityManager();
        //     if (security != null) security.checkRead(path);
        //     return true;
        // } catch (SecurityException x) {
        //     return false;
        // }
    }

    /* -- Disk usage -- */

    public override long GetSpace(File f, int t) 
    {
        if (f.Exists()) {
            return 0; //getSpace0(f, t);
        }
        return 0;
    }

    /* -- Basic infrastructure -- */

    public override int Compare(File f1, File f2) 
    {
        return f1.GetPath().CompareTo(f2.GetPath());
    }

    public override int HashCode(File f) 
    {
        /* Could make this more efficient: string.hashCodeIgnoreCase */
        return (int)f.GetPath().down().hash() ^ 1234321;
    }

}
#endif
