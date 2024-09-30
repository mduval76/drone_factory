#include <cmath>

#include "synthesizer.h"
#include "log.h"
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
        // LOGD("SYNTHESIZER: isPlaying() called");
        return m_isPlaying;
    }

    void Synthesizer::play() {
        // LOGD("SYNTHESIZER: play() called");
        std::lock_guard<std::mutex> lock{m_mutex};
        const auto result = m_audioPlayer->play();
        if (result == 0) {
            m_isPlaying = true;
        }
        else {
            LOGD("Could not start playback.");
        }
    }

    void Synthesizer::stop() {
        // LOGD("SYNTHESIZER: stop() called");
        std::lock_guard<std::mutex> lock(m_mutex);
        m_audioPlayer->stop();
        m_isPlaying = false;
    }

    void Synthesizer::setFrequency(float frequencyInHz) {
        // LOGD("SYNTHESIZER: Frequency set to %.2f Hz.", frequencyInHz);
        m_oscillator->setFrequency(frequencyInHz);
    }

    void Synthesizer::setVolume(float volumeInDb) {
        // LOGD("SYNTHESIZER: Volume set to %.2f dB.", volumeInDb);
        const auto amplitude = dBToAmplitude(volumeInDb);
        // LOGD("SYNTHESIZER: Amplitude set to %.2f.", amplitude);
        m_oscillator->setAmplitude(amplitude);
    }

    void Synthesizer::setWavetable(Wavetable wavetable) {
        // LOGD("SYNTHESIZER: setWavetable() called");
        if (m_wavetable != wavetable) {
            m_wavetable = wavetable;
            m_oscillator->setWavetable(m_wavetableFactory.getWavetable(wavetable));
        }
    }
}