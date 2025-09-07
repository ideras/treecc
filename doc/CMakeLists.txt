# doc/CMakeLists.txt - Documentation for treecc

install(FILES treecc.1 
        DESTINATION ${CMAKE_INSTALL_MANDIR}/man1)

find_program(MAKEINFO_EXECUTABLE makeinfo)

if(MAKEINFO_EXECUTABLE)
    add_custom_command(
        OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/treecc.info
        COMMAND ${MAKEINFO_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/treecc.texi
        DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/treecc.texi
        COMMENT "Generating Info documentation"
    )
    add_custom_target(info ALL DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/treecc.info)
    install(FILES ${CMAKE_CURRENT_BINARY_DIR}/treecc.info
            DESTINATION ${CMAKE_INSTALL_INFODIR})
endif()

set(EXTRA_DOCS
    extending.txt
    essay.html
    binary_readme.txt
    texinfo.tex
)

install(FILES ${EXTRA_DOCS}
        DESTINATION ${CMAKE_INSTALL_DOCDIR})

install(FILES treecc.texi
        DESTINATION ${CMAKE_INSTALL_DOCDIR})