#pragma once

#include <vector>
#include <array>
#include <memory>

#include "audio_source.h"
#include "audio_track.h"
#include "low_pass_filter.h"

namespace DroneFactory {
    class Oscillator : public AudioSource {
    public:
        static constexpr int NUM_TRACKS = 8;
        static constexpr int CHANNEL_COUNT = 2;
        static constexpr int FILTER_ORDER = 101;
        static constexpr int OVERSAMPLING_FACTOR = 4;

        Oscillator() = default;
        Oscillator(const std::vector<float>& wavetable, float frequency, float amplitude, float sampleRate);

        void getSamples(float* outputBuffer, int numSamples) override;
        void onPlaybackStopped() override;

        void setFrequency(int trackId, float newFrequency);
        void setAmplitude(int trackId, float newAmplitude);
        void setWavetable(int trackId, const std::vector<float>& wavetable);
        void setIsMuted(int trackId, bool isMuted);

    private:
        void generateTrackSamples(AudioTrack& track, float* outputBuffer, int numSamples, int trackIndex);

        float m_sampleRate;
        
        std::array<std::shared_ptr<AudioTrack>, NUM_TRACKS> m_tracks;

        LowPassFilter m_lowPassFilter;
    };
}