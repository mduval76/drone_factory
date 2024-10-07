#include <cmath>
#include <cstring> 

#include "oscillator.h"
#include "constants.h"
#include "log.h"

namespace DroneFactory {
    Oscillator::Oscillator(const std::vector<float>& wavetable, float frequency, float amplitude, float sampleRate)
        : m_sampleRate(sampleRate) {
            for (int i = 0; i < NUM_TRACKS; ++i) {
                m_tracks[i] = std::make_shared<AudioTrack>(sampleRate, wavetable);
                m_tracks[i]->setFrequency(frequency);
                m_tracks[i]->setAmplitude(amplitude);
            }
        }

    void Oscillator::getSamples(float* outputBuffer, int numSamples) {
        std::memset(outputBuffer, 0, sizeof(float) * numSamples * CHANNEL_COUNT);
        std::vector<float> tempBuffer(numSamples * CHANNEL_COUNT, 0.0f);

        for (int trackId = 0; trackId < NUM_TRACKS; ++trackId) {
            generateTrackSamples(*m_tracks[trackId], tempBuffer.data(), numSamples, trackId);
            for (int frame = 0; frame < numSamples; ++frame) {
                outputBuffer[frame * CHANNEL_COUNT + 0] += tempBuffer[frame * CHANNEL_COUNT + 0];
                outputBuffer[frame * CHANNEL_COUNT + 1] += tempBuffer[frame * CHANNEL_COUNT + 1];
            }
        }

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

            outputBuffer[i * CHANNEL_COUNT + 0] = sample;
            outputBuffer[i * CHANNEL_COUNT + 1] = sample;
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
