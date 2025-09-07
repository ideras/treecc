# examples/CMakeLists.txt - Example programs for treecc

find_program(YACC_EXECUTABLE NAMES bison yacc)
find_program(LEX_EXECUTABLE NAMES flex lex)

if(YACC_EXECUTABLE AND LEX_EXECUTABLE)
    
    add_custom_command(
        OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/gram_c.c ${CMAKE_CURRENT_BINARY_DIR}/gram_c.h
        COMMAND ${YACC_EXECUTABLE} -d -o ${CMAKE_CURRENT_BINARY_DIR}/gram_c.c ${CMAKE_CURRENT_SOURCE_DIR}/gram_c.y
        DEPENDS gram_c.y
        COMMENT "Generating C parser"
    )
    
    add_custom_command(
        OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/scan_c.c
        COMMAND ${LEX_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/scan_c.l
        COMMAND ${CMAKE_COMMAND} -E copy lex.yy.c ${CMAKE_CURRENT_BINARY_DIR}/scan_c.c
        DEPENDS scan_c.l
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Generating C lexer"
    )
    
    add_custom_command(
        OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/expr_c.c ${CMAKE_CURRENT_BINARY_DIR}/expr_c.h
        COMMAND $<TARGET_FILE:treecc> -o ${CMAKE_CURRENT_BINARY_DIR}/expr_c.c -h ${CMAKE_CURRENT_BINARY_DIR}/expr_c.h ${CMAKE_CURRENT_SOURCE_DIR}/expr_c.tc
        DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/expr_c.tc treecc
        COMMENT "Generating C AST files from expr_c.tc"
    )
    
    add_executable(expr_c
        ${CMAKE_CURRENT_BINARY_DIR}/gram_c.c
        ${CMAKE_CURRENT_BINARY_DIR}/scan_c.c
        ${CMAKE_CURRENT_BINARY_DIR}/expr_c.c
        ${CMAKE_CURRENT_BINARY_DIR}/expr_c.h
    )
    
    target_include_directories(expr_c PRIVATE ${CMAKE_CURRENT_BINARY_DIR})
    
    find_library(MATH_LIBRARY m)
    if(MATH_LIBRARY)
        target_link_libraries(expr_c ${MATH_LIBRARY})
    endif()
    
    option(BUILD_CPP_EXAMPLE "Build C++ example" OFF)
    if(BUILD_CPP_EXAMPLE)
        add_custom_command(
            OUTPUT gram_cpp.cc gram_cpp.h
            COMMAND ${YACC_EXECUTABLE} -d -o gram_cpp.cc ${CMAKE_CURRENT_SOURCE_DIR}/gram_cpp.yy
            DEPENDS gram_cpp.yy
            COMMENT "Generating C++ parser"
        )
        
        add_custom_command(
            OUTPUT scan_cpp.cc
            COMMAND ${LEX_EXECUTABLE} -o scan_cpp.cc ${CMAKE_CURRENT_SOURCE_DIR}/scan_cpp.ll
            DEPENDS scan_cpp.ll
            COMMENT "Generating C++ lexer"
        )
        
        add_custom_command(
            OUTPUT expr_cpp.cc expr_cpp.h
            COMMAND $<TARGET_FILE:treecc> -o expr_cpp.cc -h expr_cpp.h ${CMAKE_CURRENT_SOURCE_DIR}/expr_cpp.tc
            DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/expr_cpp.tc treecc
            COMMENT "Generating C++ AST files from expr_cpp.tc"
        )
        
        add_executable(expr_cpp
            gram_cpp.cc
            scan_cpp.cc
            expr_cpp.cc
            expr_cpp.h
        )
        
        target_include_directories(expr_cpp PRIVATE ${CMAKE_CURRENT_BINARY_DIR})
        set_target_properties(expr_cpp PROPERTIES LINKER_LANGUAGE CXX)
    endif()
    
else()
    message(STATUS "Yacc and/or Lex not found - skipping examples")
endif()

install(FILES 
    expr_c.tc expr_cpp.tc expr_java.tc expr_cs.tc expr_ruby.tc expr_python.tc
    gram_c.y gram_cpp.yy scan_c.l scan_cpp.ll
    eval_value.java mkjava mkcsharp README
    DESTINATION ${CMAKE_INSTALL_DOCDIR}/examples)