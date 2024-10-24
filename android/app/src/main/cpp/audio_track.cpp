#include "audio_track.h"
#include "log.h"

namespace DroneFactory {

    AudioTrack::AudioTrack(float sampleRate, const std::vector<float>& wavetable)
        : m_sampleRate(sampleRate), m_wavetable(wavetable) {}

    float AudioTrack::getFrequency() const {
        return m_frequency.load();
    }

    void AudioTrack::setFrequency(float frequency) {
        m_frequency.store(frequency);
        m_indexIncrement.store(frequency * static_cast<float>(m_wavetable.size()) / m_sampleRate);
        //LOGD("SetFrequency: Frequency=%f, IndexIncrement=%f", frequency, m_indexIncrement.load());
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
        return m_index.load(std::memory_order_relaxed);
    }

    void AudioTrack::setIndex(float index) {
        m_index.store(index, std::memory_order_relaxed);
    }

    // Index Increment (for frequency modulation)
    float AudioTrack::getIndexIncrement() const {
        return m_indexIncrement;
    }

    void AudioTrack::setIndexIncrement(float increment) {
        m_indexIncrement.store(increment);
    }

    bool AudioTrack::isMuted() const {
        return m_isMuted.load();
    }

    void AudioTrack::setMuted(bool muted) {
        m_isMuted.store(muted);
    }
}