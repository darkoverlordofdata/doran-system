namespace System.Xml
{
    using System.Collections.Generic;

    // =========================================================================
    // =========================================================================
    // =========================================================================
    // XML NODE FUNCTIONS
    // =========================================================================
    // =========================================================================
    // =========================================================================
    public class XmlNode : Object
    {
        public Dictionary<string,string> Attributes;
        public ArrayList<XmlNode> Children;
        public XmlDocument Document;
        public XmlNode Parent;
        public string TagName;
        public string Content;
        public XMLNodeType NodeType;
        internal XmlNode DocNode;
        internal string Source;

        /*******************************************************************************************************************
        function: xmlNode

        Author: mike@idle.org

        Description:

            XmlNode() is a constructor for a node of XML (text, comment, cdata, tag, etc)

            nodeType = indicates the node type of the node
            Doc == contains a reference to the XmlDocument object describing the document
            str == contains the text for the tag or text entity

        *********************************************************************************************************************/
        public XmlNode(XMLNodeType nodeType=null, XmlDocument document=null, string str=null) 
        {
            // the content of text (also CDATA and COMMENT) nodes
            if (nodeType==XMLNodeType.TEXT || nodeType==XMLNodeType.CDATA || nodeType==XMLNodeType.COMMENT ) {
                Content = str;
            }
            else {
                Content = null;
            }

            Attributes = null; // an array of attributes (used as a hash table)
            Children = null;   // an array (list) of the Children of this node
            Document = document;         // a reference to the document
            NodeType = nodeType;          // the type of the node
            Parent = null;
            TagName = "";           // the name of the tag (if a tag node)

        }  // end function XmlNode

        /*******************************************************************************************************************
        function: _XMLNode_addAttribute

        Author: mike@idle.org

        Description:
            add an attribute to a node
        *********************************************************************************************************************/
        public bool AddAttribute(string attributeName, string attributeValue) 
        {
            //if the name is found, the old value is overwritten by the new value
            Attributes["_" + attributeName] = attributeValue;
            return true;
        } // end function _XMLNode_addAttribute

        /*******************************************************************************************************************
        function: _XMLNode_addElement

        Author: mike@idle.org

        Description:
            add an element child to a node
        *********************************************************************************************************************/
        public bool AddElement(XmlNode node) 
        {
            node.Parent = this;
            Children.Add(node);
            return true;
        } // end function _XMLNode_addElement

        /*******************************************************************************************************************
        function: _XMLNode_getAttribute

        Author: mike@idle.org

        Description:
            get the value of a named attribute from an element node

            NOTE: we prefix with "_" because of the weird 'length' meta-property

        *********************************************************************************************************************/
        public string GetAttribute(string name) 
        {
            if (Attributes == null) {
                return null;
            }
            return Attributes["_" + name];
        } // end function _XMLNode_getAttribute

        /*******************************************************************************************************************
        function: _XMLNode_GetAttributeNames

        Author: mike@idle.org

        Description:
            get a list of attribute names for the node

            NOTE: we prefix with "_" because of the weird 'length' meta-property

            NOTE: Version 1.0 of GetAttributeNames breaks backwards compatibility. Previous to 1.0
            GetAttributeNames would return null if there were no attributes. 1.0 now returns an
            array of length 0.


        *********************************************************************************************************************/
        public ArrayList<string> GetAttributeNames() 
        {
            if (Attributes == null) {
                var ret = new ArrayList<string>();
                return ret;
            }

            var attlist = new ArrayList<string>();

            foreach (var a in Attributes.Keys) {
                attlist.Add(a.substr(1));
            }
            return attlist;
        } // end function _XMLNode_GetAttributeNames

        /***********************************************************************************
        Function: getElementById

        Author: djoham@yahoo.com

        Description:
            Brute force searches through the XML DOM tree
            to find the node with the unique ID passed in

        ************************************************************************************/
        public XmlNode GetElementById(string id) 
        {
            var node = this;
            XmlNode ret = null;

            //alert("tag name=" + node.TagName);
            //alert("id=" + node.getAttribute("id"));
            if (node.GetAttribute("id") == id) {
                return node;
            }
            else{
                var elements = node.GetElements();
                //alert("length=" + rugrats.length);
                var intLoop = 0;
                //do NOT use a for loop here. For some reason
                //it kills some browsers!!!
                while (intLoop < elements.Count) {
                    //alert("intLoop=" + intLoop);
                    var element = elements[intLoop];
                    //alert("recursion");
                    ret = element.GetElementById(id);
                    if (ret != null) {
                        //alert("breaking");
                        break;
                    }
                    intLoop++;
                }
            }
            return ret;
        } // end function _XMLNode_getElementById

        /*******************************************************************************************************************
        function:   _XMLNode_getElements

        Author: mike@idle.org

        Description:
            get an array of element Children of a node
            with an optional filter by name

            NOTE: Version 1.0 of getElements breaks backwards compatibility. Previous to 1.0
            getElements would return null if there were no attributes. 1.0 now returns an
            array of length 0.


        *********************************************************************************************************************/
        public ArrayList<XmlNode> GetElements(string byName=null) 
        {
            if (Children==null) {
                var ret = new ArrayList<XmlNode>();
                return ret;
            }

            var elements = new ArrayList<XmlNode>();

            for (var i=0; i<Children.Count; i++) {
                if ((Children[i].NodeType==XMLNodeType.ELEMENT) && ((byName==null) || (Children[i].TagName == byName))) {
                    elements.Add(Children[i]);
                }
            }
            return elements;
        } // end function _XMLNode_getElements

        /*******************************************************************************************************************
        function:       _XMLNode_getText

        Author: mike@idle.org

        Description:
            a method to get the text of a given node (recursively, if it's an element)
        *********************************************************************************************************************/
        public string GetText() 
        {
            if (NodeType==XMLNodeType.ELEMENT) {
                if (Children==null) {
                    return null;
                }
                var str = "";
                for (var i=0; i < Children.Count; i++) {
                    var t = Children[i].GetText();
                    str +=  (t == null ? "" : t);
                }
                return str;
            }
            else if (NodeType==XMLNodeType.TEXT) {
                return ConvertEscapes(Content);
            }
            else {
                return Content;
            }
        } // end function _XMLNode_getText



        /*******************************************************************************************************************
        function:       _XMLNode_getParent

        Author: mike@idle.org

        Description:
            get the parent of this node
        *********************************************************************************************************************/
        public XmlNode GetParent() 
        {
            return Parent;
        } // end function _XMLNode_getParent


        /*******************************************************************************************************************
        function:       David Joham

        Author: djoham@yahoo.com

        Description:
            returns the underlying XML text for the node
            by calling the _displayElement function
        *********************************************************************************************************************/
        public string GetUnderlyingXMLText() 
        {
            var strRet = "";
            strRet = DisplayElement(this, strRet);
            return strRet;

        } // end function _XMLNode_getUnderlyingXMLText

        /*******************************************************************************************************************
        function:       _XMLNode_removeAttribute

        Author: djoham@yahoo.com

        Description:
            remove an attribute from a node
        *********************************************************************************************************************/
        public bool RemoveAttribute(string attributeName) 
        {
            if(attributeName == null) {
                throw new XmlDomError.ParseError("You must pass an attribute name into the removeAttribute function");
            }

            Attributes.Remove(attributeName);

            //now remove the attribute from the list.
            // I want to keep the logic for adding attribtues in one place. I'm
            // going to get a temp array of attributes and values here and then
            // use the addAttribute function to re-add the attributes
            // var attributes = this.GetAttributeNames();
            // var intCount = attributes.length;
            // var tmpAttributeValues = new ArrayList<XMLAttribute>();
            // for ( intLoop = 0; intLoop < intCount; intLoop++) {
            //     tmpAttributeValues[intLoop] = this.getAttribute(attributes[intLoop]);
            // }

            // // now blow away the old attribute list
            // Attributes = new Array();

            // //now add the attributes back to the array - leaving out the one we're removing
            // for (intLoop = 0; intLoop < intCount; intLoop++) {
            //     if ( attributes[intLoop] != attributeName) {
            //         this.addAttribute(attributes[intLoop], tmpAttributeValues[intLoop]);
            //     }
            // }

        return true;

        } // end function _XMLNode_removeAttribute



        /*******************************************************************************************************************
        function:       _XMLNode_toString

        Author: mike@idle.org

        Description:
            produces a diagnostic string description of a node
        *********************************************************************************************************************/
        public string ToString()
        {
            return to_string();
        }
        public string to_string(int tab=0) 
        {
            var str = new StringBuilder();
            string[] tabs = new string[tab];
            for (var i=0; i<tab; i++) tabs[i] = "";
            var indent = string.joinv(" ", tabs);
            
            if (Children != null)
                foreach (var node in Children)
                    str.append("%s%s".printf(indent, node.to_string(tab+2)));

            // return indent + NodeType.to_string() + ":" 
            return "" 
                + (NodeType==XMLNodeType.TEXT 
                || NodeType==XMLNodeType.CDATA 
                || NodeType==XMLNodeType.COMMENT ? Content : TagName)
                + str.str;

        } // end function _XMLNode_toString

        private string toString2(int tab)
        {
            var str = new StringBuilder();
            string[] tabs = new string[tab];
            var indent = string.joinv("", tabs);
            
            foreach (var node in Children)
                str.append("%s%s\n".printf(indent, node.to_string()));
            return str.str;
        }

        /*******************************************************************************************************************
        function:       _XMLDoc_getTagNameParams

        Author: xwisdom@yahoo.com

        Description:
            convienience function for the nodeSearch routines
        *********************************************************************************************************************/
        private string[] GetTagNameParams(string str)
        {
            var tag = str;
            int open = tag.index_of("[");
            int close;
            string element = null;
            string[] attr = { "", "" };

            if (open >= 0) 
            {
                close = tag.index_of("]");
                if (close >= 0)
                    element = tag.substring(open+1,(close-open)-1);
                else 
                    throw new XmlDomError.ParseError("expected ] near "+tag);
                tag = tag.substring(0,open);
                if (element != null && element != "*")
                {
                    attr = element
                            .substring(1,element.length-1)
                            .split("=");
                    if (attr[1] != "") 
                    { //remove "
                        open = attr[1].index_of("\"");
                        attr[1] = attr[1].substring(open+1,attr[1].length-1);
                        close = attr[1].index_of("\"");
                        if ( close>=0 ) 
                            attr[1]=attr[1].substring(0,close);
                        else 
                            throw new XmlDomError.ParseError("expected \" near "+tag);
                    }
                    element=null;
                }
                else 
                    if (element == "*") 
                        element=null;
            }
            return { tag, element, attr[0], attr[1] };
        } // end function _XMLDoc_getTagNameParams

        /*******************************************************************************************************************
        function:	_XMLDoc_selectNode
    
        Author:		xwisdom@yahoo.com
    
        Description:
            selects a single node using the nodes tag path.
            examples: /node1/node2  or  /taga/tag1[0]/tag2
        *********************************************************************************************************************/
        public XmlNode SelectNode(string path=null)
        {
            bool ok;
            int element;
            string tag = "";
            string[] params;
            string[] tags;
            string attributeName;
            string attributeValue;
            XmlNode node;
            ArrayList<XmlNode> nodeList;

            var tagPath = Trim(path, true, true);
            
            if (Source == null) 
                return null;
            node=DocNode;
            if (tagPath == null) 
                return node;
            if (tagPath.index_of("/") == 0) 
                tagPath = tagPath.substring(1);
            tagPath = tagPath.replace(tag,"");
            tags = tagPath.split("/");
            tag = tags[0];
            if (tag != "")
            {
                if (tagPath.index_of("/") == 0)
                    tagPath = tagPath.substring(1);
                tagPath = tagPath.replace(tag,"");
                params = GetTagNameParams(tag);
                tag = params[0];
                element = int.parse(params[1]);
                attributeName = params[2];
                attributeValue = params[3];
                nodeList = (tag == "*") ? node.GetElements() : node.GetElements(tag);
                if (nodeList.Count>0) 
                {
                    if(element<0)
                    {
                        var i = 0;
                        while (i<nodeList.Count)
                        {
                            if(attributeName != "")
                            {
                                if (nodeList[i].GetAttribute(attributeName)!=attributeValue) 
                                    ok = false;
                                else 
                                    ok = true;
                            }
                            else 
                                ok=true;
                            if (ok)
                            {
                                node = nodeList[i].SelectNode(tagPath);
                                if(node != null) 
                                    return node;
                            }
                            i++;
                        }
                    }
                    else
                    { 
                        if (element<nodeList.Count)
                        {
                            node=nodeList[element].SelectNode(tagPath);
                            if(node != null) 
                                return node;
                        }
                    }
                }
            }
            return null;
        } // end function _XMLDoc_selectNode
    }
}