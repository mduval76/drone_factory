#include <utility>
#include <vector>

#include "oboe_audio_player.h"
#include "audio_source.h"
#include "log.h"

using namespace oboe;

namespace DroneFactory {
#ifndef NDEBUG
    static std::atomic<int> instances{0};
#endif

    OboeAudioPlayer::OboeAudioPlayer(std::shared_ptr<AudioSource> source, int sampleRate)
        : m_source(std::move(source)), m_sampleRate(sampleRate) {
#ifndef NDEBUG
        LOGD("OboeAudioPlayer created. Instances count: %d", ++instances);
#endif
    }

    OboeAudioPlayer::~OboeAudioPlayer() {
#ifndef NDEBUG
        LOGD("OboeAudioPlayer destroyed. Instances count: %d", --instances);
#endif
        OboeAudioPlayer::stop();
    }

    int32_t OboeAudioPlayer::play() {
#ifndef NDEBUG
        LOGD("OboeAudioPlayer::play()");
#endif
        AudioStreamBuilder builder;
        const auto result =
            builder.setPerformanceMode(PerformanceMode::LowLatency)
                ->setDirection(Direction::Output)
                ->setSampleRate(m_sampleRate)
                ->setDataCallback(this)
                ->setSharingMode(SharingMode::Exclusive)
                ->setFormat(AudioFormat::Float)
                ->setChannelCount(channelCount)
                ->setSampleRateConversionQuality(SampleRateConversionQuality::Best)
                ->openStream(m_stream);

        if (result != Result::OK) {
            return static_cast<int32_t>(result);
        }

        const auto playResult = m_stream->requestStart();

        return static_cast<int32_t>(playResult);
    }

    void OboeAudioPlayer::stop() {
#ifndef NDEBUG
        LOGD("OboeAudioPlayer::stop()");
#endif
        if (m_stream) {
            m_stream->stop();
            m_stream->close();
            m_stream.reset();
        }
        m_source->onPlaybackStopped();
    }

    oboe::DataCallbackResult OboeAudioPlayer::onAudioReady(oboe::AudioStream* oboeStream, void* audioData, int32_t numFrames) {
        auto* floatData = reinterpret_cast<float*>(audioData);

        std::vector<float> stereoOutputBuffer(numFrames * channelCount, 0.0f);

        m_source->getSamples(stereoOutputBuffer.data(), numFrames);

        std::copy(stereoOutputBuffer.begin(), stereoOutputBuffer.end(), floatData);
        
        return oboe::DataCallbackResult::Continue;
    }
}