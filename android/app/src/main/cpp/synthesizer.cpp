#include <cmath>

#include "synthesizer.h"
#include "oboe_audio_player.h"
#include "oscillator.h"

namespace DroneFactory {
    float dBToAmplitude(float dB) {
        return std::pow(10.f, dB / 20.f);
    }

    Synthesizer::Synthesizer() 
        : m_oscillator{std::make_shared<Oscillator>(m_wavetableFactory.getWavetable(m_wavetable), sampleRate)}, m_audioPlayer(std::make_unique<OboeAudioPlayer>(m_oscillator, sampleRate)) {}

    Synthesizer::~Synthesizer() = default;

    bool Synthesizer::isPlaying() const {
        return m_isPlaying;
    }

    void Synthesizer::play() {
        std::lock_guard<std::mutex> lock{m_mutex};
        const auto result = m_audioPlayer->play();
        if (result == 0) {
            m_isPlaying = true;
        }
        else {
            m_isPlaying = false;
        }
    }

    void Synthesizer::stop() {
        std::lock_guard<std::mutex> lock(m_mutex);
        m_audioPlayer->stop();
        m_isPlaying = false;
    }

    void Synthesizer::setFrequency(float frequencyInHz) {
        m_oscillator->setFrequency(frequencyInHz);
    }

    void Synthesizer::setVolume(float volumeInDb) {
        const auto amplitude = dBToAmplitude(volumeInDb);
        m_oscillator->setAmplitude(amplitude);
    }

    void Synthesizer::setWavetable(Wavetable wavetable) {
        if (m_wavetable != wavetable) {
            m_wavetable = wavetable;
            m_oscillator->setWavetable(m_wavetableFactory.getWavetable(wavetable));
        }
    }
}