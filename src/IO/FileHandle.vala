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
	/**
	 * get a better grip on the file object
	 */	
	public class FileHandle : Object 
    {
		internal File file;
		private string path;
		private FileType type;
		private FileStream stream;

		public FileHandle(string path, FileType type = FileType.Relative) 
        {
			this.type = type;
			this.path = path;
			this.file = new File(path);
			stream = FileStream.open(path, "r");
		}


		public string Read() 
        {
            // return file.Read();
			if (!file.Exists()) return "";
			string result = "";
			char buf[100];
			while (stream.gets(buf) != null) {
				result += (string) buf;
			}
			return result;

		}

		public FileType GetType() 
        {
			return type;
		}

		public string GetName() 
        {
			return file.GetName();
		}

		public string GetExt() 
        {
            var name = GetName();
            var i = name.last_index_of(".");
            if (i < 0) return "";
			var ext = name.substring(i);
			// BUG fix for emscripten:
			if (ext.index_of(".") < 0) ext = "."+ext;
			return ext;
		}

		public string GetPath() 
        {
			return file.GetPath();
		}

		public FileHandle GetParent() 
        {
			return new FileHandle(file.GetParent(), type);
        }

		public bool Exists() 
        {
            return file.Exists();
		}

		/**
		 * Gets a file that is a sibling
		 */
		public FileHandle Child(string name) 
        {
            return new FileHandle(file.GetPath() + File.Separator + name, type);
		}
	}
}