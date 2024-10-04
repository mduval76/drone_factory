#include "audio_track.h"

namespace DroneFactory {

    AudioTrack::AudioTrack(float sampleRate, const std::vector<float>& wavetable)
        : m_sampleRate(sampleRate), m_wavetable(wavetable) {}

    float AudioTrack::getFrequency() const {
        return m_frequency.load();
    }

    void AudioTrack::setFrequency(float frequency) {
        m_frequency.store(frequency);
        m_indexIncrement = frequency * static_cast<float>(m_wavetable.size()) / m_sampleRate;
    }

    float AudioTrack::getAmplitude() const {
        return m_amplitude.load();
    }

    void AudioTrack::setAmplitude(float amplitude) {
        m_amplitude.store(amplitude);
    }

    const std::vector<float>& AudioTrack::getWavetable() const {
        return m_wavetable;
    }

    void AudioTrack::setWavetable(const std::vector<float>& wavetable) {
        m_wavetable = wavetable;
    }

    // Position of the index in the wavetable
    float AudioTrack::getIndex() const {
        return m_index;
    }

    void AudioTrack::setIndex(float index) {
        m_index = index;
    }

    // Index Increment (for frequency modulation)
    float AudioTrack::getIndexIncrement() const {
        return m_indexIncrement;
    }

    void AudioTrack::setIndexIncrement(float increment) {
        m_indexIncrement = increment;
    }

}