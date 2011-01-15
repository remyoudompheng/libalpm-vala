include_directories(${GTK_INCLUDE_DIRS} ${CMAKE_SOURCE_DIR}/util)

vala_add_library(gtk_alpm STATIC
  PkgListView.vala
  PACKAGES alpm alpm-list gtk+-2.0
  VAPI_DIRS ${CMAKE_SOURCE_DIR}/bindings
  GENERATE_VAPI gtk_alpm.vapi
  GENERATE_HEADER gtk_alpm.h)

