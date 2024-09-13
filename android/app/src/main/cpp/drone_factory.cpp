#include <jni.h>
#include <memory>

#include "synthesizer.h"

// Add logging to else blocks

extern "C" {
    JNIEXPORT jlong JNICALL
    Java_u9343789_drone_1factory_NativeSynthesizer_create(JNIEnv *env, jobject thiz) {
        auto synthesizer = std::make_unique<DroneFactory::Synthesizer>();

        if (not synthesizer) {
            synthesizer.reset(nullptr);
        }

        return reinterpret_cast<jlong>(synthesizer.release());
    }

    JNIEXPORT void JNICALL
    Java_u9343789_drone_1factory_NativeSynthesizer_delete(JNIEnv* env, jobject thiz, jlong synthesizerHandle) {
        auto* synthesizer = reinterpret_cast<DroneFactory::Synthesizer*>(synthesizerHandle);

        if (not synthesizer) {
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
            return;
        }
    }

    JNIEXPORT void JNICALL
    Java_u9343789_drone_1factory_NativeSynthesizer_stop(JNIEnv* env, jobject thiz, jlong synthesizerHandle) {
        auto* synthesizer = reinterpret_cast<DroneFactory::Synthesizer*>(synthesizerHandle);

        if (synthesizer) {
            synthesizer->stop();
        }
        else {
            return;
        }
    }

    JNIEXPORT jboolean JNICALL
    Java_u9343789_drone_1factory_NativeSynthesizer_isPlaying(JNIEnv* env, jobject thiz, jlong synthesizerHandle) {
        auto* synthesizer = reinterpret_cast<DroneFactory::Synthesizer*>(synthesizerHandle);

        if (not synthesizer) {
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
            return;
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
            return;
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
            return;
        }
    }
}