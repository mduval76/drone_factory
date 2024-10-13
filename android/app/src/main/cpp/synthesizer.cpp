#include <cmath>

#include "oboe_audio_player.h"
#include "oscillator.h"
#include "synthesizer.h"
#include "log.h"

namespace DroneFactory {
    float dBToAmplitude(float dB) {
        return std::pow(10.f, dB / 20.f);
    }

    Synthesizer::Synthesizer() 
        : m_oscillator{std::make_shared<Oscillator>(m_wavetableFactory.getWavetable(Wavetable::NONE), defaultFrequency, defaultAmplitude, static_cast<float>(sampleRate))}, 
          m_audioPlayer(std::make_unique<OboeAudioPlayer>(m_oscillator, sampleRate)) {}

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

    std::vector<float> Synthesizer::getOscilloscopeSamples() {
        // LOGD("SYNTHESIZER: getAudioSamples() called");
        std::lock_guard<std::mutex> lock(m_mutex);
        return m_oscillator->getOscilloscopeSamples();
    }

    void Synthesizer::setFrequency(int trackId, float frequencyInHz)
    {
        // LOGD("SYNTHESIZER: Frequency set to %.2f Hz.", frequencyInHz);
        m_oscillator->setFrequency(trackId, frequencyInHz);
    }

    void Synthesizer::setVolume(int trackId, float volumeInDb) {
        const auto amplitude = dBToAmplitude(volumeInDb);
        m_oscillator->setAmplitude(trackId, amplitude);
    }

    void Synthesizer::setWavetable(int trackId, Wavetable wavetable) {
        m_oscillator->setWavetable(trackId, m_wavetableFactory.getWavetable(wavetable));
    }

    void Synthesizer::setIsMuted(int trackId, bool muted) {
        m_oscillator->setIsMuted(trackId, muted);
    }
}