#pragma once

#include <vector>
#include <array>
#include <memory>
#include <mutex>

#include "audio_source.h"
#include "audio_track.h"
#include "low_pass_filter.h"
#include "constants.h"

namespace DroneFactory {
    class Oscillator : public AudioSource {
    public:
        //Oscillator() = default;
        Oscillator(const std::vector<float>& wavetable, float frequency, float amplitude, float sampleRate);

        void getSamples(float* outputBuffer, int numSamples) override;
        void onPlaybackStopped() override;
        std::vector<float> getVisualizationSamples();

        void setFrequency(int trackId, float newFrequency);
        void setAmplitude(int trackId, float newAmplitude);
        void setWavetable(int trackId, const std::vector<float>& wavetable);
        void setIsMuted(int trackId, bool isMuted);
        void setIsSoloed(int trackId, bool isSoloed);

    private:
        void generateTrackSamples(AudioTrack& track, float* outputBuffer, int numSamples, int trackIndex);
        float m_sampleRate;
        
        std::array<std::shared_ptr<AudioTrack>, NUM_TRACKS> m_tracks;

        LowPassFilter m_lowPassFilter;

        std::vector<float> m_visualizationBuffer;
        std::mutex m_visualizationBufferMutex;
    };
}