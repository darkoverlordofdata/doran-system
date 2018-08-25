public abstract class System.Xml.DefaultHandler : Object
{
    public virtual void Characters(string data, int start, int len){}
    public virtual void Comment(string data, int start, int len){}
    public virtual void EndCDATA(){}
    public virtual void EndDocument(){}
    public virtual void EndElement(string tagName){}
    public virtual void Error(SAX exception){}
    public virtual void FatalError(SAX exception){}
    public virtual void ProcessingInstruction(string tagName, string data){}
    public virtual void SetDocumentLocator(Locator locator){}
    public virtual void StartCDATA(){}
    public virtual void StartDocument(){}
    public virtual void StartElement(string tagName, SaxDriver attr){}
}

