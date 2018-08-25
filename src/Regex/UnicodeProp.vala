using System.Collections.Generic;

public enum System.Regex.UnicodeProp 
{
    ALPHABETIC,
    LETTER,
    IDEOGRAPHIC,
    LOWERCASE,
    UPPERCASE,
    TITLECASE,
    WHITE_SPACE,
    CONTROL,
    PUNCTUATION,
    HEX_DIGIT,
    ASSIGNED,
    NONCHARACTER_CODE_POINT,
    DIGIT,
    ALNUM,
    BLANK,
    GRAPH,
    PRINT,
    WORD,
    JOIN_CONTROL;
    /* shim resets the syntax highlighting in VSCode */
    private void shim() {}

    public bool Is(int ch)
    {
        switch(this)
        {
            case ALPHABETIC: 
                return Character.IsAlphabetic(ch);

            case LETTER:
                return Character.IsLetter(ch);

            // case IDEOGRAPHIC:
            //     return Character.IsIdeographic(ch);

            case LOWERCASE:
                return Character.IsLowerCase(ch);

            case UPPERCASE:
                return Character.IsUpperCase(ch);

            case TITLECASE:
                return Character.IsTitleCase(ch);

            case WHITE_SPACE:
                // \p{Whitespace}
                return ((((1 << UnicodeType.SPACE_SEPARATOR) |
                        (1 << UnicodeType.LINE_SEPARATOR) |
                        (1 << UnicodeType.PARAGRAPH_SEPARATOR)) >> Character.GetType(ch)) & 1)
                    != 0 || (ch >= 0x9 && ch <= 0xd) || (ch == 0x85);

            case CONTROL:
                // \p{gc=Control}
                return Character.GetType(ch) == UnicodeType.CONTROL;

            case PUNCTUATION:
                // \p{gc=Punctuation}
                return ((((1 << UnicodeType.CONNECT_PUNCTUATION) |
                        (1 << UnicodeType.DASH_PUNCTUATION) |
                        (1 << UnicodeType.OPEN_PUNCTUATION) |
                        (1 << UnicodeType.CLOSE_PUNCTUATION) |
                        (1 << UnicodeType.OTHER_PUNCTUATION) |
                        (1 << UnicodeType.INITIAL_PUNCTUATION) |
                        (1 << UnicodeType.FINAL_PUNCTUATION)) >> Character.GetType(ch)) & 1)
                    != 0;

            case HEX_DIGIT:
                // \p{gc=Decimal_Number}
                // \p{Hex_Digit}    -> PropList.txt: Hex_Digit
                return DIGIT.Is(ch) ||
                    (ch >= 0x0030 && ch <= 0x0039) ||
                    (ch >= 0x0041 && ch <= 0x0046) ||
                    (ch >= 0x0061 && ch <= 0x0066) ||
                    (ch >= 0xFF10 && ch <= 0xFF19) ||
                    (ch >= 0xFF21 && ch <= 0xFF26) ||
                    (ch >= 0xFF41 && ch <= 0xFF46);

            case ASSIGNED:
                return Character.GetType(ch) != UnicodeType.UNASSIGNED;

            case NONCHARACTER_CODE_POINT:
                // PropList.txt:Noncharacter_Code_Point
                return (ch & 0xfffe) == 0xfffe || (ch >= 0xfdd0 && ch <= 0xfdef);

            case DIGIT:
                // \p{gc=Decimal_Number}
                return Character.IsDigit(ch);

            case ALNUM:
                // \p{alpha}
                // \p{digit}
                return ALPHABETIC.Is(ch) || DIGIT.Is(ch);

            case BLANK:
                // \p{Whitespace} --
                // [\N{LF} \N{VT} \N{FF} \N{CR} \N{NEL}  -> 0xa, 0xb, 0xc, 0xd, 0x85
                //  \p{gc=Line_Separator}
                //  \p{gc=Paragraph_Separator}]
                return Character.GetType(ch) == UnicodeType.SPACE_SEPARATOR ||
                    ch == 0x9; // \N{HT}

            case GRAPH:
                // [^
                //  \p{space}
                //  \p{gc=Control}
                //  \p{gc=Surrogate}
                //  \p{gc=Unassigned}]
                return ((((1 << UnicodeType.SPACE_SEPARATOR) |
                        (1 << UnicodeType.LINE_SEPARATOR) |
                        (1 << UnicodeType.PARAGRAPH_SEPARATOR) |
                        (1 << UnicodeType.CONTROL) |
                        (1 << UnicodeType.SURROGATE) |
                        (1 << UnicodeType.UNASSIGNED)) >> Character.GetType(ch)) & 1)
                    == 0;

            case PRINT:
                // \p{graph}
                // \p{blank}
                // -- \p{cntrl}
                return (GRAPH.Is(ch) || BLANK.Is(ch)) && !CONTROL.Is(ch);

            case WORD:
                //  \p{alpha}
                //  \p{gc=Mark}
                //  \p{digit}
                //  \p{gc=Connector_Punctuation}
                //  \p{Join_Control}    200C..200D
                return ALPHABETIC.Is(ch) ||
                    ((((1 << UnicodeType.NON_SPACING_MARK) |
                        (1 << UnicodeType.ENCLOSING_MARK) |
                        (1 << UnicodeType.COMBINING_MARK) |
                        (1 << UnicodeType.DECIMAL_NUMBER) |
                        (1 << UnicodeType.CONNECT_PUNCTUATION)) >> Character.GetType(ch)) & 1)
                    != 0 ||
                    JOIN_CONTROL.Is(ch);

            case JOIN_CONTROL:
                //  200C..200D    PropList.txt:Join_Control
                return (ch == 0x200C || ch == 0x200D);

            default:
                return false;
        }

    }


    private static void init() {
        if (UnicodeProp_posix != null 
            && UnicodeProp_aliases != null) return;

        UnicodeProp_posix = new Dictionary<string, string>();
        UnicodeProp_aliases = new Dictionary<string, string>();

        UnicodeProp_posix["ALPHA"] = "ALPHABETIC";
        UnicodeProp_posix["LOWER"] = "LOWERCASE";
        UnicodeProp_posix["UPPER"] = "UPPERCASE";
        UnicodeProp_posix["SPACE"] = "WHITE_SPACE";
        UnicodeProp_posix["PUNCT"] = "PUNCTUATION";
        UnicodeProp_posix["XDIGIT"] = "HEX_DIGIT";
        UnicodeProp_posix["ALNUM"] = "ALNUM";
        UnicodeProp_posix["CNTRL"] = "CONTROL";
        UnicodeProp_posix["DIGIT"] = "DIGIT";
        UnicodeProp_posix["BLANK"] = "BLANK";
        UnicodeProp_posix["GRAPH"] = "GRAPH";
        UnicodeProp_posix["PRINT"] = "PRINT";

        UnicodeProp_aliases["WHITESPACE"] = "WHITE_SPACE";
        UnicodeProp_aliases["HEXDIGIT"] = "HEX_DIGIT";
        UnicodeProp_aliases["NONCHARACTERCODEPOINT"] = "NONCHARACTER_CODE_POINT";
        UnicodeProp_aliases["JOINCONTROL"] = "JOIN_CONTROL";
    }

    public static UnicodeProp ForName(string propName) {
        init();
        string alias = propName;
        if (UnicodeProp_aliases.ContainsKey(propName.up())) 
            alias = UnicodeProp_aliases[propName.up()];

        EnumClass ec = (EnumClass) typeof (UnicodeProp).class_ref ();
        unowned EnumValue? item = ec.get_value_by_name (@"SYSTEM_REGEX_UNICODEPROP_$alias");
        return (UnicodeProp)item.value;
    }

    public static UnicodeProp ForPOSIXName(string propName) {
        init();
        if (!UnicodeProp_posix.ContainsKey(propName.up())) return (UnicodeProp)0;
        string alias = UnicodeProp_posix[propName.up()];
        
        EnumClass ec = (EnumClass) typeof (UnicodeProp).class_ref ();
        unowned EnumValue? item = ec.get_value_by_name (@"SYSTEM_REGEX_UNICODEPROP_$alias");
        return (UnicodeProp)item.value;
    }

}

namespace System.Regex
{
    internal static Dictionary<string, string>? UnicodeProp_aliases = null;
    internal static Dictionary<string, string>? UnicodeProp_posix = null;
}