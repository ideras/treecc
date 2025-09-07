# run_single_test.cmake - CMake function to run a single test for "treecc"
#
# Required variables:
# - TYPE: one of ("input", "parse", "output")
# - TEST_NAME: the name of the test to run
# - For "input" type: TEST_INPUT
# - For "parse" type: TEST_PARSE
# - For "output" type: TEST_OUTPUT
# - NORMALIZE: path to normalization program
#
# exit status: (0=pass, 1=fail)

cmake_minimum_required(VERSION 3.12)

# Input validation
if(NOT DEFINED TYPE OR NOT DEFINED TEST_NAME)
    message(FATAL_ERROR "TYPE and TEST_NAME must be defined when running as script")
endif()

if(NOT DEFINED NORMALIZE)
    message(FATAL_ERROR "NORMALIZE must be defined.")
endif()

set(VALID_TYPES "input" "parse" "output")

if(NOT TYPE IN_LIST VALID_TYPES)
    message(FATAL_ERROR "Invalid test type: ${TYPE}. Valid types: ${VALID_TYPES}")
endif()

if(TYPE STREQUAL "input" AND NOT DEFINED TEST_INPUT)
    message(FATAL_ERROR "TEST_INPUT must be defined for input tests.")
elseif(TYPE STREQUAL "parse" AND NOT DEFINED TEST_PARSE)
    message(FATAL_ERROR "TEST_PARSE must be defined for parse tests.")
elseif(TYPE STREQUAL "output" AND NOT DEFINED TEST_OUTPUT)
    message(FATAL_ERROR "TEST_OUTPUT must be defined for output tests.")
endif()

if(TYPE STREQUAL "input")
    set(TEST_PROGRAM "${TEST_INPUT}")
elseif(TYPE STREQUAL "parse")
    set(TEST_PROGRAM "${TEST_PARSE}")
else()
    set(TEST_PROGRAM "${TEST_OUTPUT}")
endif()

set(TMP_PREFIX "${CMAKE_BINARY_DIR}/test_${TYPE}_${TEST_NAME}")
set(TMP_ACTUAL "${TMP_PREFIX}_actual.txt")
set(TMP_EXPECTED "${TMP_PREFIX}_expected.txt")
set(TMP_DIFF "${TMP_PREFIX}_diff.txt")

execute_process(
    COMMAND ${TEST_PROGRAM} "${TEST_NAME}.tst"
    COMMAND ${NORMALIZE}
    OUTPUT_FILE "${TMP_ACTUAL}"
    RESULT_VARIABLE test_result
    ERROR_QUIET
    COMMAND_ECHO STDOUT
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
)

set(test_status 1)
set(test_passed FALSE)

if(test_result EQUAL 0)
    set(EXPECTED_FILE "${TEST_NAME}.out")

    if(EXISTS "${EXPECTED_FILE}")
        execute_process(
            COMMAND ${CMAKE_COMMAND} -E cat "${EXPECTED_FILE}"
            COMMAND ${NORMALIZE}
            OUTPUT_FILE "${TMP_EXPECTED}"
            RESULT_VARIABLE normalize_result
            ERROR_QUIET
            WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
        )

        if(normalize_result EQUAL 0)
            file(READ "${TMP_ACTUAL}" actual_content)
            file(READ "${TMP_EXPECTED}" expected_content)

            execute_process(
                COMMAND ${CMAKE_COMMAND} -E compare_files "${TMP_ACTUAL}" "${TMP_EXPECTED}"
                RESULT_VARIABLE diff_result
                OUTPUT_FILE "${TMP_DIFF}"
                ERROR_FILE "${TMP_DIFF}"
            )

            if(diff_result EQUAL 0)
                message(STATUS "ok")
                set(test_status 0)
                set(test_passed TRUE)
            else()
                message(STATUS "failed")
                set(test_status 1)
                set(test_passed FALSE)

                file(READ "${TMP_DIFF}" diff_content)
                message(STATUS "${diff_content}")
            endif()
        else()
            message(STATUS "failed - could not normalize expected output (${normalize_result})")
        endif()
    else()
        message(STATUS "failed - expected output file ${EXPECTED_FILE} not found")
    endif()
else()
    message(STATUS "failed - test program returned ${test_result}")
endif()

foreach(tmp_file IN ITEMS "${TMP_ACTUAL}" "${TMP_EXPECTED}" "${TMP_DIFF}")
    if(EXISTS "${tmp_file}")
        file(REMOVE "${tmp_file}")
    endif()
endforeach()

if(NOT test_passed)
    message(FATAL_ERROR "Test ${TYPE} ${TEST_NAME} failed with status ${test_status}")
endif()
