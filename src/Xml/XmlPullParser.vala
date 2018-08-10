// =========================================================================
//
// xmlsax.js - an XML SAX parser in JavaScript.
//
// version 3.1
//
// =========================================================================
//
// Copyright (C) 2001 - 2002 David Joham (djoham@yahoo.com) and Scott Severtson
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.

// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.

// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//
//
// Visit the XML for <SCRIPT> home page at http://xmljs.sourceforge.net
//
namespace System.Xml
{
    using System.Collections.Generic;

    /***************************************************************************************************************
    XMLP is a pull-based parser. The calling application passes in a XML string
    to the constructor, then repeatedly calls .next() to parse the next segment.
    .next() returns a flag indicating what type of segment was found, and stores
    data temporarily in couple member variables (name, content, array of
    attributes), which can be accessed by several .get____() methods.

    Basically, XMLP is the lowest common denominator parser - an very simple
    API which other wrappers can be built against.
    *****************************************************************************************************************/
    public class XmlPullParser : Object
    {
        private string m_xml;
        private string m_name;
        private int m_iP;
        private int m_iState;
        private string m_cAlt;
        private int m_cB ;
        private int m_cE;
        private int m_cSrc;

        private Stack m_stack;
        private static ArrayList<string> _errs;
        private ArrayList<ArrayList<string>> m_atts;

        public const int NONE               = 0;
        public const int BEGIN_ELEMENT      = 1;
        public const int END_ELEMENT        = 2;
        public const int EMPTY_ELEMENT      = 3;
        public const int ATTRIBUTE          = 4;
        public const int TEXT               = 5;
        public const int ENTITY             = 6;
        public const int PI                 = 7;
        public const int CDATA              = 8;
        public const int COMMENT            = 9;
        public const int DTD                = 10;
        public const int ERROR              = 11;

        private const int CONTENT_XML       = 0;
        private const int CONTENT_ALT       = 1;

        private const int ATTRIBUTE_NAME    = 0;
        private const int ATTRIBUTE_VALUE   = 1;

        private const int STATE_PROLOG      = 1;
        private const int STATE_DOCUMENT    = 2;
        private const int STATE_MISC        = 3;

        private const int ERR_CLOSE_PI      = 0;
        private const int ERR_CLOSE_DTD     = 1;
        private const int ERR_CLOSE_COMMENT = 2;
        private const int ERR_CLOSE_CDATA   = 3;
        private const int ERR_CLOSE_ELM     = 4;
        private const int ERR_CLOSE_ENTITY  = 5;
        private const int ERR_PI_TARGET     = 6;
        private const int ERR_ELM_EMPTY     = 7;
        private const int ERR_ELM_NAME      = 8;
        private const int ERR_ELM_LT_NAME   = 9;
        private const int ERR_ATT_VALUES    = 10;
        private const int ERR_ATT_LT_NAME   = 11;
        private const int ERR_ATT_LT_VALUE  = 12;
        private const int ERR_ATT_DUP       = 13;
        private const int ERR_ENTITY_UNKNOWN= 14;
        private const int ERR_INFINITELOOP  = 15;
        private const int ERR_DOC_STRUCTURE = 16;
        private const int ERR_ELM_NESTING   = 17;

        /*******************************************************************************************************************
        function:   this is the constructor to the XMLP Object

        Author:   Scott Severtson

        Description:
            Instantiates and initializes the object
        *********************************************************************************************************************/
        public XmlPullParser(string str)
        {
            var strXML = str;
            // Normalize line breaks
            strXML = SaxStrings.Replace(strXML, 0, strXML.length, "\r\n", "\n");
            strXML = SaxStrings.Replace(strXML, 0, strXML.length, "\r", "\n");

            m_xml = strXML;
            m_iP = 0;
            m_iState = STATE_PROLOG;
            m_stack = new Stack();
            _clearAttributes();

        }  // end XMLP constructor

        /*******************************************************************************************************************
        function:   _addAttribute

        Author:   Scott Severtson
        *********************************************************************************************************************/
        private void _addAttribute(string name, string value) 
        {
            var pair = new ArrayList<string>();
            pair.Add(name);
            pair.Add(value);
            m_atts.Add(pair);
        }  // end function _addAttribute

        /*******************************************************************************************************************
        function:   _checkStructure

        Author:   Scott Severtson
        *********************************************************************************************************************/
        private int _checkStructure(int iEvent) {
        
            if(STATE_PROLOG == m_iState) {
                if((TEXT == iEvent) || (ENTITY == iEvent)) {
                    if(SaxStrings.IndexOfNonWhitespace(GetContent(), GetContentBegin(), GetContentEnd()) != -1) {
                        return _setErr(ERR_DOC_STRUCTURE);
                    }
                }

                if((BEGIN_ELEMENT == iEvent) || (EMPTY_ELEMENT == iEvent)) {
                    m_iState = STATE_DOCUMENT;
                    // Don't return - fall through to next state
                }
            }
            if(STATE_DOCUMENT == m_iState) {
                if((BEGIN_ELEMENT == iEvent) || (EMPTY_ELEMENT == iEvent)) {
                    m_stack.Push(GetName());
                }

                if((END_ELEMENT == iEvent) || (EMPTY_ELEMENT == iEvent)) {
                    var strTop = m_stack.Pop();
                    if((strTop == null) || (strTop != GetName())) {
                        return _setErr(ERR_ELM_NESTING);
                    }
                }

                if(m_stack.Count() == 0) {
                    m_iState = STATE_MISC;
                    return iEvent;
                }
            }
            if(STATE_MISC == m_iState) {
                if((BEGIN_ELEMENT == iEvent) || (END_ELEMENT == iEvent) || (EMPTY_ELEMENT == iEvent))// || (EVT_DTD == iEvent)) 
                {
                    return _setErr(ERR_DOC_STRUCTURE);
                }

                if((TEXT == iEvent) || (ENTITY == iEvent)) {
                    if(SaxStrings.IndexOfNonWhitespace(GetContent(), GetContentBegin(), GetContentEnd()) != -1) {
                        return _setErr(ERR_DOC_STRUCTURE);
                    }
                }
            }

            return iEvent;

        }  // end function _checkStructure

        
        /*******************************************************************************************************************
        function:   _clearAttributes

        Author:   Scott Severtson
        *********************************************************************************************************************/
        private void _clearAttributes() 
        {
            m_atts = new ArrayList<ArrayList<string>>();
        }  // end function _clearAttributes
        
        /*******************************************************************************************************************
        function:   findAttributeIndex

        Author:   Scott Severtson
        *********************************************************************************************************************/
        private int _findAttributeIndex(string name) 
        {
            for(var i = 0; i < m_atts.Count; i++) {
                if(m_atts[i][ATTRIBUTE_NAME] == name) {
                    return i;
                }
            }
            return -1;
        }  // end function _findAttributeIndex


        /*******************************************************************************************************************
        function:   getAttributeCount

        Author:   Scott Severtson
        *********************************************************************************************************************/
        public int GetAttributeCount() 
        {
            return m_atts != null ? m_atts.Count : 0;
        }  // end function getAttributeCount()


        /*******************************************************************************************************************
        function:   getAttributeName

        Author:   Scott Severtson
        *********************************************************************************************************************/
        public string GetAttributeName(int index) 
        {
            return ((index < 0) || (index >= m_atts.Count)) ? null : m_atts[index][ATTRIBUTE_NAME];
        }  //end function getAttributeName


        /*******************************************************************************************************************
        function:   getAttributeValue

        Author:   Scott Severtson
        *********************************************************************************************************************/
        public string GetAttributeValue(int index) 
        {
            return ((index < 0) || (index >= m_atts.Count)) ? null : ConvertEscapes(m_atts[index][ATTRIBUTE_VALUE]);
        } // end function getAttributeValue


        /*******************************************************************************************************************
        function:   getAttributeValueByName

        Author:   Scott Severtson
        *********************************************************************************************************************/
        public string GetAttributeValueByName(string name) 
        {
            return GetAttributeValue(_findAttributeIndex(name));
        }  // end function getAttributeValueByName


        /*******************************************************************************************************************
        function:   getColumnNumber

        Author:   Scott Severtson
        *********************************************************************************************************************/
        public int GetColumnNumber() 
        {
            return SaxStrings.GetColumnNumber(m_xml, m_iP);
        }  // end function getColumnNumber


        /*******************************************************************************************************************
        function:   getContent

        Author:   Scott Severtson
        *********************************************************************************************************************/
        public string GetContent() 
        {
            return (m_cSrc == CONTENT_XML) ? m_xml : m_cAlt;
        }  //end function getContent


        /*******************************************************************************************************************
        function:   getContentBegin

        Author:   Scott Severtson
        *********************************************************************************************************************/
        public int GetContentBegin() 
        {
            return m_cB;
        }  //end function getContentBegin


        /*******************************************************************************************************************
        function:   getContentEnd

        Author:   Scott Severtson
        *********************************************************************************************************************/
        public int GetContentEnd() 
        {
            return m_cE;
        }  // end function getContentEnd


        /*******************************************************************************************************************
        function:   getLineNumber

        Author:   Scott Severtson
        *********************************************************************************************************************/
        public int GetLineNumber() 
        {
            return SaxStrings.GetLineNumber(m_xml, m_iP);
        }  // end function getLineNumber


        /*******************************************************************************************************************
        function:   GetName

        Author:   Scott Severtson
        *********************************************************************************************************************/
        public string GetName() 
        {
            return m_name;
        }  // end function GetName()


        /*******************************************************************************************************************
        function:   next

        Author:   Scott Severtson
        *********************************************************************************************************************/
        public int Next() 
        {
            return _checkStructure(_parse());
        }  // end function next()


        /*******************************************************************************************************************
        function:   _parse

        Author:   Scott Severtson
        *********************************************************************************************************************/
        private int _parse() 
        {
            if(m_iP == m_xml.length) {
                return NONE;
            }

            if(m_iP == m_xml.index_of("<?",            m_iP)) {
                return _parsePI     (m_iP + 2);
            }
            else if(m_iP == m_xml.index_of("<!DOCTYPE", m_iP)) {
                return _parseDTD    (m_iP + 9);
            }
            else if(m_iP == m_xml.index_of("<!--",      m_iP)) {
                return _parseComment(m_iP + 4);
            }
            else if(m_iP == m_xml.index_of("<![CDATA[", m_iP)) {
                return _parseCDATA  (m_iP + 9);
            }
            else if(m_iP == m_xml.index_of("<",         m_iP)) {
                return _parseElement(m_iP + 1);
            }
            else if(m_iP == m_xml.index_of("&",         m_iP)) {
                return _parseEntity (m_iP + 1);
            }
            else{
                return _parseText   (m_iP);
            }
        }  // end function _parse


        /*******************************************************************************************************************
        function:   _parseAttribute

        Author:   Scott Severtson
        *********************************************************************************************************************/
        private int _parseAttribute(int iB, int iE) 
        {
            int iNB, iNE, iEq, iVB, iVE, iRet;
            string cQuote, strN, strV;

            m_cAlt = ""; //resets the value so we don't use an old one by accident (see testAttribute7 in the test suite)
            
            iNB = SaxStrings.IndexOfNonWhitespace(m_xml, iB, iE);
            if((iNB == -1) ||(iNB >= iE)) {
                return iNB;
            }

            iEq = m_xml.index_of("=", iNB);
            if((iEq == -1) || (iEq > iE)) {
                return _setErr(ERR_ATT_VALUES);
            }

            iNE = SaxStrings.LastIndexOfNonWhitespace(m_xml, iNB, iEq);

            iVB = SaxStrings.IndexOfNonWhitespace(m_xml, iEq + 1, iE);
            if((iVB == -1) ||(iVB > iE)) {
                return _setErr(ERR_ATT_VALUES);
            }

            cQuote = m_xml.substring(iVB, 1);
            if("\"'".index_of(cQuote) == -1) {
                return _setErr(ERR_ATT_VALUES);
            }

            iVE = m_xml.index_of(cQuote, iVB + 1);
            if((iVE == -1) ||(iVE > iE)) {
                return _setErr(ERR_ATT_VALUES);
            }

            strN = m_xml.substr(iNB, iNE + 1);
            strV = m_xml.substr(iVB + 1, iVE);

            if(strN.index_of("<") != -1) {
                return _setErr(ERR_ATT_LT_NAME);
            }

            if(strV.index_of("<") != -1) {
                return _setErr(ERR_ATT_LT_VALUE);
            }

            strV = SaxStrings.Replace(strV, 0, strV.length, "\n", "");
            strV = SaxStrings.Replace(strV, 0, strV.length, "\t", "  ");
            // strV = SaxStrings.Replace(strV, 0, strV.length, "\n", " ");
            // strV = SaxStrings.Replace(strV, 0, strV.length, "\t", " ");
            iRet = _replaceEntities(strV);
            if(iRet == ERROR) {
                return iRet;
            }

            strV = m_cAlt;

            if(_findAttributeIndex(strN) == -1) {
                _addAttribute(strN, strV);
            }
            else {
                return _setErr(ERR_ATT_DUP);
            }

            m_iP = iVE + 2;

            return ATTRIBUTE;

        }  // end function _parseAttribute


        /*******************************************************************************************************************
        function:   _parseCDATA

        Author:   Scott Severtson
        *********************************************************************************************************************/
        private int _parseCDATA(int iB) 
        {
            var iE = m_xml.index_of("]]>", iB);
            if (iE == -1) {
                return _setErr(ERR_CLOSE_CDATA);
            }

            _setContent(CONTENT_XML, iB, iE);

            m_iP = iE + 3;

            return CDATA;

        }  // end function _parseCDATA


        /*******************************************************************************************************************
        function:   _parseComment

        Author:   Scott Severtson
        *********************************************************************************************************************/
        private int _parseComment(int iB) 
        {
            var iE = m_xml.index_of("-" + "->", iB);
            if (iE == -1) {
                return _setErr(ERR_CLOSE_COMMENT);
            }

            _setContent(CONTENT_XML, iB, iE);

            m_iP = iE + 3;

            return COMMENT;

        }  // end function _parseComment


        /*******************************************************************************************************************
        function:  _parseDTD

        Author:   Scott Severtson
        *********************************************************************************************************************/
        private int _parseDTD(int iB) 
        {

            // Eat DTD

            int iE, iInt, iLast=0;
            string strClose;

            iE = m_xml.index_of(">", iB);
            if(iE == -1) {
                return _setErr(ERR_CLOSE_DTD);
            }

            iInt = m_xml.index_of("[", iB);
            strClose = ((iInt != -1) && (iInt < iE)) ? "]>" : ">";

            while(true) {
                // DEBUG: Remove
                if(iE == iLast) {
                    return _setErr(ERR_INFINITELOOP);
                }

                iLast = iE;
                // DEBUG: Remove End

                iE = m_xml.index_of(strClose, iB);
                if(iE == -1) {
                    return _setErr(ERR_CLOSE_DTD);
                }

                // Make sure it is not the end of a CDATA section
                if (m_xml.substr(iE - 1, iE + 2) != "]]>") {
                    break;
                }
            }

            m_iP = iE + strClose.length;

            return DTD;

        }  // end function _parseDTD


        /*******************************************************************************************************************
        function:   _parseElement

        Author:   Scott Severtson
        *********************************************************************************************************************/
        private int _parseElement(int iB) 
        {
            int iE, iDE, iNE, iRet;
            int iType, iLast=0;
            string strN;

            iDE = iE = m_xml.index_of(">", iB);
            if(iE == -1) {
                return _setErr(ERR_CLOSE_ELM);
            }

            if(m_xml[iB] == '/') {
                iType = END_ELEMENT;
                iB++;
            } else {
                iType = BEGIN_ELEMENT;
            }

            if(m_xml[iE - 1] == '/') {
                if(iType == END_ELEMENT) {
                    return _setErr(ERR_ELM_EMPTY);
                }
                iType = EMPTY_ELEMENT;
                iDE--;
            }

            iDE = SaxStrings.LastIndexOfNonWhitespace(m_xml, iB, iDE);

            //djohack
            //hack to allow for elements with single character names to be recognized

            if (iE - iB != 1 ) {
                if(SaxStrings.IndexOfNonWhitespace(m_xml, iB, iDE) != iB) {
                    return _setErr(ERR_ELM_NAME);
                }
            }
            // end hack -- original code below

            /*
            if(SaxStrings.indexOfNonWhitespace(m_xml, iB, iDE) != iB)
                return _setErr(ERR_ELM_NAME);
            */
            _clearAttributes();

            iNE = SaxStrings.IndexOfWhitespace(m_xml, iB, iDE);
            if(iNE == -1) {
                iNE = iDE + 1;
            }
            else {
                m_iP = iNE;
                while(m_iP < iDE) {
                    // DEBUG: Remove
                    if(m_iP == iLast) return _setErr(ERR_INFINITELOOP);
                    iLast = m_iP;
                    // DEBUG: Remove End


                    iRet = _parseAttribute(m_iP, iDE);
                    if(iRet == ERROR) return iRet;
                }
            }

            strN = m_xml.substr(iB, iNE);

            if(strN.index_of("<") != -1) {
                return _setErr(ERR_ELM_LT_NAME);
            }

            m_name = strN;
            m_iP = iE + 1;

            return iType;

        }  // end function _parseElement


        /*******************************************************************************************************************
        function:   _parseEntity

        Author:   Scott Severtson
        *********************************************************************************************************************/
        private int _parseEntity(int iB) 
        {
            var iE = m_xml.index_of(";", iB);
            if(iE == -1) {
                return _setErr(ERR_CLOSE_ENTITY);
            }

            m_iP = iE + 1;

            return _replaceEntity(m_xml, iB, iE);

        }  // end function _parseEntity


        /*******************************************************************************************************************
        function:   _parsePI

        Author:   Scott Severtson
        *********************************************************************************************************************/
        private int _parsePI(int iB) 
        {
            int iE, iTB, iTE, iCB, iCE;

            iE = m_xml.index_of("?>", iB);
            if(iE == -1) {
                return _setErr(ERR_CLOSE_PI);
            }

            iTB = SaxStrings.IndexOfNonWhitespace(m_xml, iB, iE);
            if(iTB == -1) {
                return _setErr(ERR_PI_TARGET);
            }

            iTE = SaxStrings.IndexOfWhitespace(m_xml, iTB, iE);
            if(iTE == -1) {
                iTE = iE;
            }

            iCB = SaxStrings.IndexOfNonWhitespace(m_xml, iTE, iE);
            if(iCB == -1) {
                iCB = iE;
            }

            iCE = SaxStrings.LastIndexOfNonWhitespace(m_xml, iCB, iE);
            if(iCE == -1) {
                iCE = iE - 1;
            }

            m_name = m_xml.substr(iTB, iTE);
            // _setContent(CONTENT_XML, iCB, iCE + 1);
            _setContent(CONTENT_XML, iCB, iCE -4);
            m_iP = iE + 2;

            return PI;

        }  // end function _parsePI


        /*******************************************************************************************************************
        function:   _parseText

        Author:   Scott Severtson
        *********************************************************************************************************************/
        private int _parseText(int iB) 
        {
            int iE, iEE;

            iE = m_xml.index_of("<", iB);
            if(iE == -1) {
                iE = m_xml.length;
            }

            iEE = m_xml.index_of("&", iB);
            if((iEE != -1) && (iEE <= iE)) {
                iE = iEE;
            }

            _setContent(CONTENT_XML, iB, iE);

            m_iP = iE;

            return TEXT;

        } // end function _parseText


        /*******************************************************************************************************************
        function:   _replaceEntities

        Author:   Scott Severtson
        *********************************************************************************************************************/
        private int _replaceEntities(string strD, int iB=0, int iE=-1) 
        {
            if(SaxStrings.IsEmpty(strD)) return 0;//"";
            iE = (iE == -1) ? strD.length : iE;


            int iEB, iEE, iRet;
            var strRet = "";

            iEB = strD.index_of("&", iB);
            iEE = iB;

            while((iEB > 0) && (iEB < iE)) {
                strRet += strD.substr(iEE, iEB);

                iEE = strD.index_of(";", iEB) + 1;

                if((iEE == 0) || (iEE > iE)) {
                    return _setErr(ERR_CLOSE_ENTITY);
                }

                iRet = _replaceEntity(strD, iEB + 1, iEE - 1);
                if(iRet == ERROR) {
                    return iRet;
                }

                strRet += m_cAlt;

                iEB = strD.index_of("&", iEE);
            }

            if(iEE != iE) {
                strRet += strD.substr(iEE, iE);
            }

            _setContentStr(CONTENT_ALT, strRet);

            return ENTITY;

        }  // end function _replaceEntities


        /*******************************************************************************************************************
        function:   _replaceEntity

        Author:   Scott Severtson
        *********************************************************************************************************************/
        private int _replaceEntity(string strD, int iB = 0, int iE = -1) 
        {
            string strEnt;

            if(SaxStrings.IsEmpty(strD)) return -1;
            iE = (iE == -1) ? strD.length : iE;

            switch(strD.substr(iB, iE)) {
                case "amp":  strEnt = "&";  break;
                case "lt":   strEnt = "<";  break;
                case "gt":   strEnt = ">";  break;
                case "apos": strEnt = "'";  break;
                case "quot": strEnt = "\""; break;
                default:
                    if(strD[iB] == '#') {
                        char c = (char)int.parse(strD.substr(iB + 1, iE));
                        strEnt = (string)c;
                    } else {
                        return _setErr(ERR_ENTITY_UNKNOWN);
                    }
                break;
            }
            _setContentStr(CONTENT_ALT, strEnt);

            return ENTITY;
        }  // end function _replaceEntity


        /*******************************************************************************************************************
        function:   _setContent

        Author:   Scott Severtson
        *********************************************************************************************************************/
        private void _setContent(int iSrc, int arg1, int arg2=0) 
        {
            if(CONTENT_XML == iSrc) {
                m_cAlt = null;
                m_cB = arg1;
                m_cE = arg2;
            } else {
                // m_cAlt = arg1;
                // m_cB = 0;
                // m_cE = arg1;//.length;??????????????
            }
            m_cSrc = iSrc;

        }  // end function _setContent

        private void _setContentStr(int iSrc, string arg1) 
        {
            if(CONTENT_XML == iSrc) {
                // m_cAlt = null;
                // m_cB = arg1;
                // m_cE = arg2;
            } else {
                m_cAlt = arg1;
                m_cB = 0;
                m_cE = arg1.length;
            }
            m_cSrc = iSrc;

        }  // end function _setContent

        /*******************************************************************************************************************
        function:   _setErr

        Author:   Scott Severtson
        *********************************************************************************************************************/
        private int _setErr(int iErr) 
        {
            var strErr = _errs[iErr];

            m_cAlt = strErr;
            m_cB = 0;
            m_cE = strErr.length;
            m_cSrc = CONTENT_ALT;

            return ERROR;
        }  // end function _setErr


        construct 
        {
            _errs = new ArrayList<string>();
            _errs[ERR_CLOSE_PI       ] = "PI: missing closing sequence";
            _errs[ERR_CLOSE_DTD      ] = "DTD: missing closing sequence";
            _errs[ERR_CLOSE_COMMENT  ] = "Comment: missing closing sequence";
            _errs[ERR_CLOSE_CDATA    ] = "CDATA: missing closing sequence";
            _errs[ERR_CLOSE_ELM      ] = "Element: missing closing sequence";
            _errs[ERR_CLOSE_ENTITY   ] = "Entity: missing closing sequence";
            _errs[ERR_PI_TARGET      ] = "PI: target is required";
            _errs[ERR_ELM_EMPTY      ] = "Element: cannot be both empty and closing";
            _errs[ERR_ELM_NAME       ] = "Element: name must immediatly follow \"<\"";
            _errs[ERR_ELM_LT_NAME    ] = "Element: \"<\" not allowed in element names";
            _errs[ERR_ATT_VALUES     ] = "Attribute: values are required and must be in quotes";
            _errs[ERR_ATT_LT_NAME    ] = "Element: \"<\" not allowed in attribute names";
            _errs[ERR_ATT_LT_VALUE   ] = "Attribute: \"<\" not allowed in attribute values";
            _errs[ERR_ATT_DUP        ] = "Attribute: duplicate attributes not allowed";
            _errs[ERR_ENTITY_UNKNOWN ] = "Entity: unknown entity";
            _errs[ERR_INFINITELOOP   ] = "Infininte loop";
            _errs[ERR_DOC_STRUCTURE  ] = "Document: only comments, processing instructions, or whitespace allowed outside of document element";
            _errs[ERR_ELM_NESTING    ] = "Element: must be nested correctly";
        }
    }
}