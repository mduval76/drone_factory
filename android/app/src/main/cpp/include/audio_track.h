#pragma once

#include <vector>
#include <atomic>

namespace DroneFactory {
    class AudioTrack {
    public:
        AudioTrack(float sampleRate, const std::vector<float>& wavetable);

        // Getters
        float getFrequency() const;
        float getAmplitude() const;
        const std::vector<float>& getWavetable() const;
        float getIndexIncrement() const;
        float getIndex() const;
        bool isMuted() const;
        bool isSoloed() const;

        // Setters
        void setFrequency(float frequency);
        void setAmplitude(float amplitude);
        void setWavetable(const std::vector<float>& wavetable);
        void setIndex(float index);
        void setIndexIncrement(float increment);
        void setMuted(bool isMuted);
        void setSoloed(bool isSoloed);

    private:
        std::atomic<bool> m_isMuted{false};
        std::atomic<bool> m_isSoloed{false};
        std::atomic<float> m_frequency;
        std::atomic<float> m_amplitude;
        std::atomic<float> m_index{0.f};
        std::atomic<float> m_indexIncrement{0.f};

        std::vector<float> m_wavetable;
        
        float m_sampleRate;
    };
}