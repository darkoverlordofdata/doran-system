// =========================================================================
//
// xmldom.js - an XML DOM parser in JavaScript.
//
//	This is the classic DOM that has shipped with XML for <SCRIPT>
//  since the beginning. For a more standards-compliant DOM, you may
//  wish to use the standards-compliant W3C DOM that is included
//  with XML for <SCRIPT> versions 3.0 and above
//
// version 3.1
//
// =========================================================================
//
// Copyright (C) 2000 - 2002, 2003 Michael Houghton (mike@idle.org), Raymond Irving and David Joham (djoham@yahoo.com)
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


// =========================================================================
// =========================================================================
// =========================================================================

namespace System.Xml
{
    // =========================================================================
    // =========================================================================
    // =========================================================================

    public enum XMLNodeType
    {
        ELEMENT,
        COMMENT,
        TEXT, 
        CDATA,
        OPEN,
        CLOSE,
        SINGLE
    }

    //define the characters which constitute Whitespace, and Quotes
    internal const string Whitespace = "\n\r\t ";
    internal const string Quotes = "\"'";

    // =========================================================================
    // =========================================================================
    // =========================================================================

    // CONVENIENCE FUNCTIONS

    // =========================================================================
    // =========================================================================
    // =========================================================================

    /*******************************************************************************************************************
    function: convertEscapes

    Author: David Joham <djoham@yahoo.com>

    Description:
        Characters such as less-than signs, greater-than signs and ampersands are
        illegal in XML syntax and must be escaped before being inserted into the DOM.
        This function is a convience function to take those escaped characters and
        return them to their original values for processing outside the parser

        This XML Parser automagically converts the content of the XML elements to
        their non-escaped values when xmlNode.getText() is called for every element
        except CDATA.

        EXAMPLES:

        &amp; == &
        &lt; == <
        &gt; == >

    *********************************************************************************************************************/
    internal string ConvertEscapes(string str) 
    {
        // not all Konqueror installations have regex support for some reason. Here's the original code using regexes
        // that is probably a little more efficient if it matters to you
        /*
        var escAmpRegEx = /&amp;/g;
        var escLtRegEx = /&lt;/g;
        var escGtRegEx = /&gt;/g;
    
        str = str.replace(escAmpRegEx, "&");
        str = str.replace(escLtRegEx, "<");
        str = str.replace(escGtRegEx, ">");
        */
    
        //&lt;
        var gt = -1;
        while (str.index_of("&lt;", gt + 1) > -1) {
            gt = str.index_of("&lt;", gt + 1);
            var newStr = str.substring(0, gt);
            newStr += "<";
            newStr = newStr + str.substring(gt + 4, str.length);
            str = newStr;
        }
    
        //&gt;
        gt = -1;
        while (str.index_of("&gt;", gt + 1) > -1) {
            gt = str.index_of("&gt;", gt + 1);
            var newStr = str.substring(0, gt);
            newStr += ">";
            newStr = newStr + str.substring(gt + 4, str.length);
            str = newStr;
        }
    
        //&amp;
        gt = -1;
        while (str.index_of("&amp;", gt + 1) > -1) {
            gt = str.index_of("&amp;", gt + 1);
            var newStr = str.substring(0, gt);
            newStr += "&";
            newStr = newStr + str.substring(gt + 5, str.length);
            str = newStr;
        }
    
        return str;
    } // end function convertEscapes
    
    
    /*******************************************************************************************************************
    function: convertToEscapes

    Author: David Joham djoham@yahoo.com

    Description:
        Characters such as less-than signs, greater-than signs and ampersands are
        illegal in XML syntax. This function is a convience function to escape those
        characters out to there legal values.

        EXAMPLES:

        < == &lt;
        > == &gt;
        & == &amp;
    *********************************************************************************************************************/
    internal string ConvertToEscapes(string str) 
    {
        // not all Konqueror installations have regex support for some reason. Here's the original code using regexes
        // that is probably a little more efficient if it matters to you
        /*
        var escAmpRegEx = /&/g;
        var escLtRegEx = /</g;
        var escGtRegEx = />/g;
        str = str.replace(escAmpRegEx, "&amp;");
        str = str.replace(escLtRegEx, "&lt;");
        str = str.replace(escGtRegEx, "&gt;");
        */
    
        // start with &
        var gt = -1;
        while (str.index_of("&", gt + 1) > -1) {
            gt = str.index_of("&", gt + 1);
            var newStr = str.substring(0, gt);
            newStr += "&amp;";
            newStr = newStr + str.substring(gt + 1, str.length);
            str = newStr;
        }
    
        // now <
        gt = -1;
        while (str.index_of("<", gt + 1) > -1) {
            gt = str.index_of("<", gt + 1);
            var newStr = str.substring(0, gt);
            newStr += "&lt;";
            newStr = newStr + str.substring(gt + 1, str.length);
            str = newStr;
        }
    
        //now >
        gt = -1;
        while (str.index_of(">", gt + 1) > -1) {
            gt = str.index_of(">", gt + 1);
            var newStr = str.substring(0, gt);
            newStr += "&gt;";
            newStr = newStr + str.substring(gt + 1, str.length);
            str = newStr;
        }
    
    
        return str;
    } // end function convertToEscapes

    /*******************************************************************************************************************
    function:       _displayElement

    Author: djoham@yahoo.com

    Description:
        returns the XML string associated with the DOM element passed in
        recursively calls itself if child elements are found

    *********************************************************************************************************************/
    internal string DisplayElement(XmlNode domElement, string str) 
    {
        if(domElement==null) {
            return "";
        }
        if(!(domElement.NodeType==XMLNodeType.ELEMENT)) {
            return "";
        }
    
        var strRet = str;
        var tagName = domElement.TagName;
        var tagInfo = "";
        tagInfo = "<" + tagName;
    
        // attributes
        var attributeList = domElement.GetAttributeNames();
    
        for(var intLoop = 0; intLoop < attributeList.Count; intLoop++) {
            var attribute = attributeList[intLoop];
            tagInfo = tagInfo + " " + attribute + "=";
            tagInfo = tagInfo + "\"" + domElement.GetAttribute(attribute) + "\"";
        }
    
        //close the element name
        tagInfo = tagInfo + ">";
    
        strRet=strRet+tagInfo;
    
        // Children
        if(domElement.Children!=null) {
            var domElements = domElement.Children;
            for(var intLoop = 0; intLoop < domElements.Count; intLoop++) {
                var childNode = domElements[intLoop];
                if(childNode.NodeType==XMLNodeType.COMMENT) {
                    strRet = strRet + "<!--" + childNode.Content + "-->";
                }
    
                else if(childNode.NodeType==XMLNodeType.TEXT) {
                    // var cont = Trim(childNode.Content,true,true);
                    var cont = childNode.Content.trim();
                    strRet = strRet + childNode.Content;
                }
    
                else if (childNode.NodeType==XMLNodeType.CDATA) {
                    // var cont = Trim(childNode.Content,true,true);
                    var cont = childNode.Content.trim();
                    strRet = strRet + "<![CDATA[" + cont + "]]>";
                }
    
                else {
                    strRet = DisplayElement(childNode, strRet);
                }
            } // end looping through the DOM elements
        } // end checking for domElements.Children = null
    
        //ending tag
        strRet = strRet + "</" + tagName + ">";
        return strRet;
    } // end function displayElement
        
    /*******************************************************************************************************************
    function: firstWhiteChar

    Author: may106@psu.edu ?

    Description:
        return the position of the first Whitespace character in str after position pos

    *********************************************************************************************************************/
    internal int FirstWhiteChar(string str, int pos) 
    {
        if (IsEmpty(str)) {
            return -1;
        }
    
        while(pos < str.length) {
            if (Whitespace.index_of(str.substring(pos,1))!=-1) {
                return pos;
            }
            else {
                pos++;
            }
        }
        return str.length;
    } // end function firstWhiteChar
            
    /*******************************************************************************************************************
    function: isEmpty

    Author: mike@idle.org

    Description:
        convenience function to identify an empty string

    *********************************************************************************************************************/
    internal bool IsEmpty(string str) 
    {
        return (str==null) || (str.length==0);
    } // end function isEmpty
    
    /*******************************************************************************************************************
    function: trim

    Author: may106@psu.edu

    Description:
        helper function to trip a string (trimString) of leading (leftTrim)
        and trailing (rightTrim) Whitespace

    *********************************************************************************************************************/
    // internal string Trim(string trimString, bool leftTrim=true, bool rightTrim=true) 
    // {
    //     if (IsEmpty(trimString)) {
    //         return "";
    //     }
    
    //     // the general focus here is on minimal method calls - hence only one
    //     // substring is done to complete the trim.
    
    //     var left=0;
    //     var right=0;
    //     var i=0;
    //     var k=0;
    
    //     // modified to properly handle strings that are all Whitespace
    //     if (leftTrim == true) {
    //         while ((i<trimString.length) && (Whitespace.index_of(trimString.substring(i++,1))!=-1)) {
    //             left++;
    //         }
    //     }
    //     if (rightTrim == true) {
    //         k=trimString.length-1;
    //         while ((k>=left) && (Whitespace.index_of(trimString.substring(k--,1))!=-1)) {
    //             right++;
    //         }
    //     }
    //     return trimString.substr(left, trimString.length - right);
    // } // end function trim    

    
}
