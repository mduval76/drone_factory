#pragma once

#include <memory>
#include <mutex>

#include "wavetable.h"
#include "wavetable_factory.h"

constexpr auto sampleRate = 48000;

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

        void setFrequency(float frequencyInHz);
        void setVolume(float volumeInDb);
        void setWavetable(Wavetable wavetable);

    private:
        std::atomic<bool> m_isPlaying{false};
        float m_frequency;
        float m_volume;
        Wavetable m_wavetable{Wavetable::SINE};
        WavetableFactory m_wavetableFactory;
        std::shared_ptr<Oscillator> m_oscillator;
        std::mutex m_mutex;
        std::unique_ptr<AudioPlayer> m_audioPlayer;
    };
}
