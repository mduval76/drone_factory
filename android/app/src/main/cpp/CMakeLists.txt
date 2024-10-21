cmake_minimum_required(VERSION 3.22.1)

project("Drone Factory")

add_library(
    drone_factory
    SHARED 
    drone_factory.cpp
    audio_track.cpp
    synthesizer.cpp
    oscillator.cpp
    wavetable_factory.cpp
    oboe_audio_player.cpp
    low_pass_filter.cpp
)

include_directories(
    include
)

find_library( 
    log-lib
    log
)

find_package (oboe REQUIRED CONFIG)

target_link_libraries(
    drone_factory 
    ${log-lib} 
    oboe::oboe
)