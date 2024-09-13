#pragma once

#include <oboe/Oboe.h>
#include "audio_player.h"

namespace DroneFactory {
    class AudioSource;

    class OboeAudioPlayer : public oboe::AudioStreamCallback, public AudioPlayer {
    public:
        static constexpr auto channelCount = oboe::ChannelCount::Mono;

        OboeAudioPlayer(std::shared_ptr<AudioSource> source, int sampleRate);
        ~OboeAudioPlayer();
        
        int32_t play() override;
        void stop() override;

        oboe::DataCallbackResult onAudioReady(oboe::AudioStream* oboeStream, void* audioData, int32_t numFrames) override;

    private:
        std::shared_ptr<AudioSource> m_source;
        std::shared_ptr<oboe::AudioStream> m_stream;
        int m_sampleRate;
    };
}