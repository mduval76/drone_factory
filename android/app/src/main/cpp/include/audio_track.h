#pragma once

#include <vector>
#include <atomic>

namespace DroneFactory {
    class AudioTrack {
    public:
        AudioTrack(float sampleRate, const std::vector<float>& wavetable);

        // Getters and setters for track properties
        float getFrequency() const;
        void setFrequency(float frequency);

        float getAmplitude() const;
        void setAmplitude(float amplitude);

        const std::vector<float>& getWavetable() const;
        void setWavetable(const std::vector<float>& wavetable);

        float getIndex() const;
        void setIndex(float index);

        float getIndexIncrement() const;
        void setIndexIncrement(float increment);

    private:
        std::atomic<float> m_frequency{440.f};
        std::atomic<float> m_amplitude{1.f};
        std::vector<float> m_wavetable;
        float m_index{0.f};
        float m_indexIncrement{0.f};
        float m_sampleRate;
    };
}