#pragma once

#include <memory>
#include <mutex>

#include "wavetable.h"
#include "wavetable_factory.h"

constexpr auto sampleRate = 48000;
static constexpr float defaultFrequency = 110.0f;
static constexpr float defaultAmplitude = 0.0f; 

namespace DroneFactory {
    class Oscillator;
    class AudioPlayer;

    class Synthesizer {
    public:
        Synthesizer();
        ~Synthesizer();

        void play();
        void stop();
        bool isPlaying() const;

        void setFrequency(int trackId, float frequencyInHz);
        void setVolume(int trackId, float volumeInDb);
        void setWavetable(int trackId, Wavetable wavetable);
        void setIsMuted(int trackId, bool muted);

        std::vector<float> getVisualizationSamples();

    private:
        WavetableFactory m_wavetableFactory;
        
        std::atomic<bool> m_isPlaying{false};
        std::mutex m_waveMutex;
        std::mutex m_oscilloscopeMutex;
        std::shared_ptr<Oscillator> m_oscillator;
        std::unique_ptr<AudioPlayer> m_audioPlayer;
    };
}
