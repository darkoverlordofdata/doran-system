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
/**
 * API Compatibility with the Microsoft System namespace
 */


namespace System 
{

    /* shim resets the syntax highlighting in VSCode */
    private void shim() {}

    public void arraycopy<T>(T* src, int srcPos, T* dest, int destPos, int length)
    {
        Memory.copy(dest+destPos, src+srcPos, length*sizeof(T));
    }


    public void Initialize()
    {
        TimeSpan.Initialize();
        EventArgs.Initialize();
        Regex.Initialize();
    }
}