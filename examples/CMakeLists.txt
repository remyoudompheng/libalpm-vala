include_directories(${CMAKE_SOURCE_DIR}/util)
link_directories(${CMAKE_BINARY_DIR}/util)

vala_add_executable(pactree pactree.vala
                    PACKAGES alpm
                    VAPI_DIRS ${CMAKE_SOURCE_DIR}/bindings)
target_link_libraries(pactree alpm_util alpm ${GLIB_LIBRARIES})

vala_add_executable(test test.vala
                    PACKAGES alpm
                    VAPI_DIRS ${CMAKE_SOURCE_DIR}/bindings)
target_link_libraries(test alpm_util alpm ${GLIB_LIBRARIES})
