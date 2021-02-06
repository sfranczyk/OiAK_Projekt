cmake_minimum_required(VERSION 3.15.3)
project(Factorization)

set(CMAKE_CXX_STANDARD 14)
enable_language(C ASM)

SET(GCC_COVERAGE_COMPILE_FLAGS "-no-pie ")
SET(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} ${GCC_COVERAGE_COMPILE_FLAGS}")

set ( SOURCES
        asmFun/fullChar.s
        asmFun/fullCharToString.s
        asmFun/absFullChars.s
        asmFun/addFullChars.s
        asmFun/divFullChars.s
        asmFun/mulFullChar.s
        asmFun/removezeros.s
        asmFun/andFullChar.s
        main.cpp
        )

add_executable(program  ${SOURCES} )