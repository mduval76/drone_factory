package u9343789.drone_factory

enum class Wavetable {
    SINE {
        override fun toString(): String {
          return "Sine"
        }
      },
    
    TRIANGLE {
        override fun toString(): String {
            return "Triangle"
        }
    },

    SQUARE {
        override fun toString(): String {
            return "Square"
        }
    },

    SAWTOOTH {
        override fun toString(): String {
            return "Sawtooth"
        }
    };
}

interface Synthesizer {
    suspend fun play()
    suspend fun stop()
    suspend fun isPlaying() : Boolean
    suspend fun setFrequency(trackId: Int, frequencyInHz: Float)
    suspend fun setVolume(trackId: Int, volumeInDb: Float)
    suspend fun setWavetable(trackId: Int, wavetable: Wavetable)
}