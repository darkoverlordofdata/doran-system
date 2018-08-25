public interface System.Xml.XmlReader : Object
{
    public abstract void Parse(string input);
    public abstract void SetDocumentHandler(DefaultHandler hnd);
    public abstract void SetErrorHandler(DefaultHandler hnd);
    public abstract void SetLexicalHandler(DefaultHandler hnd);
    
}
