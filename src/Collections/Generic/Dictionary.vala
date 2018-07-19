/* hashmap.vala
 *
 * Copyright (C) 1995-1997  Peter Mattis, Spencer Kimball and Josh MacDonald
 * Copyright (C) 1997-2000  GLib Team and others
 * Copyright (C) 2007-2009  Jürg Billeter
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.

 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.

 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 * Author:
 * 	Jürg Billeter <j@bitron.ch>
 */

using GLib;

/**
 * Hashtable implementation of the Map interface.
 */
public class System.Collections.Generic.Dictionary<K,V> : Map<K,V> {
	public override int Count {
		get { return _nnodes; }
	}

	public HashFunc<K> key_hash_func {
		set { _key_hash_func = value; }
	}

	public EqualFunc<K> key_equal_func {
		set { _key_equal_func = value; }
	}

	public EqualFunc<V> value_equal_func {
		set { _value_equal_func = value; }
	}

	private int _array_size;
	private int _nnodes;
	private Node<K,V>[] _nodes;

	// concurrent modification protection
	private int _stamp = 0;

	private HashFunc<K> _key_hash_func;
	private EqualFunc<K> _key_equal_func;
	private EqualFunc<V> _value_equal_func;

	private const int MIN_SIZE = 11;
	private const int MAX_SIZE = 13845163;

	public Dictionary (
		HashFunc<K> key_hash_func = null, 
		EqualFunc<K> key_equal_func = null, 
		EqualFunc<V> value_equal_func = null) 
	{

		this.key_hash_func = key_hash_func == null 
			? typeof(K).is_a(typeof(string))
				? GLib.str_hash 
				: GLib.direct_hash
			: key_hash_func;

		this.key_equal_func = key_equal_func == null
			? typeof(K).is_a(typeof(string))
				? GLib.str_equal 
				: GLib.direct_equal
			: key_equal_func;

		this.value_equal_func = value_equal_func == null
			? typeof(V).is_a(typeof(string))
				? GLib.str_equal 
				: GLib.direct_equal
			: value_equal_func;

		_array_size = MIN_SIZE;
		_nodes = new Node<K,V>[_array_size];
	}

	public override Set<K> Keys 
	{
		owned get { return new KeySet<K,V> (this); }
	}

	public override Collection<V> Values 
	{
		owned get { return new ValueCollection<K,V> (this); }
	}

	public override System.Collections.Generic.MapIterator<K,V> map_iterator () {
		return new MapIterator<K,V> (this);
	}

	private Node<K,V>** lookup_node (K key) {
		uint hash_value = _key_hash_func (key);
		Node<K,V>** node = &_nodes[hash_value % _array_size];
		while ((*node) != null && (hash_value != (*node)->key_hash || !_key_equal_func ((*node)->key, key))) {
			node = &((*node)->next);
		}
		return node;
	}

	public override bool ContainsKey (K key) {
		Node<K,V>** node = lookup_node (key);
		return (*node != null);
	}

	public override V? get (K key) {
		Node<K,V>* node = (*lookup_node (key));
		if (node != null) {
			return node->value;
		} else {
			return null;
		}
	}

	public override void set (K key, V value) {
		Node<K,V>** node = lookup_node (key);
		if (*node != null) {
			(*node)->value = value;
		} else {
			uint hash_value = _key_hash_func (key);
			*node = new Node<K,V> (key, value, hash_value);
			_nnodes++;
			resize ();
		}
		_stamp++;
	}

	public override bool Remove (K key) {
		Node<K,V>** node = lookup_node (key);
		if (*node != null) {
			Node<K,V> next = (owned) (*node)->next;

			(*node)->key = null;
			(*node)->value = null;
			delete *node;

			*node = (owned) next;

			_nnodes--;
			resize ();
			_stamp++;
			return true;
		}
		return false;
	}

	public override void Clear () {
		for (int i = 0; i < _array_size; i++) {
			Node<K,V> node = (owned) _nodes[i];
			while (node != null) {
				Node next = (owned) node.next;
				node.key = null;
				node.value = null;
				node = (owned) next;
			}
		}
		_nnodes = 0;
		resize ();
	}

	private void resize () {
		if ((_array_size >= 3 * _nnodes && _array_size >= MIN_SIZE) ||
		    (3 * _array_size <= _nnodes && _array_size < MAX_SIZE)) {
			int new_array_size = (int) SpacedPrimes.closest (_nnodes);
			new_array_size = new_array_size.clamp (MIN_SIZE, MAX_SIZE);

			Node<K,V>[] new_nodes = new Node<K,V>[new_array_size];

			for (int i = 0; i < _array_size; i++) {
				Node<K,V> node;
				Node<K,V> next = null;
				for (node = (owned) _nodes[i]; node != null; node = (owned) next) {
					next = (owned) node.next;
					uint hash_val = node.key_hash % new_array_size;
					node.next = (owned) new_nodes[hash_val];
					new_nodes[hash_val] = (owned) node;
				}
			}
			_nodes = (owned) new_nodes;
			_array_size = new_array_size;
		}
	}

	~Dictionary () {
		Clear ();
	}

	[Compact]
	private class Node<K,V> {
		public K key;
		public V value;
		public Node<K,V> next;
		public uint key_hash;

		public Node (owned K k, owned V v, uint hash) {
			key = (owned) k;
			value = (owned) v;
			key_hash = hash;
		}
	}

	private class KeySet<K,V> : Set<K> {
		public Dictionary<K,V> map {
			set { _map = value; }
		}

		private Dictionary<K,V> _map;

		public KeySet (Dictionary map) {
			this.map = map;
		}

		public override Type get_element_type () {
			return typeof (K);
		}

		public override Iterator<K> iterator () {
			return new KeyIterator<K,V> (_map);
		}

		public override int Count {
			get { return _map.Count; }
		}

		public override bool Add (K key) {
			assert_not_reached ();
		}

		public override void Clear () {
			assert_not_reached ();
		}

		public override bool Remove (K key) {
			assert_not_reached ();
		}

		public override bool Contains (K key) {
			return _map.ContainsKey (key);
		}
	}

	private class MapIterator<K,V> : System.Collections.Generic.MapIterator<K, V> {
		public Dictionary<K,V> map {
			set {
				_map = value;
				_stamp = _map._stamp;
			}
		}

		private Dictionary<K,V> _map;
		private int _index = -1;
		private weak Node<K,V> _node;

		// concurrent modification protection
		private int _stamp;

		public MapIterator (Dictionary map) {
			this.map = map;
		}

		public override bool next () {
			if (_node != null) {
				_node = _node.next;
			}
			while (_node == null && _index + 1 < _map._array_size) {
				_index++;
				_node = _map._nodes[_index];
			}
			return (_node != null);
		}

		public override K? get_key () {
			assert (_stamp == _map._stamp);
			assert (_node != null);
			return _node.key;
		}

		public override V? get_value () {
			assert (_stamp == _map._stamp);
			assert (_node != null);
			return _node.value;
		}
	}

	private class KeyIterator<K,V> : Iterator<K> {
		public Dictionary<K,V> map {
			set {
				_map = value;
				_stamp = _map._stamp;
			}
		}

		private Dictionary<K,V> _map;
		private int _index = -1;
		private weak Node<K,V> _node;
		private weak Node<K,V> _next;

		// concurrent modification protection
		private int _stamp;

		public KeyIterator (Dictionary map) {
			this.map = map;
		}

		public override bool next () {
			assert (_stamp == _map._stamp);
			if (!has_next ()) {
				return false;
			}
			_node = _next;
			_next = null;
			return (_node != null);
		}

		public override bool has_next () {
			assert (_stamp == _map._stamp);
			if (_next == null) {
				_next = _node;
				if (_next != null) {
					_next = _next.next;
				}
				while (_next == null && _index + 1 < _map._array_size) {
					_index++;
					_next = _map._nodes[_index];
				}
			}
			return (_next != null);
		}

		public override K? get () {
			assert (_stamp == _map._stamp);
			assert (_node != null);
			return _node.key;
		}

		public override void Remove () {
			assert_not_reached ();
		}

		public override bool valid {
			get {
				return _node != null;
			}
		}
	}

	private class ValueCollection<K,V> : Collection<V> {
		public Dictionary<K,V> map {
			set { _map = value; }
		}

		private Dictionary<K,V> _map;

		public ValueCollection (Dictionary map) {
			this.map = map;
		}

		public override Type get_element_type () {
			return typeof (V);
		}

		public override Iterator<V> iterator () {
			return new ValueIterator<K,V> (_map);
		}

		public override int Count {
			get { return _map.Count; }
		}

		public override bool Add (V value) {
			assert_not_reached ();
		}

		public override void Clear () {
			assert_not_reached ();
		}

		public override bool Remove (V value) {
			assert_not_reached ();
		}

		public override bool Contains (V value) {
			Iterator<V> it = iterator ();
			while (it.next ()) {
				if (_map._value_equal_func (it.get (), value)) {
					return true;
				}
			}
			return false;
		}
	}

	private class ValueIterator<K,V> : Iterator<V> {
		public Dictionary<K,V> map {
			set {
				_map = value;
				_stamp = _map._stamp;
			}
		}

		private Dictionary<V,K> _map;
		private int _index = -1;
		private weak Node<K,V> _node;
		private weak Node<K,V> _next;

		// concurrent modification protection
		private int _stamp;

		public ValueIterator (Dictionary map) {
			this.map = map;
		}

		public override bool next () {
			assert (_stamp == _map._stamp);
			if (!has_next ()) {
				return false;
			}
			_node = _next;
			_next = null;
			return (_node != null);
		}

		public override bool has_next () {
			assert (_stamp == _map._stamp);
			if (_next == null) {
				_next = _node;
				if (_next != null) {
					_next = _next.next;
				}
				while (_next == null && _index + 1 < _map._array_size) {
					_index++;
					_next = _map._nodes[_index];
				}
			}
			return (_next != null);
		}

		public override V? get () {
			assert (_stamp == _map._stamp);
			assert (_node != null);
			return _node.value;
		}

		public override void Remove () {
			assert_not_reached ();
		}

		public override bool valid {
			get {
				return _node != null;
			}
		}
	}
}

