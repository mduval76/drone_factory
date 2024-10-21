#include <cmath>
#include <cstring>

#include "low_pass_filter.h"
#include "constants.h"

namespace DroneFactory {

    LowPassFilter::LowPassFilter(int filterOrder, double cutoffFrequency, int oversamplingFactor, int channelCount)
        : m_filterOrder(filterOrder),
          m_cutoffFrequency(cutoffFrequency),
          m_oversamplingFactor(oversamplingFactor),
          m_channelCount(channelCount) {

        computeFilterCoefficients();

        // Initialize previous samples for each channel
        for (int ch = 0; ch < m_channelCount; ++ch) {
            m_prevSamples[ch].resize(m_filterOrder - 1, 0.0f);
        }
    }

    void LowPassFilter::computeFilterCoefficients() {
        m_filterCoeffs.resize(m_filterOrder);
        double sum = 0.0;
        int halfOrder = (m_filterOrder - 1) / 2;
        double fc = m_cutoffFrequency;

        for (int i = 0; i < m_filterOrder; ++i) {
            int m = i - halfOrder;
            double h;

            if (m == 0)
                h = 2 * fc;
            else
                h = sin(2 * PI * fc * m) / (PI * m);

            // Apply a Blackman-Harris window
            const double a0 = 0.35875;
            const double a1 = 0.48829;
            const double a2 = 0.14128;
            const double a3 = 0.01168;
            double w = a0
                - a1 * cos(2 * PI * i / (m_filterOrder - 1))
                + a2 * cos(4 * PI * i / (m_filterOrder - 1))
                - a3 * cos(6 * PI * i / (m_filterOrder - 1));

            m_filterCoeffs[i] = h * w;
            sum += m_filterCoeffs[i];
        }

        // Normalize filter coefficients
        for (int i = 0; i < m_filterOrder; ++i) {
            m_filterCoeffs[i] /= sum;
        }
    }

    void LowPassFilter::process(float* buffer, int numSamples) {
        int totalSamples = numSamples + m_filterOrder - 1;
        std::vector<float> tempBuffer(totalSamples * m_channelCount, 0.0f);

        // Copy previous samples into tempBuffer for each channel
        for (int ch = 0; ch < m_channelCount; ++ch) {
            for (int i = 0; i < m_filterOrder - 1; ++i) {
                tempBuffer[i * m_channelCount + ch] = m_prevSamples[ch][i];
            }
        }

        // Copy current buffer into tempBuffer starting at position m_filterOrder - 1
        for (int i = 0; i < numSamples; ++i) {
            for (int ch = 0; ch < m_channelCount; ++ch) {
                tempBuffer[(i + m_filterOrder - 1) * m_channelCount + ch] = buffer[i * m_channelCount + ch];
            }
        }

        // Perform convolution
        for (int ch = 0; ch < m_channelCount; ++ch) {
            for (int i = 0; i < numSamples; ++i) {
                double acc = 0.0;
                for (int j = 0; j < m_filterOrder; ++j) {
                    acc += tempBuffer[(i + j) * m_channelCount + ch] * m_filterCoeffs[j];
                }
                buffer[i * m_channelCount + ch] = static_cast<float>(acc);
            }
        }

        // Save last m_filterOrder - 1 samples for next buffer
        for (int ch = 0; ch < m_channelCount; ++ch) {
            for (int i = 0; i < m_filterOrder - 1; ++i) {
                m_prevSamples[ch][i] = tempBuffer[(numSamples + i) * m_channelCount + ch];
            }
        }
    }

    void LowPassFilter::reset() {
        // Reset previous samples
        for (int ch = 0; ch < m_channelCount; ++ch) {
            std::fill(m_prevSamples[ch].begin(), m_prevSamples[ch].end(), 0.0f);
        }
    }

}