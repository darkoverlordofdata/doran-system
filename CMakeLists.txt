cmake_minimum_required ( VERSION 3.1 )
###################################################################################
#
#   Library: system
#
###################################################################################
project ( system VERSION 0.0.1 )

# Includes: 

# C Sources: 

# Vala Sources: 
list ( APPEND SOURCE .lib/system/src/Environment.vala )
list ( APPEND SOURCE .lib/system/src/EventArgs.vala )
list ( APPEND SOURCE .lib/system/src/IComparable.vala )
list ( APPEND SOURCE .lib/system/src/IDisposable.vala )
list ( APPEND SOURCE .lib/system/src/Exception.vala )
list ( APPEND SOURCE .lib/system/src/Main.vala )
list ( APPEND SOURCE .lib/system/src/IServiceProvider.vala )
list ( APPEND SOURCE .lib/system/src/TimeSpan.vala )
list ( APPEND SOURCE .lib/system/src/Variant.vala )
list ( APPEND SOURCE .lib/system/src/WeakReference.vala )
list ( APPEND SOURCE .lib/system/src/Diagnostics/Stopwatch.vala )
list ( APPEND SOURCE .lib/system/src/Collections/Generic/ArrayList.vala )
list ( APPEND SOURCE .lib/system/src/Collections/Generic/Collection.vala )
list ( APPEND SOURCE .lib/system/src/Collections/Generic/Dictionary.vala )
list ( APPEND SOURCE .lib/system/src/Collections/Generic/HashSet.vala )
list ( APPEND SOURCE .lib/system/src/Collections/Generic/Iterator.vala )
list ( APPEND SOURCE .lib/system/src/Collections/Generic/List.vala )
list ( APPEND SOURCE .lib/system/src/Collections/Generic/Map.vala )
list ( APPEND SOURCE .lib/system/src/Collections/Generic/Iterable.vala )
list ( APPEND SOURCE .lib/system/src/Collections/Generic/Set.vala )
list ( APPEND SOURCE .lib/system/src/Collections/Generic/TimSort.vala )
list ( APPEND SOURCE .lib/system/src/Collections/Generic/MapIterator.vala )

# Vapis: 

# Vapidir: 
list ( APPEND VALA_OPTION --vapidir=${CMAKE_SOURCE_DIR}/.lib/system/vapis)

## Export to the parent scope:
set ( SYSTEM true PARENT_SCOPE )
set ( INCLUDES "${INCLUDES};${INCLUDE}" PARENT_SCOPE )

set ( VALA_SOURCES "${VALA_SOURCES};${SOURCE}" PARENT_SCOPE )

set ( VALAC_OPTIONS "${VALAC_OPTIONS};${VALA_OPTION}" PARENT_SCOPE )



# (generated from template: package. Do not modify. )
