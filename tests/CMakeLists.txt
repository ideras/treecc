# tests/CMakeLists.txt - Test suite for treecc

include_directories(${CMAKE_SOURCE_DIR})

add_executable(test_input test_input.c)
target_link_libraries(test_input treecc_static)

add_executable(test_parse test_parse.c)
target_link_libraries(test_parse treecc_static)

add_executable(test_output test_output.c)
target_link_libraries(test_output treecc_static)

add_executable(normalize normalize.c)

set(INPUT_TESTS
    input1 input2 input3 input4 input5
    input6 input7 input8 input9 input10
)

set(PARSE_TESTS
    parse1 parse2 parse3 parse4 parse5
    parse6 parse7 parse8 parse9 parse10
)

set(OUTPUT_TESTS
    output1 output2 output3 output4 output5 output6 output7 output8 output9 output10
    output11 output12 output13 output14 output15 output16 output17 output18
)

foreach(test ${INPUT_TESTS})
    add_test(
        NAME ${test}
        COMMAND ${CMAKE_COMMAND}
            -DTEST_INPUT=$<TARGET_FILE:test_input>
            -DTEST_NAME=${test}
            -DNORMALIZE=$<TARGET_FILE:normalize>
            -DTYPE=input
            -P ${CMAKE_SOURCE_DIR}/cmake/run_single_test.cmake
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    )
endforeach()

foreach(test ${PARSE_TESTS})
    add_test(
        NAME ${test}
        COMMAND ${CMAKE_COMMAND}
            -DTEST_PARSE=$<TARGET_FILE:test_parse>
            -DTEST_NAME=${test}
            -DNORMALIZE=$<TARGET_FILE:normalize>
            -DTYPE=parse
            -P ${CMAKE_SOURCE_DIR}/cmake/run_single_test.cmake
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    )
endforeach()

foreach(test ${OUTPUT_TESTS})
    add_test(
        NAME ${test}
        COMMAND ${CMAKE_COMMAND}
            -DTEST_OUTPUT=$<TARGET_FILE:test_output>
            -DTEST_NAME=${test}
            -DNORMALIZE=$<TARGET_FILE:normalize>
            -DTYPE=output
            -P ${CMAKE_SOURCE_DIR}/cmake/run_single_test.cmake
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    )
endforeach()

add_test(
    NAME all_tests
    COMMAND ${CMAKE_COMMAND} -E env
        srcdir=${CMAKE_CURRENT_SOURCE_DIR}
        ${CMAKE_CURRENT_SOURCE_DIR}/run_tests
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)