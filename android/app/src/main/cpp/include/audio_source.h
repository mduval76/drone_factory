#pragma once

namespace DroneFactory {
    class AudioSource {
    public:
        virtual ~AudioSource() = default;
        virtual std::pair<float, float> getSample() = 0;
        virtual void onPlaybackStopped() = 0;
    };
}