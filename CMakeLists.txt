cmake_minimum_required(VERSION 3.2.0)
project(luahpdf)
set(CMAKE_C_STANDARD 11)
set(CMAKE_INSTALL_PREFIX /usr/local)
file(STRINGS "${PROJECT_SOURCE_DIR}/libversion" SHARED_LIBRARY_VERSION)
file(STRINGS "${PROJECT_SOURCE_DIR}/VERSION" PACKAGE_VERSION)

# Read the version information from the VERSION file
file(STRINGS "${PROJECT_SOURCE_DIR}/VERSION" PACKAGE_VERSION)
message(STATUS "EF package version: ${PACKAGE_VERSION}")
string(REGEX REPLACE "([0-9]+)\\.[0-9]+\\.[0-9]+.*" "\\1" CPACK_PACKAGE_VERSION_MAJOR ${PACKAGE_VERSION})
string(REGEX REPLACE "[0-9]+\\.([0-9])+\\.[0-9]+.*" "\\1" CPACK_PACKAGE_VERSION_MINOR ${PACKAGE_VERSION})
string(REGEX REPLACE "[0-9]+\\.[0-9]+\\.([0-9]+).*" "\\1" CPACK_PACKAGE_VERSION_PATCH ${PACKAGE_VERSION})

set(COMPLETE_VERSION ${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH})
set(RELEASE_NAME "Unstable-trunk")
set(PROJECT_VERSION ${COMPLETE_VERSION})

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# Append our module directory to CMake
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

set(CMAKE_C_COMPILER "/usr/bin/clang")
set(CMAKE_CXX_COMPILER "/usr/bin/clang++")

include(CXX1x)
check_for_cxx11_compiler(CXX11_COMPILER)
# If a C++11 compiler is available, then set the appropriate flags
if(CXX11_COMPILER)
	enable_cxx11()
	check_for_cxx14_compiler(CXX14_COMPILER)
	# If a C++14 compiler is available, then set the appropriate flags
	if(CXX14_COMPILER)
		enable_cxx14()
	endif()
endif()
message(STATUS "CXX11_COMPILER = " ${CXX11_COMPILER})
message(STATUS "CXX14_COMPILER = " ${CXX14_COMPILER})
message(STATUS "CXX_COMPILER = " ${CMAKE_CXX_COMPILER_ID})

if(CMAKE_BUILD_TYPE STREQUAL "")
    set(CMAKE_BUILD_TYPE "RelWithDebInfo")
endif()

option(LUAHPDF_STATIC "Set to OFF|ON (default is OFF) " OFF)
if(LUAHPDF_STATIC)
	set(LIB_MODE STATIC)
	message(STATUS "Building static libraries")
else(LUAHPDF_STATIC)
	set(LIB_MODE SHARED)
	message(STATUS "Building dynamic libraries")
endif(LUAHPDF_STATIC)

include(DefinePlatformSpecifc)

#############################################################

set(LIBNAME "hpdf")

message(STATUS "LIBRARY NAME IS ${LIBNAME}")

if (APPLE)
	add_library( "${LIBNAME}" MODULE hpdf.c )
	set_target_properties( "${LIBNAME}"
		PROPERTIES
		OUTPUT_NAME ${LIBNAME}
		PREFIX "" # So that the output name is either hpdf.dylib of hpdf.so
		DEFINE_SYMBOL hpdf_EXPORTS
		LINK_FLAGS "-undefined dynamic_lookup"
		)
	#target_link_options(${LIBNAME}
	#	PRIVATE -undefined dynamic_lookup
	#)
else (APPLE)
	add_library( "${LIBNAME}" SHARED hpdf.c )
	set_target_properties( "${LIBNAME}"
		PROPERTIES
		VERSION ${SHARED_LIBRARY_VERSION} SOVERSION ${SHARED_LIBRARY_VERSION}
		OUTPUT_NAME ${LIBNAME}
		PREFIX "" # So that the output name is either hpdf.dylib of hpdf.so
		DEFINE_SYMBOL hpdf_EXPORTS
		)
endif(APPLE)


find_library(LIBHARU NAMES hpdf NO_CACHE REQUIRED ) # port install libharu in apple  or # apt-get install libhpdf-dev in ubuntu
find_library(LIBZ NAMES z NO_CACHE REQUIRED ) # port install zlib in apple # or apt-get install zlib1g-dev in ubuntu
find_library(LIBPNG NAMES png NO_CACHE REQUIRED ) # port install libpng in apple or # apt-get install libpng-dev in ubuntu
find_library(LIBM NAMES m NO_CACHE REQUIRED ) # This should be there with essential libraries of either apple or ubuntu 
											  # /Library/Developer/CommandLineTools/SDKs/MacOSX13.1.sdk/usr/lib/libm.tbd
											  # apt-get install build-essential on ubuntu

message(STATUS "FOUND LIBHARU ${LIBHARU}")
message(STATUS "FOUND LIBZ ${LIBZ}")
message(STATUS "FOUND LIBPNG ${LIBPNG}")
message(STATUS "FOUND LIBM ${LIBM}")

target_link_libraries( "${LIBNAME}" ${LIBHARU} ${LIBZ} ${LIBPNG} ${LIBM} )

target_include_directories( "${LIBNAME}"
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<BUILD_INTERFACE:${CMAKE_INSTALL_PREFIX}/include>
        $<INSTALL_INTERFACE:include>
    PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}
    )
target_compile_definitions("${LIBNAME}" PUBLIC ${LIB_MODE_DEFINITIONS})

install(
	TARGETS "${LIBNAME}" EXPORT "${LIBNAME}Targets"
	LIBRARY DESTINATION lib${LIB_SUFFIX}
    ARCHIVE DESTINATION lib${LIB_SUFFIX}
    RUNTIME DESTINATION bin
    INCLUDES DESTINATION include
    )

#############################################################

# Uninstall stuff see: http://www.vtk.org/Wiki/CMake_FAQ
configure_file(
	"${CMAKE_CURRENT_SOURCE_DIR}/cmake/cmake_uninstall.cmake.in"
	"${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
	IMMEDIATE @ONLY)

add_custom_target(uninstall
  "${CMAKE_COMMAND}" -P "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake")


#############################################################
# Enable packaging

include(InstallRequiredSystemLibraries)

set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "luahpdf library")
set(CPACK_PACKAGE_VENDOR "Tekelinght Solutions Pvt Ltd")
set(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/README.md")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")

include(CPack)

#############################################################









