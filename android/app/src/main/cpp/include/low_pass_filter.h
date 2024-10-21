#pragma once

#include <atomic>
#include <vector>

namespace DroneFactory {
    class LowPassFilter {
    public:
        LowPassFilter(int filterOrder, double cutoffFrequency, int oversamplingFactor, int channelCount);

        void process(float* buffer, int numSamples);

        void reset();

    private:
        void computeFilterCoefficients();

        const int m_filterOrder;
        const double m_cutoffFrequency;
        const int m_oversamplingFactor;
        const int m_channelCount;

        std::vector<double> m_filterCoeffs;
        std::vector<std::vector<float>> m_prevSamples;

        std::atomic<bool> m_shouldReset{false};
    };
}


