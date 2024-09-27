#include <jni.h>
#include "log.h"
#include <memory>

#include "synthesizer.h"

// Add logging to else blocks

extern "C" {
    JNIEXPORT jlong JNICALL
    Java_u9343789_drone_1factory_NativeSynthesizer_create(JNIEnv *env, jobject thiz) {
        auto synthesizer = std::make_unique<DroneFactory::Synthesizer>();

        if (not synthesizer) {
            LOGD("Failed to create the synthesizer.");
            synthesizer.reset(nullptr);
        }

        return reinterpret_cast<jlong>(synthesizer.release());
    }

    JNIEXPORT void JNICALL
    Java_u9343789_drone_1factory_NativeSynthesizer_delete(JNIEnv* env, jobject thiz, jlong synthesizerHandle) {
        auto* synthesizer = reinterpret_cast<DroneFactory::Synthesizer*>(synthesizerHandle);

        if (not synthesizer) {
            LOGD("Attempt to destroy an unitialized synthesizer.");
            return;
        }

        delete synthesizer;
    }

    JNIEXPORT void JNICALL
    Java_u9343789_drone_1factory_NativeSynthesizer_play(JNIEnv* env, jobject thiz, jlong synthesizerHandle) {
        auto* synthesizer = reinterpret_cast<DroneFactory::Synthesizer*>(synthesizerHandle);

        if (synthesizer) {
            synthesizer->play();
        }
        else {
            LOGD(
                "Synthesizer not created. Please, create the synthesizer first by "
                "calling create()."
            );
        }
    }

    JNIEXPORT void JNICALL
    Java_u9343789_drone_1factory_NativeSynthesizer_stop(JNIEnv* env, jobject thiz, jlong synthesizerHandle) {
        auto* synthesizer = reinterpret_cast<DroneFactory::Synthesizer*>(synthesizerHandle);

        if (synthesizer) {
            synthesizer->stop();
        }
        else {
            LOGD(
                "Synthesizer not created. Please, create the synthesizer first by "
                "calling create()."
            );
        }
    }

    JNIEXPORT jboolean JNICALL
    Java_u9343789_drone_1factory_NativeSynthesizer_isPlaying(JNIEnv* env, jobject thiz, jlong synthesizerHandle) {
        auto* synthesizer = reinterpret_cast<DroneFactory::Synthesizer*>(synthesizerHandle);

        if (not synthesizer) {
            LOGD(
                "Synthesizer not created. Please, create the synthesizer first by "
                "calling create()."
            );
            return false;
        }
        
        return synthesizer->isPlaying();
    }

    JNIEXPORT void JNICALL
    Java_u9343789_drone_1factory_NativeSynthesizer_setFrequency(JNIEnv* env, jobject thiz, jlong synthesizerHandle, jfloat frequencyInHz) {
        auto* synthesizer = reinterpret_cast<DroneFactory::Synthesizer*>(synthesizerHandle);
        const auto nativeFrequency = static_cast<float>(frequencyInHz);

        if (synthesizer) {
            synthesizer->setFrequency(nativeFrequency);
        }
        else {
            LOGD(
                "Synthesizer not created. Please, create the synthesizer first by "
                "calling create()."
            );
        }
    }

    JNIEXPORT void JNICALL
    Java_u9343789_drone_1factory_NativeSynthesizer_setVolume(JNIEnv* env, jobject thiz, jlong synthesizerHandle, jfloat volumeInDb) {
        auto* synthesizer = reinterpret_cast<DroneFactory::Synthesizer*>(synthesizerHandle);
        const auto nativeVolume = static_cast<float>(volumeInDb);

        if (synthesizer) {
            synthesizer->setVolume(nativeVolume);
        }
        else {
            LOGD(
                "Synthesizer not created. Please, create the synthesizer first by "
                "calling create()."
            );
        }
    }

    JNIEXPORT void JNICALL
    Java_u9343789_drone_1factory_NativeSynthesizer_setWavetable(JNIEnv* env, jobject thiz, jlong synthesizerHandle, jint wavetable) {
        auto* synthesizer = reinterpret_cast<DroneFactory::Synthesizer*>(synthesizerHandle);
        const auto nativeWavetable = static_cast<DroneFactory::Wavetable>(wavetable);

        if (synthesizer) {
            synthesizer->setWavetable(nativeWavetable);
        }
        else {
            LOGD(
                "Synthesizer not created. Please, create the synthesizer first by "
                "calling create()."
            );
        }
    }
}