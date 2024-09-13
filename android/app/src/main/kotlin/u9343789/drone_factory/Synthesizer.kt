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
    suspend fun setFrequency(frequencyInHz: Float)
    suspend fun setVolume(volumeInDb: Float)
    suspend fun setWavetable(wavetable: Wavetable)
}