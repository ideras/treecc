cmake_minimum_required(VERSION 3.10)
project(treecc VERSION 0.3.11 LANGUAGES C)

set(CMAKE_C_STANDARD 90)
set(CMAKE_C_STANDARD_REQUIRED ON)

if(CMAKE_COMPILER_IS_GNUCC)
    add_compile_options(-Wall -Wextra)
endif()

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include(mkskel)

include(CheckIncludeFile)
include(CheckFunctionExists)
include(CheckSymbolExists)

check_include_file(sys/types.h HAVE_SYS_TYPES_H)
check_include_file(sys/stat.h HAVE_SYS_STAT_H)
check_include_file(stdlib.h HAVE_STDLIB_H)
check_include_file(string.h HAVE_STRING_H)
check_include_file(memory.h HAVE_MEMORY_H)
check_include_file(strings.h HAVE_STRINGS_H)
check_include_file(inttypes.h HAVE_INTTYPES_H)
check_include_file(stdint.h HAVE_STDINT_H)
check_include_file(unistd.h HAVE_UNISTD_H)
check_include_file(stdarg.h HAVE_STDARG_H)
check_include_file(stdio.h HAVE_STDIO_H)
check_include_file(varargs.h HAVE_VARARGS_H)

check_function_exists(access HAVE_ACCESS)
check_function_exists(memcmp HAVE_MEMCMP)
check_function_exists(memcpy HAVE_MEMCPY)
check_function_exists(qsort HAVE_QSORT)
check_function_exists(stat HAVE_STAT)
check_function_exists(strchr HAVE_STRCHR)
check_function_exists(vfprintf HAVE_VFPRINTF)
check_function_exists(vsnprintf HAVE_VSNPRINTF)
check_function_exists(vsprintf HAVE_VSPRINTF)
check_function_exists(_vsnprintf HAVE__VSNPRINTF)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/config.h.cmake.in 
               ${CMAKE_CURRENT_BINARY_DIR}/config.h)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

set(SKELETON_FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/etc/c_skel.c
    ${CMAKE_CURRENT_SOURCE_DIR}/etc/c_skel.h
    ${CMAKE_CURRENT_SOURCE_DIR}/etc/cpp_skel.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/etc/cpp_skel.h
    ${CMAKE_CURRENT_SOURCE_DIR}/etc/c_gc_skel.h
    ${CMAKE_CURRENT_SOURCE_DIR}/etc/c_gc_skel.c
    ${CMAKE_CURRENT_SOURCE_DIR}/etc/cpp_gc_skel.h
    ${CMAKE_CURRENT_SOURCE_DIR}/etc/cpp_gc_skel.cc
)

set(SKELETON_SOURCE_FILE ${CMAKE_CURRENT_BINARY_DIR}/skels.c)
mkskel_generate_c(${SKELETON_SOURCE_FILE} ${SKELETON_FILES})
set_source_files_properties(${SKELETON_SOURCE_FILE} PROPERTIES GENERATED TRUE)

set(LIBTREECC_SOURCES
    context.c
    errors.c
    gen.c
    gen_c.c
    gen_cpp.c
    gen_cs.c
    gen_ruby.c
    gen_java.c
    gen_php.c
    gen_python.c
    input.c
    literal.c
    node.c
    oper.c
    options.c
    parse.c
    skeleton.c
    stream.c
    ${CMAKE_CURRENT_BINARY_DIR}/skels.c
)

set(LIBTREECC_HEADERS
    errors.h
    gen.h
    info.h
    input.h
    options.h
    parse.h
    stream.h
    system.h
)

add_library(treecc_static STATIC ${LIBTREECC_SOURCES} ${LIBTREECC_HEADERS})
set_target_properties(treecc_static PROPERTIES OUTPUT_NAME treecc)

add_executable(treecc main.c)
target_link_libraries(treecc treecc_static)

include(GNUInstallDirs)
install(TARGETS treecc DESTINATION ${CMAKE_INSTALL_BINDIR})
install(FILES ${LIBTREECC_HEADERS} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/treecc)
install(TARGETS treecc_static DESTINATION ${CMAKE_INSTALL_LIBDIR})

install(FILES ${SKELETON_FILES} DESTINATION ${CMAKE_INSTALL_DATADIR}/treecc/skels)

add_subdirectory(etc)
add_subdirectory(doc)
add_subdirectory(examples)

enable_testing()
add_subdirectory(tests)

set(CPACK_PACKAGE_NAME "treecc")
set(CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Tree Compiler-Compiler")
set(CPACK_PACKAGE_VENDOR "GNU")
set(CPACK_PACKAGE_CONTACT "dotgnu-pnet@gnu.org")

include(CPack)