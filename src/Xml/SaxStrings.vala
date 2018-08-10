namespace System.Xml
{
    using System.Collections.Generic;

    /***************************************************************************************************************
    SaxStrings: a useful object containing string manipulation functions
    *****************************************************************************************************************/
    public class SaxStrings : Object
    {

        // CONSTANTS    (these must be below the constructor)

        // =========================================================================
        // =========================================================================
        // =========================================================================
        private const string Whitespace = " \t\n\r";


        /*******************************************************************************************************************
        function:   SaxStrings

        Author:   Scott Severtson

        Description:
            This is the constructor of the SaxStrings object
        *********************************************************************************************************************/
        public SaxStrings() 
        {
        }  // end function SaxStrings


        // =========================================================================
        // =========================================================================
        // =========================================================================


        /*******************************************************************************************************************
        function:   replace

        Author:   Scott Severtson
        *********************************************************************************************************************/
        public static int GetColumnNumber(string strD, int iP = -1) 
        {
            if(IsEmpty(strD)) {
                return -1;
            }
            iP = (iP == -1) ? strD.length : iP;

            var arrD = strD.substr(0, iP).split("\n");
            var strLine = arrD[arrD.length - 1];
            arrD.length--;
            var iLinePos = string.joinv("\n", arrD).length;

            return iP - iLinePos;

        }  // end function getColumnNumber


        /*******************************************************************************************************************
        function:   getLineNumber

        Author:   Scott Severtson
        *********************************************************************************************************************/
        public static int GetLineNumber(string strD, int iP = -1) 
        {
            if(IsEmpty(strD)) {
                return -1;
            }
            iP = (iP == -1) ? strD.length : iP;

            return strD.substr(0, iP).split("\n").length;
        }  // end function getLineNumber


        /*******************************************************************************************************************
        function:   indexOfNonWhitespace

        Author:   Scott Severtson
        *********************************************************************************************************************/
        public static int IndexOfNonWhitespace(string strD, int iB = 0, int iE = -1) 
        {
            if(IsEmpty(strD)) {
                return -1;
            }
            iE = (iE == -1) ? strD.length : iE;

            for(var i = iB; i < iE; i++){
                if(Whitespace.index_of(strD.substring(i, 1)) == -1) {
                    return i;
                }
            }
            return -1;

        }  // end function indexOfNonWhitespace


        /*******************************************************************************************************************
        function:   indexOfWhitespace

        Author:   Scott Severtson
        *********************************************************************************************************************/
        public static int IndexOfWhitespace(string strD, int iB = 0, int iE = -1) 
        {
            if(IsEmpty(strD)) {
                return -1;
            }
            iE = (iE == -1) ? strD.length : iE;

            for(var i = iB; i < iE; i++) {
                if(Whitespace.index_of(strD.substring(i, 1)) != -1) {
                    return i;
                }
            }
            return -1;
        }  // end function indexOfWhitespace


        /*******************************************************************************************************************
        function:   IsEmpty

        Author:   Scott Severtson
        *********************************************************************************************************************/
        public static bool IsEmpty(string strD) 
        {
            return (strD == null) || (strD.length == 0);
        }  // end function IsEmpty


        /*******************************************************************************************************************
        function:   lastIndexOfNonWhiteSpace

        Author:   Scott Severtson
        *********************************************************************************************************************/
        public static int LastIndexOfNonWhitespace(string strD, int iB = 0, int iE = -1) 
        {
            if(IsEmpty(strD)) {
                return -1;
            }
            iE = (iE == -1) ? strD.length : iE;

            for(var i = iE - 1; i >= iB; i--){
                if(Whitespace.index_of(strD.substring(i, 1)) == -1){
                    return i;
                }
            }
            return -1;
        }  // end function lastIndexOfNonWhitespace


        /*******************************************************************************************************************
        function:   replace

        Author:   Scott Severtson
        *********************************************************************************************************************/
        public static string Replace(string strD, int iB, int iE, string strF, string strR) 
        {
            if(IsEmpty(strD)) {
                return "";
            }
            // iB = iB || 0;
            // iE = iE || strD.length;

            return string.joinv(strR, strD.substr(iB, iE).split(strF));
            //.join(strR);

        }  // end function replace



    }
}