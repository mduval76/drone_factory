#include <cmath>
#include "log.h"
#include "oscillator.h"
#include "constants.h"

namespace DroneFactory {
    Oscillator::Oscillator(std::vector<float> wavetable, float sampleRate)
     : m_wavetable{std::move(wavetable)}, m_sampleRate{sampleRate} {}

    std::pair<float, float> Oscillator::getSample() {
        m_indexIncrement = m_frequency.load() * static_cast<float>(m_wavetable.size()) / static_cast<float>(m_sampleRate);

        swapWavetableIfNecessary();

        m_index = std::fmod(m_index, static_cast<float>(m_wavetable.size()));

        const auto sample = interpolateLinearly();

        m_index += m_indexIncrement;
        //LOGD("OSCILLATOR: m_index = %.2f, m_indexIncrement = %.5f", m_index, m_indexIncrement.load());
        float monoSample = m_amplitude * sample;

        return std::make_pair(monoSample, monoSample);
    }

    void Oscillator::swapWavetableIfNecessary() {
        m_wavetableIsBeingSwapped.store(true, std::memory_order_release);
        if (m_swapWavetable.load(std::memory_order_acquire)) {

            std::swap(m_wavetable, m_wavetableToSwap);
            m_swapWavetable.store(false, std::memory_order_relaxed);
        }
        m_wavetableIsBeingSwapped.store(false, std::memory_order_release);
    }

    void Oscillator::onPlaybackStopped() {
        m_index = 0.f;
    }

    void Oscillator::setFrequency(float newFrequency) {
        LOGD("OSCILLATOR: setFrequencycalled and set to %.2f Hz.", newFrequency);
        m_frequency.store(newFrequency); 
        m_indexIncrement = newFrequency * static_cast<float>(m_wavetable.size()) / static_cast<float>(m_sampleRate);
    }

    void Oscillator::setAmplitude(float newAmplitude) {
        LOGD("OSCILLATOR: setAmplitude called and set to %.2f Hz.", newAmplitude);
        m_amplitude.store(newAmplitude);
    }

    void Oscillator::setWavetable(const std::vector<float> &wavetable) {
        m_swapWavetable.store(false, std::memory_order_release);
        while (m_wavetableIsBeingSwapped.load(std::memory_order_acquire)) {
        }
        m_wavetableToSwap = wavetable;
        m_swapWavetable.store(true, std::memory_order_release);
    }

    float Oscillator::interpolateLinearly() const {
        const auto truncatedIndex = static_cast<typename decltype(m_wavetable)::size_type>(m_index);
        const auto nextIndex = (truncatedIndex + 1u) % m_wavetable.size();
        const auto nextIndexWeight = m_index - static_cast<float>(truncatedIndex);

        return m_wavetable[nextIndex] * nextIndexWeight + (1.f - nextIndexWeight) * m_wavetable[truncatedIndex];
    }

    A4Oscillator::A4Oscillator(float sampleRate) : m_phaseIncrement{2.f * PI * 440.f / sampleRate} {}
    
    std::pair<float, float> A4Oscillator::getSample() {
        const auto sample = 0.5f * std::sin(m_phase);

        m_phase = std::fmod(m_phase + m_phaseIncrement, 2.f * PI);

        return std::make_pair(sample, sample);
    }

    void A4Oscillator::onPlaybackStopped() {
        m_phase = 0.f;
    }
}
