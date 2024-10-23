package u9343789.drone_factory

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

class NativeSynthesizer : Synthesizer {
    private var synthesizerHandle: Long = 0
    private val synthesizerMutex = Object()

    private external fun create(): Long
    private external fun delete(synthesizerHandle: Long)
    private external fun play(synthesizerHandle: Long)
    private external fun stop(synthesizerHandle: Long)
    private external fun isPlaying(synthesizerHandle: Long): Boolean
    private external fun setFrequency(synthesizerHandle: Long, trackId: Int, frequencyInHz: Float)
    private external fun setVolume(synthesizerHandle: Long, trackId: Int, amplitudeInDb: Float)
    private external fun setWavetable(synthesizerHandle: Long, trackId: Int, wavetable: Int)
    private external fun setIsMuted(synthesizerHandle: Long, trackId: Int, isMuted: Boolean)
    private external fun getVisualizationData(synthesizerHandle: Long): FloatArray?

    companion object {
        init {
            System.loadLibrary("drone_factory")
        }
    }

    override suspend fun play() = withContext(Dispatchers.Default) {
        synchronized(synthesizerMutex) {
            createNativeHandleIfNotExists()
            play(synthesizerHandle)
        }
    }

    override suspend fun stop() = withContext(Dispatchers.Default) {
        synchronized(synthesizerMutex) {
            createNativeHandleIfNotExists()
            stop(synthesizerHandle)
        }
    }

    override suspend fun isPlaying(): Boolean = withContext(Dispatchers.Default) {
        synchronized(synthesizerMutex) {
            createNativeHandleIfNotExists()
            return@withContext isPlaying(synthesizerHandle)
        }
    }

    override suspend fun setFrequency(trackId: Int, frequencyInHz: Float) = withContext(Dispatchers.Default) {
        synchronized(synthesizerMutex) {
            createNativeHandleIfNotExists()
            setFrequency(synthesizerHandle, trackId, frequencyInHz)
        }
    }

    override suspend fun setVolume(trackId: Int, volumeInDb: Float) = withContext(Dispatchers.Default) {
        synchronized(synthesizerMutex) {
            createNativeHandleIfNotExists()
            setVolume(synthesizerHandle, trackId, volumeInDb)
        }
    }

    override suspend fun setWavetable(trackId: Int, wavetable: Wavetable) = withContext(Dispatchers.Default) {
        synchronized(synthesizerMutex) {
            createNativeHandleIfNotExists()
            setWavetable(synthesizerHandle, trackId, wavetable.ordinal)
        }
    }

    override suspend fun setIsMuted(trackId: Int, isMuted: Boolean) = withContext(Dispatchers.Default) {
        synchronized(synthesizerMutex) {
            createNativeHandleIfNotExists()
            setIsMuted(synthesizerHandle, trackId, isMuted)
        }
    }

    override suspend fun getVisualizationData(): FloatArray? = withContext(Dispatchers.Default) {
        synchronized(synthesizerMutex) {
            createNativeHandleIfNotExists()
            return@withContext getVisualizationData(synthesizerHandle)
        }
    }

    private fun createNativeHandleIfNotExists() {
        if (synthesizerHandle != 0L) {
            return
        }
        synthesizerHandle = create()
    }
}