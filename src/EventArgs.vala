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
using System.Collections.Generic;

namespace System {
    public class EventArgs : Object {
        public static void Initialize()
        {
            Empty = new EventArgs();
        }
        public static EventArgs Empty;
    }

    public delegate void Event<E>(Object sender, E e);
    
    public class EventHandler<E> : Object {
        public class Listener : Object {
            public Event Event;
            public Listener(Event evt) {
                this.Event = evt;
            }
        }
        public ArrayList<Listener> Listeners;

        public Event Dispatch = (o, e) => {};
        public EventHandler() {
            Listeners = new ArrayList<Listener>();
            Dispatch = (o, e) => {
                foreach (var listener in Listeners)
                    listener.Event(o, e);
            };
        }

        public void Add(Event evt) {
            Listeners.Add(new Listener(evt));
        }

        public void Remove(Event evt) {
            for (var i=0; i<Listeners.Count; i++) {
                if (Listeners[i].Event == evt) {
                    Listeners.RemoveAt(i);
                    return;
                }
            }
        }
        public void Clear() {
            Listeners.Clear();
        }
    }
}