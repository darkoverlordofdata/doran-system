/* gobject-2.0.vala
 *
 * Modified for ZeroG
 * Copyright (C) 2018 Dark Overlord of Data
 *
 * Copyright (C) 2006-2010  Jürg Billeter
 * Copyright (C) 2006-2008  Raffaele Sandrini
 * Copyright (C) 2007  Mathias Hasselmann
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
 *	Raffaele Sandrini <rasa@gmx.ch>
 *	Mathias Hasselmann <mathias.hasselmann@gmx.de>
 */

/*
 * A platform-specific type that is used to represent a pointer or a handle
 */

[Compact, CCode (cname="ZIntPtr", cheader_filename = "glib.h", ref_function = "", unref_function = "")]
public class IntPtr 
{
	private int m_value;

	[CCode (cname = "z_int_ptr_Zero")]
	public static IntPtr Zero;

	[CCode (cname = "z_int_ptr_Size")]
	public static int Size;

	/**
	 * IntPtr is not ref counted or gc'd, so be
	 * sure to free any IntPtr's created using new
	 */
	[CCode (cname = "z_int_ptr_new")]
	public IntPtr(void* ptr);

	[CCode (cname = "z_int_ptr_new")]
	public IntPtr.ULong(ulong ptr);

	[CCode (cname = "z_int_ptr_ToPointer")]
	public void* ToPointer();

	[CCode (cname = "z_int_ptr_Equals")]
	public bool Equals(IntPtr other);

	[CCode (cname = "z_int_ptr_IsNull")]
	public bool IsNull();

	[CCode (cname = "z_int_ptr_GetHashCode")]
	public int GetHashCode();

	[CCode (cname = "z_int_ptr_Add")]
	public static IntPtr Add(IntPtr pointer, int offset);

	[CCode (cname = "z_int_ptr_Subtract")]
	public static IntPtr Subtract(IntPtr pointer, int offset);

	public string to_string()
	{
		return "IntPtr(0x%08x)".printf(m_value);
	}
	public string ToString()
	{
		return "IntPtr(0x%08x)".printf(m_value);
	}
}


[CCode (cheader_filename = "glib.h", cprefix = "G", gir_namespace = "GObject", gir_version = "2.0", lower_case_cprefix = "g_")]
namespace GLib {
	[CCode (lower_case_csuffix = "enum")]
	public class EnumClass : GLib.TypeClass {
		public int maximum;
		public int minimum;
		public uint n_values;
		[CCode (array_length_cname = "n_values")]
		public weak GLib.EnumValue[] values;
		public unowned GLib.EnumValue? get_value (int value);
		public unowned GLib.EnumValue? get_value_by_name (string name);
		public unowned GLib.EnumValue? get_value_by_nick (string name);
	}
	[CCode (lower_case_csuffix = "flags")]
	public class FlagsClass : GLib.TypeClass {
		public uint mask;
		public uint n_values;
		[CCode (array_length_cname = "n_values")]
		public weak GLib.FlagsValue[] values;
		public unowned GLib.FlagsValue? get_first_value (uint value);
		public unowned GLib.FlagsValue? get_value_by_name (string name);
		public unowned GLib.FlagsValue? get_value_by_nick (string name);
	}
	[CCode (cheader_filename = "glib-object.h", get_value_function = "g_value_get_object", marshaller_type_name = "OBJECT", param_spec_function = "g_param_spec_object", ref_function = "g_object_ref", set_value_function = "g_value_set_object", take_value_function = "g_value_take_object", unref_function = "g_object_unref")]
	public class Object {
		public uint ref_count;
		[CCode (construct_function = "g_object_new", has_new_function = false)]
		public Object (...);
		/**
		 * Mono compatability
		 */
		[CCode (cname = "g_object_to_string")]
		public virtual string ToString();
		[CCode (cname = "g_object_equals")]
		public virtual bool Equals(Object other);
		[CCode (cname = "g_object_get_hash_code")]
		public virtual int GetHashCode();
		public virtual string to_string();
		[CCode (cname = "g_object_instance_equals")]
		public static bool InstanceEquals(Object objA, Object objB);
		[CCode (cname = "g_object_reference_equals")]
		public static bool ReferenceEquals(Object objA, Object objB);
		
		/**
		 * GObject base
		 */
		[CCode (cname = "g_object_run_dispose")]
		public virtual void dispose ();
		[CCode (cname = "G_OBJECT_GET_CLASS")]
		public unowned GLib.ObjectClass get_class ();
		[CCode (cname = "G_TYPE_FROM_INSTANCE")]
		public GLib.Type get_type ();
		public static GLib.Object @new (GLib.Type type, ...);
		public void unref ();
		public void weak_ref (GLib.WeakNotify notify);
		public void weak_unref (GLib.WeakNotify notify);
	}
	[CCode (lower_case_csuffix = "object_class")]
	public class ObjectClass : GLib.TypeClass {
		[CCode (cname = "G_OBJECT_CLASS_NAME")]
		public unowned string get_name ();
		[CCode (cname = "G_OBJECT_CLASS_TYPE")]
		public GLib.Type get_type ();
	}
	[CCode (free_function = "g_type_class_unref")]
	[Compact]
	public class TypeClass {
		public void add_private (size_t private_size);
		[CCode (cname = "G_TYPE_FROM_CLASS")]
		public GLib.Type get_type ();
		[CCode (cname = "g_type_interface_peek")]
		public unowned GLib.TypeInterface? peek (GLib.Type iface_type);
		public unowned GLib.TypeClass? peek_parent ();
	}
	[Compact]
	public class TypeInstance {
	}
	[CCode (free_function = "g_type_default_interface_unref")]
	[Compact]
	public class TypeInterface {
		public void add_prerequisite ();
		public unowned GLib.TypePlugin get_plugin (GLib.Type interface_type);
		[CCode (cname = "G_TYPE_FROM_INTERFACE")]
		public GLib.Type get_type ();
		public unowned GLib.TypeInterface? peek_parent ();
	}
	[CCode (copy_function = "g_value_array_copy", free_function = "g_value_array_free", type_id = "G_TYPE_VALUE_ARRAY")]
	[Compact]
	[Version (deprecated = true, deprecated_since = "2.32")]
	public class ValueArray {
		public uint n_values;
		[CCode (array_length_cname = "n_values", array_length_type = "guint")]
		public GLib.Value[] values;
		public ValueArray (uint n_prealloced);
		public void append (GLib.Value value);
		public GLib.ValueArray copy ();
		public unowned GLib.Value? get_nth (uint index_);
		public void insert (uint index_, GLib.Value value);
		public void prepend (GLib.Value value);
		public void remove (uint index_);
		public void sort (GLib.CompareFunc<GLib.Value> compare_func);
		public void sort_with_data (GLib.CompareDataFunc<GLib.Value> compare_func);
	}
	[CCode (cheader_filename = "glib-object.h", type_id = "g_type_plugin_get_type ()")]
	public interface TypePlugin {
		public void complete_interface_info (GLib.Type instance_type, GLib.Type interface_type, GLib.InterfaceInfo info);
		public void complete_type_info (GLib.Type g_type, GLib.TypeInfo info, GLib.TypeValueTable value_table);
		public void unuse ();
		public void use ();
	}
	[CCode (has_type_id = false)]
	public struct EnumValue {
		public int value;
		public weak string value_name;
		public weak string value_nick;
	}
	[CCode (has_type_id = false)]
	public struct FlagsValue {
		public uint value;
		public weak string value_name;
		public weak string value_nick;
	}
	[CCode (has_type_id = false)]
	public struct InterfaceInfo {
		public GLib.InterfaceInitFunc interface_init;
		public GLib.InterfaceFinalizeFunc interface_finalize;
		public void* interface_data;
	}
	[CCode (get_value_function = "g_value_get_gtype", marshaller_type_name = "GTYPE", set_value_function = "g_value_set_gtype", type_id = "G_TYPE_GTYPE")]
	[GIR (fullname = "GType")]
	public struct Type : ulong {
		public const GLib.Type SHORT;
		public const GLib.Type BOOLEAN;
		public const GLib.Type BOXED;
		public const GLib.Type CHAR;
		public const GLib.Type DOUBLE;
		public const GLib.Type ENUM;
		public const GLib.Type FLAGS;
		public const GLib.Type FLOAT;
		public const GLib.Type INT;
		public const GLib.Type INT64;
		public const GLib.Type INTERFACE;
		public const GLib.Type INVALID;
		public const GLib.Type LONG;
		public const GLib.Type NONE;
		public const GLib.Type OBJECT;
		public const GLib.Type PARAM;
		public const GLib.Type POINTER;
		public const GLib.Type STRING;
		public const GLib.Type UCHAR;
		public const GLib.Type UINT;
		public const GLib.Type UINT64;
		public const GLib.Type ULONG;
		public const GLib.Type VARIANT;
		public void add_class_private (size_t private_size);
		[CCode (array_length_type = "guint")]
		public GLib.Type[] children ();
		public unowned GLib.TypeClass? class_peek ();
		public unowned GLib.TypeClass? class_peek_parent ();
		public unowned GLib.TypeClass? class_peek_static ();
		public unowned GLib.TypeClass? default_interface_peek ();
		public GLib.TypeInterface default_interface_ref ();
		public GLib.TypeClass class_ref ();
		public uint depth ();
		[Version (since = "2.34")]
		public void ensure ();
		[CCode (cname = "g_enum_to_string")]
		[Version (since = "2.54")]
		public string enum_to_string (int @value);
		[CCode (cname = "g_flags_to_string")]
		[Version (since = "2.54")]
		public string flags_to_string (uint @value);
		[CCode (cname = "G_TYPE_FROM_INSTANCE")]
		public static GLib.Type from_instance (void* instance);
		public static GLib.Type from_name (string name);
		[Version (since = "2.44")]
		public int get_instance_count ();
		public void* get_qdata (GLib.Quark quark);
		[Version (since = "2.36")]
		public static uint get_type_registration_serial ();
		[CCode (array_length_type = "guint")]
		public GLib.Type[] interface_prerequisites ();
		[CCode (array_length_type = "guint")]
		public GLib.Type[] interfaces ();
		public GLib.Type next_base (GLib.Type root_type);
		public bool is_a (GLib.Type is_a_type);
		[CCode (cname = "G_TYPE_IS_ABSTRACT")]
		public bool is_abstract ();
		[CCode (cname = "G_TYPE_IS_CLASSED")]
		public bool is_classed ();
		[CCode (cname = "G_TYPE_IS_DEEP_DERIVABLE")]
		public bool is_deep_derivable ();
		[CCode (cname = "G_TYPE_IS_DERIVABLE")]
		public bool is_derivable ();
		[CCode (cname = "G_TYPE_IS_DERIVED")]
		public bool is_derived ();
		[CCode (cname = "G_TYPE_IS_ENUM")]
		public bool is_enum ();
		[CCode (cname = "G_TYPE_IS_FLAGS")]
		public bool is_flags ();
		[CCode (cname = "G_TYPE_IS_FUNDAMENTAL")]
		public bool is_fundamental ();
		[CCode (cname = "G_TYPE_IS_INSTANTIATABLE")]
		public bool is_instantiatable ();
		[CCode (cname = "G_TYPE_IS_INTERFACE")]
		public bool is_interface ();
		[CCode (cname = "G_TYPE_IS_OBJECT")]
		public bool is_object ();
		[CCode (cname = "G_TYPE_IS_VALUE_TYPE")]
		public bool is_value_type ();
		public unowned string name ();
		public GLib.Type parent ();
		public GLib.Quark qname ();
		public void query (out GLib.TypeQuery query);
		public void set_qdata (GLib.Quark quark, void* data);
	}
	[CCode (has_type_id = false)]
	public struct TypeInfo {
		public uint16 class_size;
		public GLib.BaseInitFunc base_init;
		public GLib.BaseFinalizeFunc base_finalize;
		public GLib.ClassInitFunc class_init;
		public GLib.ClassFinalizeFunc class_finalize;
		public void* class_data;
		public uint16 instance_size;
		public uint16 n_preallocs;
		public GLib.InstanceInitFunc instance_init;
		unowned GLib.TypeValueTable value_table;
	}
	public struct TypeQuery {
		public GLib.Type type;
		public weak string type_name;
		public uint class_size;
		public uint instance_size;
	}
	[CCode (has_type_id = false)]
	public struct TypeValueTable {
	}
	[CCode (copy_function = "g_value_copy", destroy_function = "g_value_unset", get_value_function = "g_value_get_boxed", marshaller_type_name = "BOXED", set_value_function = "g_value_set_boxed", take_value_function = "g_value_take_boxed", type_id = "G_TYPE_VALUE", type_signature = "v")]
	public struct Value {
		public Value (GLib.Type g_type);
		public void copy (ref GLib.Value dest_value);
		public void* dup_boxed ();
		public GLib.Object dup_object ();
		public string dup_string ();
		[Version (since = "2.26")]
		public GLib.Variant dup_variant ();
		public bool fits_pointer ();
		public bool get_boolean ();
		public void* get_boxed ();
		[Version (deprecated = true, deprecated_since = "2.32")]
		public char get_char ();
		public double get_double ();
		public int get_enum ();
		public uint get_flags ();
		public float get_float ();
		[Version (since = "2.12")]
		public GLib.Type get_gtype ();
		public int get_int ();
		public int64 get_int64 ();
		public long get_long ();
		public unowned GLib.Object get_object ();
		public void* get_pointer ();
		[Version (since = "2.32")]
		public int8 get_schar ();
		public unowned string get_string ();
		public uchar get_uchar ();
		public uint get_uint ();
		public uint64 get_uint64 ();
		public ulong get_ulong ();
		[Version (since = "2.26")]
		public GLib.Variant get_variant ();
		[CCode (cname = "G_VALUE_HOLDS")]
		public bool holds (GLib.Type type);
		public unowned GLib.Value? init (GLib.Type g_type);
		[Version (since = "2.42")]
		public void init_from_instance (void* instance);
		public void* peek_pointer ();
		public static void register_transform_func (GLib.Type src_type, GLib.Type dest_type, GLib.ValueTransform transform);
		public unowned GLib.Value? reset ();
		public void set_boolean (bool v_boolean);
		public void set_boxed (void* v_boxed);
		[Version (deprecated = true, deprecated_since = "2.32")]
		public void set_char (char v_char);
		public void set_double (double v_double);
		public void set_enum (int v_enum);
		public void set_flags (uint v_flags);
		public void set_float (float v_float);
		[Version (since = "2.12")]
		public void set_gtype (GLib.Type v_gtype);
		public void set_instance (void* instance);
		public void set_int (int v_int);
		public void set_int64 (int64 v_int64);
		public void set_long (long v_long);
		public void set_object (GLib.Object v_object);
		public void set_pointer (void* v_pointer);
		[Version (since = "2.32")]
		public void set_schar (int8 v_char);
		public void set_static_string (string v_string);
		public void set_string (string v_string);
		public void set_uchar (uchar v_uchar);
		public void set_uint (uint v_uint);
		public void set_uint64 (uint64 v_uint64);
		public void set_ulong (ulong v_ulong);
		[CCode (cname = "g_strdup_value_contents")]
		public string strdup_contents ();
		public void take_object (owned GLib.Object v_object);
		public void take_string (owned string v_string);
		[Version (since = "2.26")]
		public void take_variant (owned GLib.Variant? variant);
		public bool transform (ref GLib.Value dest_value);
		[CCode (cname = "G_VALUE_TYPE")]
		public GLib.Type type ();
		public static bool type_compatible (GLib.Type src_type, GLib.Type dest_type);
		[CCode (cname = "G_VALUE_TYPE_NAME")]
		public unowned string type_name ();
		public static bool type_transformable (GLib.Type src_type, GLib.Type dest_type);
		public void unset ();
	}
	[CCode (destroy_function = "g_weak_ref_clear", lvalue_access = false)]
	[Version (since = "2.32")]
	public struct WeakRef {
		public WeakRef (GLib.Object? object);
		public GLib.Object? @get ();
		public void @set (GLib.Object? object);
	}
	[CCode (cprefix = "G_TYPE_DEBUG_", has_type_id = false)]
	[Flags]
	[Version (deprecated = true, deprecated_since = "2.36")]
	public enum TypeDebugFlags {
		NONE,
		OBJECTS,
		SIGNALS,
		INSTANCE_COUNT,
		MASK
	}
	[CCode (cprefix = "G_TYPE_FLAG_", has_type_id = false)]
	[Flags]
	public enum TypeFlags {
		ABSTRACT,
		VALUE_ABSTRACT
	}
	[CCode (cprefix = "G_TYPE_FLAG_", has_type_id = false)]
	[Flags]
	public enum TypeFundamentalFlags {
		CLASSED,
		INSTANTIATABLE,
		DERIVABLE,
		DEEP_DERIVABLE
	}
	[CCode (has_target = false)]
	public delegate void BaseInitFunc (GLib.TypeClass g_class);
	[CCode (has_target = false)]
	public delegate void BaseFinalizeFunc (GLib.TypeClass g_class);
	[CCode (has_target = false)]
	public delegate void Callback ();
	[CCode (has_target = false)]
	public delegate void ClassInitFunc (GLib.TypeClass g_class, void* class_data);
	[CCode (has_target = false)]
	public delegate void ClassFinalizeFunc (GLib.TypeClass g_class, void* class_data);
	[CCode (has_target = false)]
	public delegate void InstanceInitFunc (GLib.TypeInstance instance, GLib.TypeClass g_class);
	[CCode (has_target = false)]
	public delegate void InterfaceInitFunc (GLib.TypeInterface g_iface, void* iface_data);
	[CCode (has_target = false)]
	public delegate void InterfaceFinalizeFunc (GLib.TypeInterface g_iface, void* iface_data);
	[CCode (has_target = false)]
	public delegate void ObjectFinalizeFunc (GLib.Object object);
	[CCode (has_target = false)]
	public delegate void TypeClassCacheFunc (void* cache_data, GLib.TypeClass g_class);
	[CCode (has_target = false)]
	public delegate void ValueTransform (GLib.Value src_value, ref GLib.Value dest_value);
	[CCode (instance_pos = 0)]
	public delegate void WeakNotify (GLib.Object object);
}
