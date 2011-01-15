include_directories(${CMAKE_SOURCE_DIR}/util ${CMAKE_BINARY_DIR}/widgets
    ${GTK_INCLUDE_DIRS})

vala_add_executable(query query.vala
    PACKAGES alpm alpm-list gtk_alpm gtk+-2.0
    VAPI_DIRS ${CMAKE_SOURCE_DIR}/bindings ${CMAKE_BINARY_DIR}/widgets)

target_link_libraries(query gtk_alpm alpm_util alpm ${GTK_LIBRARIES})
