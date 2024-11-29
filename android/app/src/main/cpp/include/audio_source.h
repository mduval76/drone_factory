#pragma once

namespace DroneFactory {
    class AudioSource {
    public:
        virtual ~AudioSource() = default;
        virtual void getSamples(float* outputBuffer, int numSamples) = 0;
        virtual void onPlaybackStopped() = 0;
    };
}