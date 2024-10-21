#include <cmath>
#include <cstring> 

#include "oscillator.h"
#include "constants.h"
#include "log.h"

namespace DroneFactory {
    Oscillator::Oscillator(const std::vector<float>& wavetable, float frequency, float amplitude, float sampleRate)
        : m_sampleRate(sampleRate * OVERSAMPLING_FACTOR) {
            for (int i = 0; i < NUM_TRACKS; ++i) {
                m_tracks[i] = std::make_shared<AudioTrack>(m_sampleRate, wavetable);
                m_tracks[i]->setFrequency(frequency);
                m_tracks[i]->setAmplitude(amplitude);
            }

            for (int ch = 0; ch < CHANNEL_COUNT; ++ch) {
                m_prevSamples[ch].resize(FILTER_ORDER - 1, 0.0f);
            }

            LOGD("Wavetable size: %zu", wavetable.size());
        }

    void Oscillator::getSamples(float* outputBuffer, int numSamples) {
        int oversampledSamples = numSamples * OVERSAMPLING_FACTOR;
        std::vector<float> tempBuffer(oversampledSamples * CHANNEL_COUNT, 0.0f);
        // Copy input buffer into padded buffer starting at index filterOrder
        std::memset(outputBuffer, 0, sizeof(float) * numSamples * CHANNEL_COUNT);

        for (int trackId = 0; trackId < NUM_TRACKS; ++trackId) {
            generateTrackSamples(*m_tracks[trackId], tempBuffer.data(), oversampledSamples, trackId);
        }

        // Apply low-pass filter to the oversampled data
        applyLowPassFilter(tempBuffer.data(), oversampledSamples);

        // Downsample and write to outputBuffer
        for (int i = 0; i < numSamples; ++i) {
            int oversampledIndex = i * OVERSAMPLING_FACTOR * CHANNEL_COUNT;

            if (oversampledIndex + (CHANNEL_COUNT - 1) >= tempBuffer.size()) {
                LOGD("Oversampled index out of bounds: %d", oversampledIndex);
                continue; // Avoid out-of-bounds access
            }

            // Downsample by picking every Nth sample after filtering
            outputBuffer[i * CHANNEL_COUNT + 0] += tempBuffer[oversampledIndex + 0];
            outputBuffer[i * CHANNEL_COUNT + 1] += tempBuffer[oversampledIndex + 1];
        }

        // Clamp the output to [-1.0f, 1.0f]
        for (int i = 0; i < numSamples * CHANNEL_COUNT; ++i) {
            outputBuffer[i] = std::clamp(outputBuffer[i], -1.0f, 1.0f);
        }
    }

    void Oscillator::generateTrackSamples(AudioTrack &track, float *outputBuffer, int numSamples, int trackIndex) {
        if (track.isMuted()) {
            return;
        }

        for (int i = 0; i < numSamples; ++i) {
            float index = track.getIndex();
            index = std::fmod(index, static_cast<float>(track.getWavetable().size()));

            const auto& wavetable = track.getWavetable();
            const auto truncatedIndex = static_cast<int>(index);
            const auto nextIndex = (truncatedIndex + 1u) % wavetable.size();
            const auto nextIndexWeight = index - static_cast<float>(truncatedIndex);

            float sample = wavetable[truncatedIndex] * (1.f - nextIndexWeight) + wavetable[nextIndex] * nextIndexWeight;

            sample *= track.getAmplitude();

            track.setIndex(index + track.getIndexIncrement());

            outputBuffer[i * CHANNEL_COUNT + 0] += sample;
            outputBuffer[i * CHANNEL_COUNT + 1] += sample;
        }
    }

    void Oscillator::applyLowPassFilter(float *buffer, int numSamples) {
        static std::vector<double> filterCoeffs;
        static bool coeffsComputed = false;

        if (!coeffsComputed) {
            filterCoeffs.resize(FILTER_ORDER);
            computeFilterCoefficients(filterCoeffs);
            coeffsComputed = true;
        }

        std::vector<float> tempBuffer((numSamples + FILTER_ORDER - 1) * CHANNEL_COUNT, 0.0f);

        for (int ch = 0; ch < CHANNEL_COUNT; ++ch) {
            for (int i = 0; i < FILTER_ORDER - 1; ++i) {
                tempBuffer[i * CHANNEL_COUNT + ch] = m_prevSamples[ch][i];
            }
        }

        for (int i = 0; i < numSamples; ++i) {
            for (int ch = 0; ch < CHANNEL_COUNT; ++ch) {
                tempBuffer[(i + FILTER_ORDER - 1) * CHANNEL_COUNT + ch] = buffer[i * CHANNEL_COUNT + ch];
            }
        }

        for (int ch = 0; ch < CHANNEL_COUNT; ++ch) {
            for (int i = 0; i < numSamples; ++i) {
                double acc = 0.0;
                for (int j = 0; j < FILTER_ORDER; ++j) {
                    acc += tempBuffer[(i + j) * CHANNEL_COUNT + ch] * filterCoeffs[j];
                }
                buffer[i * CHANNEL_COUNT + ch] = static_cast<float>(acc);
            }
        }

        for (int ch = 0; ch < CHANNEL_COUNT; ++ch) {
            for (int i = 0; i < FILTER_ORDER - 1; ++i) {
                m_prevSamples[ch][i] = tempBuffer[(numSamples + i) * CHANNEL_COUNT + ch];
            }
        }
    }

    void Oscillator::computeFilterCoefficients(std::vector<double>& coeffs) {
        double sum = 0.0;
        double fc = 1.0 / OVERSAMPLING_FACTOR; // Normalized cutoff frequency

        const int filterOrder = FILTER_ORDER;
        const int halfOrder = (filterOrder - 1) / 2;

        for (int i = 0; i < filterOrder; ++i) {
            int m = i - halfOrder;
            double h;

            if (m == 0)
                h = 2 * fc;
            else
                h = sin(2 * M_PI * fc * m) / (M_PI * m);

            // Apply a Blackman-Harris window
            const double a0 = 0.35875;
            const double a1 = 0.48829;
            const double a2 = 0.14128;
            const double a3 = 0.01168;
            double w = a0
                - a1 * cos(2 * M_PI * i / (filterOrder - 1))
                + a2 * cos(4 * M_PI * i / (filterOrder - 1))
                - a3 * cos(6 * M_PI * i / (filterOrder - 1));

            coeffs[i] = h * w;
            sum += coeffs[i];
        }

        // Normalize filter coefficients
        for (int i = 0; i < filterOrder; ++i) {
            coeffs[i] /= sum;
        }
    }

    void Oscillator::onPlaybackStopped() {
        for (auto& track : m_tracks) {
            track->setIndex(0.f);
        }
    }

    void Oscillator::setFrequency(int trackId, float newFrequency) {
        m_tracks[trackId]->setFrequency(newFrequency);
    }

    void Oscillator::setAmplitude(int trackId, float newAmplitude) {
        m_tracks[trackId]->setAmplitude(newAmplitude);
    }

    void Oscillator::setWavetable(int trackId, const std::vector<float>& wavetable) {
        m_tracks[trackId]->setWavetable(wavetable);
    }

    void Oscillator::setIsMuted(int trackId, bool isMuted) {
        m_tracks[trackId]->setMuted(isMuted);
    }
}
