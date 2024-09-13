#include <utility>

#include "oboe_audio_player.h"
#include "audio_source.h"

using namespace oboe;

namespace DroneFactory {

    OboeAudioPlayer::OboeAudioPlayer(std::shared_ptr<AudioSource> source, int sampleRate)
        : m_source(std::move(source)), m_sampleRate(sampleRate) {}

    OboeAudioPlayer::~OboeAudioPlayer() {
        OboeAudioPlayer::stop();
    }

    int32_t OboeAudioPlayer::play() {
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
        if (m_stream) {
            m_stream->stop();
            m_stream->close();
            m_stream.reset();
        }
        m_source->onPlaybackStopped();
    }

    oboe::DataCallbackResult OboeAudioPlayer::onAudioReady(oboe::AudioStream* oboeStream, void* audioData, int32_t numFrames) {
        auto* floatData = reinterpret_cast<float*>(audioData);

        for (auto frame = 0; frame < numFrames; ++frame) {
            const auto [leftSample, rightSample] = m_source->getSample();
            
            for (auto channel = 0; channel < channelCount; ++channel) {
                if (channel == 0) {
                    floatData[frame * channelCount + channel] = leftSample;
                } 
                else if (channel == 1) {
                    floatData[frame * channelCount + channel] = rightSample;
                } 
                else {
                    floatData[frame * channelCount + channel] = 0.0f;
                }
            }
        }
        return oboe::DataCallbackResult::Continue;
    }
}