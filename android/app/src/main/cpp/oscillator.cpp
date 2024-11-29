#include <cmath>
#include <cstring>

#include "oscillator.h"

namespace DroneFactory {
    Oscillator::Oscillator(const std::vector<float>& wavetable, float frequency, float amplitude, float sampleRate)
        : m_sampleRate(sampleRate * OVERSAMPLING_FACTOR),
          m_lowPassFilter(FILTER_ORDER, 1.0 / OVERSAMPLING_FACTOR, OVERSAMPLING_FACTOR, CHANNEL_COUNT),
          m_visualizationBuffer(BUFFER_SIZE)
    {
        for (int i = 0; i < NUM_TRACKS; ++i) {
            m_tracks[i] = std::make_shared<AudioTrack>(m_sampleRate, wavetable);
            m_tracks[i]->setFrequency(frequency);
            m_tracks[i]->setAmplitude(amplitude);
        }
    }
    
    // Get the samples for the oscillator with oversampling
    void Oscillator::getSamples(float* outputBuffer, int numSamples) {
        // Oversample the outputBuffer
        int oversampledSamples = numSamples * OVERSAMPLING_FACTOR;
        std::vector<float> tempBuffer(oversampledSamples * CHANNEL_COUNT, 0.0f);

        // Clear the output buffer
        std::memset(outputBuffer, 0, sizeof(float) * numSamples * CHANNEL_COUNT);
        
        // Generate samples for each track
        for (int trackId = 0; trackId < NUM_TRACKS; ++trackId) {
            generateTrackSamples(*m_tracks[trackId], tempBuffer.data(), oversampledSamples, trackId);
        }

        // Apply low pass filter
        m_lowPassFilter.process(tempBuffer.data(), oversampledSamples);

        float maxAmplitude = 0.0f;

        // Downsample the outputBuffer
        for (int i = 0; i < numSamples; ++i) {
            int oversampledIndex = i * OVERSAMPLING_FACTOR * CHANNEL_COUNT;

            // Check if oversampled index is out of bounds
            if (oversampledIndex + (CHANNEL_COUNT - 1) >= tempBuffer.size()) {
                continue;
            }

            // Average samples
            float sampleL = tempBuffer[oversampledIndex + 0];
            float sampleR = tempBuffer[oversampledIndex + 1];

            maxAmplitude = std::max(maxAmplitude, std::max(std::abs(sampleL), std::abs(sampleR)));

            // Add samples to output buffer
            outputBuffer[i * CHANNEL_COUNT + 0] += sampleL;
            outputBuffer[i * CHANNEL_COUNT + 1] += sampleR;
        }

        // Apply limiter on output buffer
        const float limiterThreshold = 0.9f;
        if (maxAmplitude > limiterThreshold) {
            float scaleFactor = limiterThreshold / maxAmplitude;
            for (int i = 0; i < numSamples * CHANNEL_COUNT; ++i) {
                outputBuffer[i] *= scaleFactor;
            }
        }

        {
            // Update visualization buffer
            std::lock_guard<std::mutex> lock(m_visualizationBufferMutex);
            m_visualizationBuffer.insert(
                m_visualizationBuffer.end(), 
                outputBuffer,
                outputBuffer + numSamples * CHANNEL_COUNT
            );

            if (m_visualizationBuffer.size() > BUFFER_SIZE) {
                m_visualizationBuffer.erase(m_visualizationBuffer.begin(),
                m_visualizationBuffer.begin() + (m_visualizationBuffer.size() - BUFFER_SIZE));
            }
        }
    }

    // Generate samples for single track
    void Oscillator::generateTrackSamples(AudioTrack &track, float *outputBuffer, int numSamples, int trackIndex) {
        if (track.isMuted()) {
            return;
        }

        // Sample generation
        for (int i = 0; i < numSamples; ++i) {
            float index = track.getIndex();

            // Wrap index
            index = std::fmod(index, static_cast<float>(track.getWavetable().size()));
            const auto& wavetable = track.getWavetable();
            const auto truncatedIndex = static_cast<int>(index);
            const auto nextIndex = (truncatedIndex + 1u) % wavetable.size();
            const auto nextIndexWeight = index - static_cast<float>(truncatedIndex);

            // Linear interpolation
            float sample = wavetable[truncatedIndex] * (1.f - nextIndexWeight) + wavetable[nextIndex] * nextIndexWeight;

            // Apply amplitude
            sample *= track.getAmplitude();

            // Increment index
            track.setIndex(index + track.getIndexIncrement());

            // Add sample to output buffer
            outputBuffer[i * CHANNEL_COUNT + 0] += sample;
            outputBuffer[i * CHANNEL_COUNT + 1] += sample;
        }
    }

    void Oscillator::onPlaybackStopped() {
        for (auto& track : m_tracks) {
            track->setIndex(0.f);
        }
    }

    std::vector<float> Oscillator::getVisualizationSamples() {
        std::lock_guard<std::mutex> lock(m_visualizationBufferMutex);
        return m_visualizationBuffer;
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

    void Oscillator::setIsSoloed(int trackId, bool isSoloed) {
        auto& track = m_tracks[trackId];
        track->setSoloed(isSoloed);

        if (isSoloed) {
            track->setMuted(false);
            for (int i = 0; i < NUM_TRACKS; ++i) {
                if (i != trackId) {
                    m_tracks[i]->setMuted(true);
                    m_tracks[i]->setSoloed(false);
                }
            }
        } 
        else {
            bool anyOtherSoloed = false;
            for (int i = 0; i < NUM_TRACKS; ++i) {
                if (m_tracks[i]->isSoloed()) {
                    anyOtherSoloed = true;
                    break;
                }
            }
            
            if (!anyOtherSoloed) {
                track->setMuted(true);
            }
        }
    }
}