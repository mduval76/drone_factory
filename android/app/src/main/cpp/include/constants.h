#pragma once
#include <cmath>

namespace DroneFactory {
    static const auto PI = std::atan(1.f) * 4;
    static const auto NUM_TRACKS = 8;
    static const auto BUFFER_SIZE = 1024;
    static const auto CHANNEL_COUNT = 2;
    static const auto FILTER_ORDER = 31;
    static const auto OVERSAMPLING_FACTOR = 4;
    static const auto WAVETABLE_LENGTH = 1024;
}