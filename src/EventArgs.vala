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
            Listeners.add(new Listener(evt));
        }

        public void Remove(Event evt) {
            for (var i=0; i<Listeners.size; i++) {
                if (Listeners[i].Event == evt) {
                    Listeners.remove_at(i);
                    return;
                }
            }
        }
        public void Clear() {
            Listeners.clear();
        }
    }
}