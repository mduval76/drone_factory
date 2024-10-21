#include <cmath>
#include <vector>

#include "wavetable_factory.h"
#include "wavetable.h"
#include "constants.h"

namespace DroneFactory {
    namespace {
        constexpr auto WAVETABLE_LENGTH = 1024;

        std::vector<float> generateSineWavetable() {
            auto sineWavetable = std::vector<float>(WAVETABLE_LENGTH);

            for (auto i = 0; i < WAVETABLE_LENGTH; ++i) {
                sineWavetable[i] = std::sin(2 * PI * static_cast<float>(i) / WAVETABLE_LENGTH);
            }
            return sineWavetable;
        }

        std::vector<float> generateTriangleWavetable() {
            auto triangleWavetable = std::vector<float>(WAVETABLE_LENGTH, 0.f);
            constexpr auto HARMONICS_COUNT = 13;

            for (auto k = 1; k <= HARMONICS_COUNT; ++k) {
                for (auto j = 0; j < WAVETABLE_LENGTH; ++j) {
                    const auto phase = 2.f * PI * 1.f * j / WAVETABLE_LENGTH;
                    triangleWavetable[j] += 8.f / std::pow(PI, 2.f) 
                                        * std::pow(-1.f, k) 
                                        * std::pow(2 * k - 1, -2.f) 
                                        * std::sin((2.f * k - 1.f) 
                                        * phase);
                }
            }
            return triangleWavetable;
        }

        std::vector<float> generateSquareWavetable() {
            auto squareWavetable = std::vector<float>(WAVETABLE_LENGTH, 0.f);
            constexpr auto HARMONICS_COUNT = 7;

            for (auto k = 1; k <= HARMONICS_COUNT; ++k) {
                for (auto j = 0; j < WAVETABLE_LENGTH; ++j) {
                    const auto phase = 2.f * PI * 1.f * j / WAVETABLE_LENGTH;
                    squareWavetable[j] += 4.f / PI 
                                    * std::pow(2.f * k - 1.f, -1.f) 
                                    * std::sin((2.f * k - 1.f) 
                                    * phase);
                }
            }
            return squareWavetable;
        }

        std::vector<float> generateSawWavetable() {
            auto sawtoothWavetable = std::vector<float>(WAVETABLE_LENGTH, 0.f);
            constexpr auto HARMONICS_COUNT = 26;

            for (auto k = 1; k <= HARMONICS_COUNT; ++k) {
                for (auto j = 0; j < WAVETABLE_LENGTH; ++j) {
                    const auto phase = 2.f * PI * 1.f * j / WAVETABLE_LENGTH;
                    sawtoothWavetable[j] += 2.f / PI 
                                        * std::pow(-1.f, k) 
                                        * std::pow(k, -1.f) 
                                        * std::sin(k * phase);
                }
            }
            return sawtoothWavetable;
        }

        // Lazy initialization of wavetables
        template <typename F>
        std::vector<float> generateWavetableOnce(std::vector<float>& waveTable, F&& generator, std::mutex& mutex) {
            std::lock_guard<std::mutex> lock(mutex);
            if (waveTable.empty()) {
                waveTable = generator();
            }
            return waveTable;
        }   
    }

    std::vector<float> WavetableFactory::getWavetable(const Wavetable& wavetable) {
        switch (wavetable) {
            case Wavetable::SINE:
                return sineWavetable();
            case Wavetable::TRIANGLE:
                return triangleWavetable();
            case Wavetable::SQUARE:
                return squareWavetable();
            case Wavetable::SAWTOOTH:
                return sawtoothWavetable();
            case Wavetable::NONE:
                return std::vector<float>(WAVETABLE_LENGTH, 0.f);
            default:
                return std::vector<float>(WAVETABLE_LENGTH, 0.f);
        }
    }

    std::vector<float> WavetableFactory::sineWavetable() {
        return generateWavetableOnce(m_sineWavetable, &generateSineWavetable, m_mutex);
    }

    std::vector<float> WavetableFactory::triangleWavetable() {
        return generateWavetableOnce(m_triangleWavetable, &generateTriangleWavetable, m_mutex);
    }

    std::vector<float> WavetableFactory::squareWavetable() {
        return generateWavetableOnce(m_squareWavetable, &generateSquareWavetable, m_mutex);
    }

    std::vector<float> WavetableFactory::sawtoothWavetable() {
        return generateWavetableOnce(m_sawtoothWavetable, &generateSawWavetable, m_mutex);
    }
} 