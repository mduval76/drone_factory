#pragma once

#include <vector>
#include <array>
#include <memory>

#include "audio_source.h"
#include "audio_track.h"

namespace DroneFactory {
    class Oscillator : public AudioSource {
    public:
        static constexpr int NUM_TRACKS = 8;
        static constexpr int CHANNEL_COUNT = 2;
        
        Oscillator() = default;
        Oscillator(const std::vector<float>& wavetable, float frequency, float amplitude, float sampleRate);

        void getSamples(float* outputBuffer, int numSamples) override;
        void onPlaybackStopped() override;

        void setFrequency(int trackId, float newFrequency);
        void setAmplitude(int trackId, float newAmplitude);
        void setWavetable(int trackId, const std::vector<float>& wavetable);

    private:
        void generateTrackSamples(AudioTrack& track, float* outputBuffer, int numSamples, int trackIndex);

        std::array<std::shared_ptr<AudioTrack>, NUM_TRACKS> m_tracks;
        
        float m_sampleRate;
    };
}