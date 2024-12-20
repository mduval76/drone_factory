#include <jni.h>
#include <memory>

#include "synthesizer.h"
#include "log.h"

extern "C" {
    JNIEXPORT jlong JNICALL
    Java_u9343789_drone_1factory_NativeSynthesizer_create(JNIEnv *env, 
                                                          jobject thiz) 
    {
        auto synthesizer = std::make_unique<DroneFactory::Synthesizer>();

        if (not synthesizer) {
            LOGD("Failed to create the synthesizer.");
            synthesizer.reset(nullptr);
        }
        return reinterpret_cast<jlong>(synthesizer.release());
    }

    JNIEXPORT void JNICALL
    Java_u9343789_drone_1factory_NativeSynthesizer_delete(JNIEnv* env, 
                                                          jobject thiz,
                                                          jlong synthesizerHandle) 
    {
        auto* synthesizer = reinterpret_cast<DroneFactory::Synthesizer*>(synthesizerHandle);

        if (not synthesizer) {
            LOGD("Attempt to destroy an unitialized synthesizer.");
            return;
        }
        delete synthesizer;
    }

    JNIEXPORT void JNICALL
    Java_u9343789_drone_1factory_NativeSynthesizer_play(JNIEnv* env, 
                                                        jobject thiz, 
                                                        jlong synthesizerHandle) 
    {
        auto* synthesizer = reinterpret_cast<DroneFactory::Synthesizer*>(synthesizerHandle);

        if (synthesizer) {
            synthesizer->play();
        }
        else {
            LOGD("Synthesizer not created. Please, create the synthesizer first by calling create().");
        }
    }

    JNIEXPORT void JNICALL
    Java_u9343789_drone_1factory_NativeSynthesizer_stop(JNIEnv* env, 
                                                        jobject thiz, 
                                                        jlong synthesizerHandle) 
    {
        auto* synthesizer = reinterpret_cast<DroneFactory::Synthesizer*>(synthesizerHandle);

        if (synthesizer) {
            synthesizer->stop();
        }
        else {
            LOGD("Synthesizer not created. Please, create the synthesizer first by calling create().");
        }
    }

    JNIEXPORT jboolean JNICALL
    Java_u9343789_drone_1factory_NativeSynthesizer_isPlaying(JNIEnv* env, 
                                                             jobject thiz, 
                                                             jlong synthesizerHandle) 
    {
        auto* synthesizer = reinterpret_cast<DroneFactory::Synthesizer*>(synthesizerHandle);

        if (not synthesizer) {
            LOGD("Synthesizer not created. Please, create the synthesizer first by calling create().");
            return false;
        }
        return synthesizer->isPlaying();
    }

    JNIEXPORT void JNICALL
    Java_u9343789_drone_1factory_NativeSynthesizer_setFrequency(JNIEnv* env, 
                                                                jobject thiz, 
                                                                jlong synthesizerHandle, 
                                                                jint trackId, 
                                                                jfloat frequencyInHz) 
    {
        auto* synthesizer = reinterpret_cast<DroneFactory::Synthesizer*>(synthesizerHandle);
        const auto nativeFrequency = static_cast<float>(frequencyInHz);

        if (synthesizer) {
            synthesizer->setFrequency(trackId, nativeFrequency); 
        }
        else {
            LOGD("Synthesizer not created. Please, create the synthesizer first by calling create().");
        }
    }

    JNIEXPORT void JNICALL
    Java_u9343789_drone_1factory_NativeSynthesizer_setVolume(JNIEnv* env, 
                                                             jobject thiz, 
                                                             jlong synthesizerHandle,
                                                             jint trackId,
                                                             jfloat volumeInDb) 
    {
        auto* synthesizer = reinterpret_cast<DroneFactory::Synthesizer*>(synthesizerHandle);
        const auto nativeVolume = static_cast<float>(volumeInDb);

        if (synthesizer) {
            synthesizer->setVolume(trackId, nativeVolume);
        }
        else {
            LOGD("Synthesizer not created. Please, create the synthesizer first by calling create().");
        }
    }

    JNIEXPORT void JNICALL
    Java_u9343789_drone_1factory_NativeSynthesizer_setWavetable(JNIEnv* env, 
                                                                jobject thiz,
                                                                jlong synthesizerHandle, 
                                                                jint trackId,
                                                                jint wavetable) 
    {
        auto* synthesizer = reinterpret_cast<DroneFactory::Synthesizer*>(synthesizerHandle);
        const auto nativeWavetable = static_cast<DroneFactory::Wavetable>(wavetable);

        if (synthesizer) {
            synthesizer->setWavetable(trackId, nativeWavetable);
        }
        else {
            LOGD("Synthesizer not created. Please, create the synthesizer first by calling create().");
        }
    }

    JNIEXPORT void JNICALL
    Java_u9343789_drone_1factory_NativeSynthesizer_setIsMuted(JNIEnv* env, 
                                                              jobject thiz, 
                                                              jlong synthesizerHandle, 
                                                              jint trackId, 
                                                              jboolean muted) 
    {
        auto* synthesizer = reinterpret_cast<DroneFactory::Synthesizer*>(synthesizerHandle);
        const auto nativeMuted = static_cast<bool>(muted);

        if (synthesizer) {
            synthesizer->setIsMuted(trackId, nativeMuted);
        }
        else {
            LOGD("Synthesizer not created. Please, create the synthesizer first by calling create().");
        }
    }

    JNIEXPORT void JNICALL
    Java_u9343789_drone_1factory_NativeSynthesizer_setIsSoloed(JNIEnv* env, 
                                                              jobject thiz, 
                                                              jlong synthesizerHandle, 
                                                              jint trackId, 
                                                              jboolean soloed) 
    {
        auto* synthesizer = reinterpret_cast<DroneFactory::Synthesizer*>(synthesizerHandle);
        const auto nativeSoloed = static_cast<bool>(soloed);

        if (synthesizer) {
            synthesizer->setIsSoloed(trackId, nativeSoloed);
        }
        else {
            LOGD("Synthesizer not created. Please, create the synthesizer first by calling create().");
        }
    }

    JNIEXPORT jfloatArray JNICALL
    Java_u9343789_drone_1factory_NativeSynthesizer_getVisualizationData(JNIEnv* env,
                                                                        jobject thiz,
                                                                        jlong synthesizerHandle) 
    {
        auto* synthesizer = reinterpret_cast<DroneFactory::Synthesizer*>(synthesizerHandle);

        if (!synthesizer) {
            LOGD("Synthesizer not created. Please, create the synthesizer first by calling create().");
            return nullptr;
        }

        std::vector<float> samples = synthesizer->getVisualizationSamples();
        jfloatArray result = env->NewFloatArray(samples.size());

        if (!result) {
            LOGD("Failed to create float array for visualization data.");
            return nullptr;
        }
        
        env->SetFloatArrayRegion(result, 0, samples.size(), samples.data());
        return result;
    }
}