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
list ( APPEND SOURCE .lib/system/src/System.vala )
list ( APPEND SOURCE .lib/system/src/System/Environment.vala )
list ( APPEND SOURCE .lib/system/src/System/EventArgs.vala )
list ( APPEND SOURCE .lib/system/src/System/Exception.vala )
list ( APPEND SOURCE .lib/system/src/System/IComparable.vala )
list ( APPEND SOURCE .lib/system/src/System/IDisposable.vala )
list ( APPEND SOURCE .lib/system/src/System/IServiceProvider.vala )
list ( APPEND SOURCE .lib/system/src/System/WeakReference.vala )
list ( APPEND SOURCE .lib/system/src/System/TimeSpan.vala )
list ( APPEND SOURCE .lib/system/src/System/Diagnostics/Stopwatch.vala )
list ( APPEND SOURCE .lib/system/src/System/Collections/Generic/Collection.vala )
list ( APPEND SOURCE .lib/system/src/System/Collections/Generic/ArrayList.vala )
list ( APPEND SOURCE .lib/system/src/System/Collections/Generic/Dictionary.vala )
list ( APPEND SOURCE .lib/system/src/System/Collections/Generic/HashSet.vala )
list ( APPEND SOURCE .lib/system/src/System/Collections/Generic/Iterable.vala )
list ( APPEND SOURCE .lib/system/src/System/Collections/Generic/List.vala )
list ( APPEND SOURCE .lib/system/src/System/Collections/Generic/Map.vala )
list ( APPEND SOURCE .lib/system/src/System/Collections/Generic/Set.vala )
list ( APPEND SOURCE .lib/system/src/System/Collections/Generic/MapIterator.vala )
list ( APPEND SOURCE .lib/system/src/System/Collections/Generic/TimSort.vala )
list ( APPEND SOURCE .lib/system/src/System/Collections/Generic/Iterator.vala )

# Vapis: 

# Vapidir: 

## Export to the parent scope:
set ( SYSTEM true PARENT_SCOPE )
set ( INCLUDES "${INCLUDES};${INCLUDE}" PARENT_SCOPE )

set ( VALA_SOURCES "${VALA_SOURCES};${SOURCE}" PARENT_SCOPE )





# (generated from template: package. Do not modify. )
