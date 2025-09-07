# etc/CMakeLists.txt - Skeleton files for treecc

# Skeleton files are not installed as separate files
# They are embedded into the treecc binary via skels.c

set(SKELETON_FILES
    cpp_skel.cc
    cpp_skel.h
    c_skel.c
    c_skel.h
    cpp_gc_skel.cc
    cpp_gc_skel.h
    c_gc_skel.c
    c_gc_skel.h
)

# These files are handled by the main CMakeLists.txt for embedding
# but we include them in the distribution
install(FILES ${SKELETON_FILES} 
        DESTINATION ${CMAKE_INSTALL_DATADIR}/treecc/skels
        COMPONENT Documentation)