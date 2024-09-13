#include <cmath>
#include <android/log.h> // Include the appropriate header file for LOGD macro
#include "oscillator.h"
#include "constants.h"

namespace DroneFactory {
    Oscillator::Oscillator(std::vector<float> wavetable, float sampleRate) : m_wavetable{std::move(wavetable)}, m_sampleRate{sampleRate} {}

    float Oscillator::getSample() {
        m_indexIncrement = m_frequency.load() * static_cast<float>(m_wavetable.size()) / static_cast<float>(m_sampleRate);

        swapWavetableIfNecessary();

        m_index = std::fmod(m_index, static_cast<float>(m_wavetable.size()));

        const auto sample = interpolateLinearly();

        m_index += m_indexIncrement;

        return m_amplitude * sample;
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
        m_indexIncrement = newFrequency * static_cast<float>(m_wavetable.size()) / static_cast<float>(m_sampleRate);
    }

    void Oscillator::setAmplitude(float newAmplitude) {
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
    
    float A4Oscillator::getSample() {
        const auto sample = 0.5f * std::sin(m_phase);

        m_phase = std::fmod(m_phase + m_phaseIncrement, 2.f * PI);

        return sample;
    }

    void A4Oscillator::onPlaybackStopped() {
        m_phase = 0.f;
    }
}
