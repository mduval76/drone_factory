#pragma once

#include <vector>
#include <atomic>

#include "audio_source.h"

namespace DroneFactory {
    class Oscillator : public AudioSource {
    public:
        Oscillator() = default;
        Oscillator(std::vector<float> wavetable, float sampleRate);

        std::pair<float, float> getSample() override;
        void onPlaybackStopped() override;

        virtual void setFrequency(float newFrequency);
        virtual void setAmplitude(float newAmplitude);
        virtual void setWavetable(const std::vector<float> &wavetable);

    private:
        float interpolateLinearly() const;
        void swapWavetableIfNecessary();

        float m_index = 0.f;
        std::atomic<float> m_indexIncrement{0.f};
        std::vector<float> m_wavetable;
        float m_sampleRate;
        std::atomic<float> m_amplitude{1.f};
        std::atomic<float> m_frequency{440.f};

        std::atomic<bool> m_swapWavetable{false};
        std::vector<float> m_wavetableToSwap;
        std::atomic<bool> m_wavetableIsBeingSwapped{false};
    };

    class A4Oscillator : public Oscillator {
    public:
        explicit A4Oscillator(float sampleRate);

        std::pair<float, float> getSample() override;
        void onPlaybackStopped() override;

        void setFrequency(float newFrequency) override {};
        void setAmplitude(float newAmplitude) override {};
        void setWavetable(const std::vector<float> &wavetable) override {};

    private:    
        float m_phase{0.f};
        float m_phaseIncrement{0.f};
    };
}