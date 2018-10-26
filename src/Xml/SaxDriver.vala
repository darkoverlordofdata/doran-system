namespace System.Xml
{
    using System.Collections.Generic;

    /***************************************************************************************************************
    SaxDriver is an object that basically wraps an XmlPullParser instance, and provides an
    event-based interface for parsing. This is the object users interact with when coding
    with XML for <SCRIPT>
    *****************************************************************************************************************/
    public class SaxDriver : AttributeList//, Locator, XmlReader, Object
    {
        private DefaultHandler m_hndDoc;
        private DefaultHandler m_hndErr;
        private DefaultHandler m_hndLex;
        private XmlPullParser m_parser;
        private bool m_bErr;
        private string m_strErrMsg;
        private string m_xml;
        private int m_iP;

        /*******************************************************************************************************************
        function:   SaxDriver

        Author:   Scott Severtson

        Description:
            This is the constructor for the SaxDriver Object
        *********************************************************************************************************************/
        public SaxDriver() 
        {
            m_hndDoc = null;
            m_hndErr = null;
            m_hndLex = null;
        }

        public override void Parse(string strD) {
            /*******************************************************************************************************************
            function:   Parse

            Author:   Scott Severtson
            *********************************************************************************************************************/
            var parser = new XmlPullParser(strD);

            if(m_hndDoc != null) {
                m_hndDoc.SetDocumentLocator(this);
            }

            m_parser = parser;
            m_bErr = false;

            if(!m_bErr) {
                m_hndDoc.StartDocument();         
            }
            _parseLoop();
            if(!m_bErr) {
                m_hndDoc.EndDocument();         
            }

            m_xml = null;
            m_iP = 0;

        }  // end function Parse


        /*******************************************************************************************************************
        function:   SetDocumentHandler

        Author:   Scott Severtson
        *********************************************************************************************************************/
        public override void SetDocumentHandler(DefaultHandler hnd) 
        {
            m_hndDoc = hnd;
        }   // end function SetDocumentHandler


        /*******************************************************************************************************************
        function:   SetErrorHandler

        Author:   Scott Severtson
        *********************************************************************************************************************/
        public override void SetErrorHandler(DefaultHandler hnd) 
        {
            m_hndErr = hnd;
        }  // end function SetErrorHandler


        /*******************************************************************************************************************
        function:   SetLexicalHandler

        Author:   Scott Severtson
        *********************************************************************************************************************/
        public override void SetLexicalHandler(DefaultHandler hnd) 
        {
            m_hndLex = hnd;
        }  // end function SetLexicalHandler


        /*******************************************************************************************************************
                                                    LOCATOR/PARSE EXCEPTION INTERFACE
        *********************************************************************************************************************/

        /*******************************************************************************************************************
        function:   GetSystemId

        Author:   Scott Severtson
        *********************************************************************************************************************/
        public override int GetColumnNumber() 
        {
            return m_parser.GetColumnNumber();
        }  // end function GetColumnNumber


        /*******************************************************************************************************************
        function:   GetLineNumber

        Author:   Scott Severtson
        *********************************************************************************************************************/
        public override int GetLineNumber() 
        {
            return m_parser.GetLineNumber();
        }  // end function GetLineNumber


        /*******************************************************************************************************************
        function:   getMessage

        Author:   Scott Severtson
        *********************************************************************************************************************/
        public string getMessage() 
        {
            return m_strErrMsg;
        }  // end function getMessage


        /*******************************************************************************************************************
        function:   getPublicID

        Author:   Scott Severtson
        *********************************************************************************************************************/
        public override string GetPublicId() 
        {
            return null;
        }  // end function getPublicID


        /*******************************************************************************************************************
        function:   GetSystemId

        Author:   Scott Severtson
        *********************************************************************************************************************/
        public override string GetSystemId() 
        {
            return null;
        }  // end function GetSystemId


        /*******************************************************************************************************************
                                                    Attribute List Interface
        *********************************************************************************************************************/

        /*******************************************************************************************************************
        function:   GetLength

        Author:   Scott Severtson
        *********************************************************************************************************************/
        public override int GetLength() 
        {
            return m_parser.GetAttributeCount();
        }  // end function getAttributeCount


        /*******************************************************************************************************************
        function:   GetName

        Author:   Scott Severtson
        *********************************************************************************************************************/
        public override string GetName(int index) 
        {
            return m_parser.GetAttributeName(index);
        } // end function getAttributeName


        /*******************************************************************************************************************
        function:   GetValue

        Author:   Scott Severtson
        *********************************************************************************************************************/
        public override string GetValue(int index) 
        {
            return m_parser.GetAttributeValue(index);
        }  // end function getAttributeValue


        /*******************************************************************************************************************
        function:   GetValueByName

        Author:   Scott Severtson
        *********************************************************************************************************************/
        public override string GetValueByName(string name) 
        {
            return m_parser.GetAttributeValueByName(name);
        } // end function getAttributeValueByName


        /*******************************************************************************************************************
                                                                    Private functions
        *********************************************************************************************************************/

        /*******************************************************************************************************************
        function:   _fireError

        Author:   Scott Severtson
        *********************************************************************************************************************/
        private void _fireError(string strMsg) 
        {
            m_strErrMsg = strMsg;
            m_bErr = true;

            if(m_hndErr != null) {
                m_hndErr.FatalError(new SAX.SaxException(strMsg));
            }

        }   // end function _fireError


        /*******************************************************************************************************************
        function:   _parseLoop

        Author:   Scott Severtson
        *********************************************************************************************************************/
        private void _parseLoop() 
        {
            int iEvent;

            while(!m_bErr) {
                iEvent = m_parser.Next();

                if(iEvent == XmlPullParser.BEGIN_ELEMENT) {
                    m_hndDoc.StartElement(m_parser.GetName(), this);
                }
                else if(iEvent == XmlPullParser.END_ELEMENT) {
                    m_hndDoc.EndElement(m_parser.GetName());
                }
                else if(iEvent == XmlPullParser.EMPTY_ELEMENT) {
                    m_hndDoc.StartElement(m_parser.GetName(), this);
                    m_hndDoc.EndElement(m_parser.GetName());
                }
                else if(iEvent == XmlPullParser.TEXT) {
                    m_hndDoc.Characters(m_parser.GetContent(), m_parser.GetContentBegin(), m_parser.GetContentEnd() - m_parser.GetContentBegin());
                }
                else if(iEvent == XmlPullParser.ENTITY) {
                    m_hndDoc.Characters(m_parser.GetContent(), m_parser.GetContentBegin(), m_parser.GetContentEnd() - m_parser.GetContentBegin());
                }
                else if(iEvent == XmlPullParser.PI) {
                    m_hndDoc.ProcessingInstruction(m_parser.GetName(), m_parser.GetContent().substring(m_parser.GetContentBegin(), m_parser.GetContentEnd()));
                }
                else if(iEvent == XmlPullParser.CDATA) {
                    m_hndLex.StartCDATA();
                    m_hndDoc.Characters(m_parser.GetContent(), m_parser.GetContentBegin(), m_parser.GetContentEnd() - m_parser.GetContentBegin());
                    m_hndLex.EndCDATA();
                }
                else if(iEvent == XmlPullParser.COMMENT) {
                    m_hndLex.Comment(m_parser.GetContent(), m_parser.GetContentBegin(), m_parser.GetContentEnd() - m_parser.GetContentBegin());
                }
                else if(iEvent == XmlPullParser.DTD) {
                }
                else if(iEvent == XmlPullParser.ERROR) {
                    _fireError(m_parser.GetContent());
                }
                else if(iEvent == XmlPullParser.NONE) {
                    return;
                }
            }
        }  // end function _parseLoop
    }
}