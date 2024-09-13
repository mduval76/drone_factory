#pragma once

#include <vector>

namespace DroneFactory {
    enum class Wavetable;
    
    class WavetableFactory {
    public:
        std::vector<float> getWavetable(Wavetable wavetable);

    private:
        std::vector<float> sineWavetable();
        std::vector<float> triangleWavetable();
        std::vector<float> squareWavetable();
        std::vector<float> sawtoothWavetable();

        std::vector<float> m_sineWavetable;
        std::vector<float> m_triangleWavetable;
        std::vector<float> m_squareWavetable;
        std::vector<float> m_sawtoothWavetable;
    };
}