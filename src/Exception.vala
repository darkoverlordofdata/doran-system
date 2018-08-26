/* ******************************************************************************
 * Copyright 2018 darkoverlordofdata.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ******************************************************************************/

public errordomain System.Exception 
{
    ArgumentException,
    ArgumentOutOfRangeException,
    CloneNotSupportedException,
    IllegalArgumentException,
    IllegalStateException,
    IndexOutOfBoundsException,
    InvalidOperationException,
    NotImplemented,
    NullPointerException,
    NumberFormatException,
    OutOfMemoryError,
    OverflowException,
    StringIndexOutOfBoundsException    
}

public errordomain System.IOException 
{
    Exception,
    FileNotFoundException,
    IllegalArgumentException,
    IndexOutOfBoundsException,
    InternalError,
    InvalidData,
    NotSupported,
}

public errordomain System.JSONException {
    Exception,
    IOException,
    PointerException
}

public errordomain System.XmlDomError 
{
    ParseError
}

public errordomain System.SAX
{
    SaxException,
    SaxNotRecognizedException,
    SaxNotSupportedException,
    SaxParseException
}

