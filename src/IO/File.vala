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
namespace System.IO 
{

	public const string PathSeparator  = "/";
	public const char PathSeparatorChar  = '/';
	/**
	 * Simple File handler
	 * 
	 */
	
	public class File : Object {

		//  public Posix.Stat? stat;
		private FileStream _stream;
		private string _path;
		private string[] _files;

		public File(string path) 
        {
			_path = path;
            _stream = FileStream.open(_path, "r");
		} 

		public string GetPath() 
        {
			return _path;
		}

		/**
		 * the name is everything after the final separator
		 */
		public string GetName() 
        {
			for (var i=_path.length-1; i>0; i--)
				if (_path[i] == PathSeparatorChar)
					return _path.substring(i+1);
			return _path;
		}

		/**
		 * the parent is everything prior to the final separator
		 */
		public string GetParent() 
        {
			var i = _path.last_index_of(PathSeparator);
			return i < 0 ? "" : _path.substring(0, i);
		}

		/**
		 * check if the represented struture exists on the virtual disk
		 */
		public bool Exists() 
        {
			return _stream != null;
			
		}

		/**
		 * is it a file?
		 */
		public bool IsFile() 
        {
			return _stream != null;
		}

		/**
		 * is it a folder?
		 */
		public bool IsDirectory() 
        {
			return false;
		}

		/**
		 * get the length of the file
		 */
		public int Length() 
        {
			return 0;//_stream != null ? (int)_stream.size : 0;
		}
		
		/**
		 * read the contents into a string buffer
		 */
		public string Read() 
        {
			if (!Exists()) return "";
            string result = "";
            char buf[100];
            while (_stream.gets(buf) != null) {
                result += (string) buf;
            }
            return result;
		}
		
			/**
		 * return the list of files in the folder
		 */
		public string[] List() 
        {
			_files = new string[0];
			return _files;
		}
	}
}