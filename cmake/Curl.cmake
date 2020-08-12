message("* curl")
set(CURL_SOURCE_DIR "${CMAKE_CURRENT_LIST_DIR}/../lib/curl-7.57.0")

set(CURL_FLAGS -DBUILD_CURL_EXE=OFF -DBUILD_TESTING=OFF -DCURL_STATICLIB=ON -DBUILD_SHARED_LIBS=OFF -DCURL_DISABLE_LDAP=ON)
if (${linux})
  set(CURL_INSTALL_DIR "${CURL_SOURCE_DIR}/INSTALL")
  set(CURL_LIB "${CURL_INSTALL_DIR}/lib/libcurl.a")
else()
  set(CURL_INSTALL_DIR "${CURL_SOURCE_DIR}/builds/libcurl-${ARCH_STRING}-release-static")
  set(CURL_LIB "${CURL_INSTALL_DIR}/lib/libcurl.lib")
  set(CURL_FLAGS ${CURL_FLAGS} -DCMAKE_USE_WINSSL=ON -DCURL_STATIC_CRT=1 -DCMAKE_USER_MAKE_RULES_OVERRIDE=${CMAKE_CURRENT_LIST_DIR}/c_flag_overrides.cmake)
endif()

if(NOT EXISTS "${CURL_LIB}")
  ExternalProject_Add(libcurl
    URL "${CURL_SOURCE_DIR}/../curl-7.57.0.zip"
    SOURCE_DIR  "${CURL_SOURCE_DIR}"
    PREFIX curl
    CMAKE_ARGS -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${CURL_INSTALL_DIR} ${CURL_FLAGS} -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config Release
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config Release --target install
    BUILD_IN_SOURCE 1
    BUILD_BYPRODUCTS ${CURL_LIB}
    LOG_DOWNLOAD 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_INSTALL 1
    LOG_OUTPUT_ON_FAILURE 1
  )
  set_target_properties (libcurl PROPERTIES FOLDER 3rdParty)
else()
  message("Curl already build")
endif()
