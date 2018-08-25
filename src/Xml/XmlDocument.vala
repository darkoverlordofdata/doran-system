namespace System.Xml
{
    using System.Collections.Generic;

    // =========================================================================
    // =========================================================================
    // =========================================================================
    // XML DOC FUNCTIONS`
    // =========================================================================
    // =========================================================================
    // =========================================================================
    public class XmlDocument : XmlNode
    {
        private XmlNode TopNode;

        /*******************************************************************************************************************
        function:       XmlDocument

        Author: mike@idle.org

        Description:
            a constructor for an XML document
            Source: the string containing the document
        *********************************************************************************************************************/
        public XmlDocument(string source) 
        {
            // stack for document construction
            TopNode = null;

            // set up the properties and methods for this object
            Source = source;        // the string Source of the document
            // parse the document

            if (Parse()) {
                // we've run out of markup - check the stack is now empty
                if (TopNode!=null) {
                    error("expected close " + TopNode.TagName);
                } 
            } 
        } // end function XmlDocument

        /*******************************************************************************************************************
        function:   _XMLDoc_createXMLNode

        Author: djoham@yahoo.com

        Description:
            convienience function to create a new node that inherits
            the properties of the document object
        *********************************************************************************************************************/
        public XmlNode CreateXMLNode(string strXML) 
        {
            return new XmlDocument(strXML).DocNode;
        } // end function _XMLDoc_createXMLNode

        /*******************************************************************************************************************
        function:       _XMLDoc_getUnderlyingXMLText

        Author: djoham@yahoo.com

        Description:
            kicks off the process that returns the XML text representation of the XML
            document inclusive of any changes made by the manipulation of the DOM
        *********************************************************************************************************************/
        public string GetUnderlyingXMLText() 
        {
            var strRet = "";
            //for now, hardcode the xml version 1 information. When we handle Processing Instructions later, this
            //should be looked at again
            strRet = strRet + "<?xml version=\"1.0\"?>";
            if (DocNode==null) {
                return "";
            }

            strRet = DisplayElement(DocNode, strRet);
            return strRet;

        } // end function _XMLDoc_getCurrentXMLText

        /*******************************************************************************************************************
        function:   _XMLDoc_handleNode

        Author: mike@idle.org

        Description:
            adds a markup element to the document
        *********************************************************************************************************************/
        public bool HandleNode(XmlNode current) 
        {
            if ((current.NodeType==XMLNodeType.COMMENT) && (TopNode!=null)) {
                return TopNode.AddElement(current);
            }
            else if ((current.NodeType==XMLNodeType.TEXT) ||  (current.NodeType==XMLNodeType.CDATA)) {

                // if the stack is empty, and this text node isn't just Whitespace, we have
                // a problem (we're not in a document element)
                if(TopNode==null) {

                    if (current.Content.trim(true,false)=="") {
                    // if (Trim(current.Content,true,false)=="") {
                        return true;
                    }
                    else {
                        throw new XmlDomError.ParseError("expected document node, found: " + current.ToString());
                    }
                }
                else {
                    // otherwise, append this as child to the element at the top of the stack
                    return TopNode.AddElement(current);
                }
            }
            else if ((current.NodeType==XMLNodeType.OPEN) || (current.NodeType==XMLNodeType.SINGLE)) {
                // if we find an element tag (open or empty)
                var success = false;

                // if the stack is empty, this node becomes the document node

                if(TopNode==null) {
                    DocNode = current;
                    current.Parent = null;
                    success = true;
                }
                else {
                    // otherwise, append this as child to the element at the top of the stack
                    success = TopNode.AddElement(current);
                }


                if (success && (current.NodeType!=XMLNodeType.SINGLE)) {
                    TopNode = current;
                }

                // rename it as an element node

                current.NodeType = XMLNodeType.ELEMENT;

                return success;
            }

            // if it's a close tag, check the nesting

            else if (current.NodeType==XMLNodeType.CLOSE) {

                // if the stack is empty, it's certainly an error

                if (TopNode==null) {
                    throw new XmlDomError.ParseError("close tag without open: " +  current.ToString());
                }
                else {

                    // otherwise, check that this node matches the one on the top of the stack

                    if (current.TagName!=TopNode.TagName) {
                        throw new XmlDomError.ParseError("expected closing " + TopNode.TagName + ", found closing " + current.TagName);
                    }
                    else {
                        // if it does, pop the element off the top of the stack
                        TopNode = TopNode.GetParent();
                    }
                }
            }
            return true;
        } // end function _XMLDoc_handleNode


        /*******************************************************************************************************************
        function:   _XMLDoc_insertNodeAfter
    
        Author: djoham@yahoo.com
    
        Description:
            inserts a new XML node after the reference node;
    
            for example, if we insert the node <tag2>hello</tag2>
            after tag1 in the xml <rootnode><tag1></tag1></rootnode>
            we will end up with <rootnode><tag1></tag1><tag2>hello</tag2></rootnode>
    
            NOTE: the return value of this function is a new XmlDocument object!!!!
    
        *********************************************************************************************************************/
        public XmlDocument InsertNodeAfter (XmlNode referenceNode, XmlNode newNode) 
        {
            var parentXMLText = GetUnderlyingXMLText();
            var selectedNodeXMLText = referenceNode.GetUnderlyingXMLText();
            var originalNodePos = parentXMLText.index_of(selectedNodeXMLText) + selectedNodeXMLText.length;
            var newXML = parentXMLText.substring(0,originalNodePos);
            newXML += newNode.GetUnderlyingXMLText();
            newXML += parentXMLText.substring(originalNodePos);
            var newDoc = new XmlDocument(newXML);
            return newDoc;
        
        } // end function _XMLDoc_insertNodeAfter
        
        /*******************************************************************************************************************
        function:   _XMLDoc_insertNodeInto
    
        Author: mike@idle.org
    
        Description:
            inserts a new XML node into the reference node;
    
            for example, if we insert the node <tag2>hello</tag2>
            into tag1 in the xml <rootnode><tag1><tag3>foo</tag3></tag1></rootnode>
            we will end up with <rootnode><tag1><tag2>hello</tag2><tag3>foo</tag3></tag1></rootnode>
    
            NOTE: the return value of this function is a new XmlDocument object!!!!
        *********************************************************************************************************************/
        public XmlDocument InsertNodeInto (XmlNode referenceNode, XmlNode insertNode) 
        {
            var parentXMLText = GetUnderlyingXMLText();
            var selectedNodeXMLText = referenceNode.GetUnderlyingXMLText();
            var endFirstTag = selectedNodeXMLText.index_of(">") + 1;
            var originalNodePos = parentXMLText.index_of(selectedNodeXMLText) + endFirstTag;
            var newXML = parentXMLText.substring(0,originalNodePos);
            newXML += insertNode.GetUnderlyingXMLText();
            newXML += parentXMLText.substring(originalNodePos);
            var newDoc = new XmlDocument(newXML);
            return newDoc;
        } // end function _XMLDoc_insertNodeInto
        
        /*******************************************************************************************************************
        function:   _XMLDoc_insertNodeInto
    
        Author: xwisdom@yahoo.com
    
        Description:
            allows an already existing XmlDocument object to load XML
        *********************************************************************************************************************/
        public bool LoadXML(string source)
        {
            TopNode=null;
            Source=source;
            // parse the document
            return Parse();
        } // end function _XMLDoc_loadXML
        
        /*******************************************************************************************************************
        function:   _XMLDoc_parse
    
        Author: mike@idle.org
    
        Description:
            scans through the Source for opening and closing tags
            checks that the tags open and close in a sensible order
        *********************************************************************************************************************/
        public bool Parse() 
        {
            var pos = 0;
            // set up the arrays used to store positions of < and > characters
        
            var err = false;
        
            while(!err) {
                var closing_tag_prefix = "";
                var chpos = Source.index_of("<",pos);
                var open_length = 1;
        
                var open = 0;
                var close = 0;
        
                if (chpos ==-1) {
                    break;
                }

                open = chpos;
        
                // create a text node
        
                var str = Source.substr(pos, open);
        
                if (str.length!=0) {
                    err = !HandleNode(new XmlNode(XMLNodeType.TEXT,this, str));
                }
        
                // handle Programming Instructions - they can't reliably be handled as tags
        
                if (chpos == Source.index_of("<?",pos)) {
                    pos = ParsePI(Source, pos + 2);
                    if (pos==0) {
                        err=true;
                    }
                    continue;
                }
        
                // nobble the document type definition
        
                if (chpos == Source.index_of("<!DOCTYPE",pos)) {
                    pos = ParseDTD(Source, chpos+ 9);
                    if (pos==0) {
                        err=true;
                    }
                    continue;
                }
        
                // if we found an open comment, we need to ignore angle brackets
                // until we find a close comment
        
                if(chpos == Source.index_of("<!--",pos)) {
                    open_length = 4;
                    closing_tag_prefix = "--";
                }
        
                // similarly, if we find an open CDATA, we need to ignore all angle
                // brackets until a close CDATA sequence is found
        
                if (chpos == Source.index_of("<![CDATA[",pos)) {
                    open_length = 9;
                    closing_tag_prefix = "]]";
                }
        
                // look for the closing sequence
        
                chpos = Source.index_of(closing_tag_prefix + ">",chpos);
                if (chpos ==-1) {
                    throw new XmlDomError.ParseError("expected closing tag sequence: " + closing_tag_prefix + ">");
                }        

                close = chpos + closing_tag_prefix.length;
        
                // create a tag node
        
                str = Source.substr(open+1, close);

                var n = ParseTag(str);
                if (n != null) {
                    err = !HandleNode(n);
                }
        
                pos = close +1;
        
            // and loop
        
            }
            return !err;
        
        } // end function _XMLDoc_parse
        
        
        
        /*******************************************************************************************************************
        function:   _XMLDoc_parseAttribute
    
        Author: mike@idle.org
    
        Description:
            parse an attribute out of a tag string
    
        *********************************************************************************************************************/
        public int ParseAttribute(string src, int pos, XmlNode node) 
        {
            // chew up the Whitespace, if any
        
            while ((pos<src.length) && (Whitespace.index_of(src.substring(pos,1))!=-1)) {
                pos++;
            }
        
            // if there's nothing else, we have no (more) attributes - just break out
        
            if (pos >= src.length) {
                return pos;
            }
        
            var p1 = pos;
        
            while ((pos < src.length) && (src[pos]!='=')) {
                pos++;
            }
        
            var msg = "attributes must have values";
        
            // parameters without values aren't allowed.
        
            if(pos >= src.length) {
                throw new XmlDomError.ParseError(msg);
            }
        
            // extract the parameter name
        
            // var paramname = Trim(src.substr(p1,pos++),false,true);
            var paramname = src.substr(p1,pos++).trim(false,true);
        
            // chew up Whitespace
        
            while ((pos < src.length) && (Whitespace.index_of(src.substring(pos,1))!=-1)) {
                pos++;
            }
        
            // throw an error if we've run out of string
        
            if (pos >= src.length) {
                throw new XmlDomError.ParseError(msg);
            }
        
            msg = "attribute values must be in Quotes";
        
            // check for a quote mark to identify the beginning of the attribute value
        
            var quote = src.substring(pos++,1);
        
            // throw an error if we didn't find one
        
            if (Quotes.index_of(quote)==-1) {
                throw new XmlDomError.ParseError(msg);
            }
        
            p1 = pos;
        
            while ((pos < src.length) && (src.substring(pos,1)!=quote)) {
                pos++;
            }
        
            // throw an error if we found no closing quote
        
            if (pos >= src.length) {
                throw new XmlDomError.ParseError(msg);
            }
        
            // store the parameter
        
            // if (!node.AddAttribute(paramname, Trim(src.substr(p1,pos++),false,true))) {
            if (!node.AddAttribute(paramname, src.substr(p1,pos++).trim(false,true))) {
                return 0;
            }
        
            return pos;
        
        }  //end function _XMLDoc_parseAttribute
        
        
        
        /*******************************************************************************************************************
        function:   _XMLDoc_parseDTD
    
        Author: mike@idle.org
    
        Description:
            parse a document type declaration
    
            NOTE: we're just going to discard the DTD
    
        *********************************************************************************************************************/
        public int ParseDTD(string str, int pos) 
        {
            // we're just going to discard the DTD
        
            var firstClose = str.index_of(">",pos);
        
            if (firstClose==-1) {
                throw new XmlDomError.ParseError("error in DTD: expected '>'");
            }
        
            var closing_tag_prefix = "";
        
            var firstOpenSquare = str.index_of("[",pos);
        
            if ((firstOpenSquare!=-1) && (firstOpenSquare < firstClose)) {
                closing_tag_prefix = "]";
            }
        
            while(true) {
                var closepos = str.index_of(closing_tag_prefix + ">",pos);
        
                if (closepos ==-1) {
                    throw new XmlDomError.ParseError("expected closing tag sequence: " + closing_tag_prefix + ">");
                }
        
                pos = closepos + closing_tag_prefix.length +1;
        
                if (str.substr(closepos-1,closepos+2) != "]]>") {
                    break;
                }
            }
            return pos;
        
        } // end function _XMLDoc_ParseDTD
        
        
        /*******************************************************************************************************************
        function:   _XMLDoc_parsePI
    
        Author: mike@idle.org
    
        Description:
            parse a processing instruction
    
            NOTE: we just swallow them up at the moment
    
        *********************************************************************************************************************/
        public int ParsePI(string str, int pos) 
        {
            // we just swallow them up
        
            var closepos = str.index_of("?>",pos);
            return closepos + 2;
        
        } // end function _XMLDoc_parsePI
        
        
        
        /*******************************************************************************************************************
        function:   _XMLDoc_parseTag
    
        Author: mike@idle.org
    
        Description:
            parse out a non-text element (incl. CDATA, comments)
            handles the parsing of attributes
        *********************************************************************************************************************/
        public XmlNode ParseTag(string str) 
        {
            var src = str;
            // if it's a comment, strip off the packaging, mark it a comment node
            // and return it

            if (src.index_of("!--")==0) {
                return new XmlNode(XMLNodeType.COMMENT, this, src.substr(3,src.length-2));
            }
        
            // if it's CDATA, do similar
        
            if (src.index_of("![CDATA[")==0) {
                return new XmlNode(XMLNodeType.CDATA, this, src.substr(8,src.length-2));
            }
        
            var n = new XmlNode();
            n.Document = this;
        
        
            if (src[0]=='/') {
                n.NodeType = XMLNodeType.CLOSE;
                src = src.substr(1);
            }
            else {
                // otherwise it's an open tag (possibly an empty element)
                n.NodeType = XMLNodeType.OPEN;
            }
        
            // if the last character is a /, check it's not a CLOSE tag
        
            if (src[src.length-1]=='/') {
                if (n.NodeType==XMLNodeType.CLOSE) {
                    throw new XmlDomError.ParseError("singleton close tag");
                }
                else {
                    n.NodeType = XMLNodeType.SINGLE;
                }
        
                // strip off the last character
        
                src = src.substr(0,src.length-1);
            }
        
            // set up the properties as appropriate
        
            if (n.NodeType!=XMLNodeType.CLOSE) {
                n.Attributes = new Dictionary<string,string>();
            }
        
            if (n.NodeType==XMLNodeType.OPEN) {
                n.Children = new ArrayList<XmlNode>();
            }
        
            // trim the Whitespace off the remaining content
        
            // src = Trim(src,true,true);
            src = src.trim();
        
            // chuck out an error if there's nothing left
        
            if (src.length==0) {
                throw new XmlDomError.ParseError("empty tag");
            }
        
            // scan forward until a space...
        
            var endOfName = FirstWhiteChar(src,0);
        
            // if there is no space, this is just a name (e.g. (<tag>, <tag/> or </tag>
        
            if (endOfName==-1) {
                n.TagName = src;
                return n;
            }
        
            // otherwise, we should expect attributes - but store the tag name first
        
            n.TagName = src.substr(0,endOfName);
        
            // start from after the tag name
        
            var pos = endOfName;
        
            // now we loop:
        
            while(pos< src.length) {
                pos = ParseAttribute(src, pos, n);
                if (pos==0) {
                    return null;
                }
        
                // and loop
        
            }
            return n;
        
        } // end function _XMLDoc_parseTag
        
        /*******************************************************************************************************************
        function:   _XMLDoc_removeNodeFromTree
    
        Author: djoham@yahoo.com
    
        Description:
            removes the specified node from the tree
    
            NOTE: the return value of this function is a new XmlDocument object
    
        *********************************************************************************************************************/
        public XmlDocument RemoveNodeFromTree(XmlNode node) 
        {
            var parentXMLText = GetUnderlyingXMLText();
            var selectedNodeXMLText = node.GetUnderlyingXMLText();
            var originalNodePos = parentXMLText.index_of(selectedNodeXMLText);
            var newXML = parentXMLText.substring(0,originalNodePos);
            newXML += parentXMLText.substring(originalNodePos + selectedNodeXMLText.length);
            var newDoc = new XmlDocument(newXML);
            return newDoc;
        } // end function _XMLDoc_removeNodeFromTree
        
        /*******************************************************************************************************************
        function:   _XMLDoc_replaceNodeContents
    
        Author: djoham@yahoo.com
    
        Description:
    
            make a node object out of the newContents text
            coming in ----
    
            The "X" node will be thrown away and only the Children
            used to replace the contents of the reference node
    
            NOTE: the return value of this function is a new XmlDocument object
    
        *********************************************************************************************************************/
        public XmlDocument ReplaceNodeContents(XmlNode referenceNode, string newContents) 
        {
            var newNode = CreateXMLNode("<X>" + newContents + "</X>");
            referenceNode.Children = newNode.Children;
            return this;
        } // end function _XMLDoc_replaceNodeContents
        
                
        /*******************************************************************************************************************
        function:	_XMLDoc_selectNodeText
    
        Author:		xwisdom@yahoo.com
    
        Description:
            selects a single node using the nodes tag path and then returns the node text.
        *********************************************************************************************************************/
        public string SelectNodeText(string tagpath)
        {
            var node=SelectNode(tagpath);
            if (node != null) {
                return node.GetText();
            }
            else {
                return null;
            }
        } // end function _XMLDoc_selectNodeText
    }
}