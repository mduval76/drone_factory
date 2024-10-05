package u9343789.drone_factory

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.launch
import kotlin.math.exp
import kotlin.math.ln

class SynthesizerViewModel : ViewModel() {
    var synthesizer: Synthesizer? = null
    set(value) {
        field = value
        applyParameters(0)
    }

    private val _frequency = MutableLiveData(440f)
    val frequency: LiveData<Float>
    get() {
        return _frequency
    }
    private val frequencyRange = 20f..2000f
    
    private val _volume = MutableLiveData(0f)
    val volume: LiveData<Float>
    get() {
        return _volume
    }
    val volumeRange = (-60f)..0f
    
    private var wavetable = Wavetable.SINE

    fun setFrequencySliderPosition(trackId: Int, frequencySliderPosition: Float) {
        val frequencyInHz = frequencyInHzFromSliderPosition(frequencySliderPosition)
        _frequency.value = frequencyInHz

        // Coroutine
        viewModelScope.launch {
            synthesizer?.setFrequency(trackId, frequencyInHz)
        }
    }

    fun setVolumeSliderPosition(trackId: Int, volumeSliderPosition: Float) {
        val volumeInDb = volumeInDbFromSliderPosition(volumeSliderPosition)
        _volume.value = volumeInDb

        // Coroutine
        viewModelScope.launch {
            synthesizer?.setVolume(trackId, volumeInDb)
        }
    }

    fun setWavetable(trackId: Int, newWavetable: Wavetable) {
        wavetable = newWavetable

        // Coroutine
        viewModelScope.launch {
            synthesizer?.setWavetable(trackId, newWavetable)
        }
    }

    fun playClicked() {
        // Coroutine
        viewModelScope.launch {
            if (synthesizer?.isPlaying() == true) {
                synthesizer?.stop()
            } 
            else {
                synthesizer?.play()
            }
            updatePlayButtonLabel()
        }
    }

    private fun frequencyInHzFromSliderPosition(sliderPosition: Float): Float {
        val rangePosition = linearToExponential(sliderPosition)
        return valueFromRangePosition(frequencyRange, rangePosition)
    }
    
    fun sliderPositionFromFrequencyInHz(frequencyInHz: Float): Float {
        val rangePosition = rangePositionFromValue(frequencyRange, frequencyInHz)
        return exponentialToLinear(rangePosition)
    }

    private fun volumeInDbFromSliderPosition(sliderPosition: Float): Float {
        val rangePosition = sliderPosition
        return valueFromRangePosition(volumeRange, sliderPosition)
    }

    fun sliderPositionFromVolumeInDb(volumeInDb: Float): Float {
        val rangePosition = rangePositionFromValue(volumeRange, volumeInDb)
        return rangePositionFromValue(volumeRange, volumeInDb)
    }

    companion object LinearToExponentialConverter {
        private const val MINIMUM_VALUE = 0.001f

        fun linearToExponential(value: Float): Float {
            assert(value in 0f..1f)
            if (value < MINIMUM_VALUE) {
                return 0f
            }
            return exp(ln(MINIMUM_VALUE) - ln(MINIMUM_VALUE) * value)
        }
    
        fun valueFromRangePosition(range: ClosedFloatingPointRange<Float>, rangePosition: Float): Float {
            assert(rangePosition in 0f..1f)
            return range.start + (range.endInclusive - range.start) * rangePosition
        }
    
    
        fun rangePositionFromValue(range: ClosedFloatingPointRange<Float>, value: Float): Float {
            assert(value in range)
            return (value - range.start) / (range.endInclusive - range.start)
        }
    
    
        fun exponentialToLinear(rangePosition: Float): Float {
            assert(rangePosition in 0f..1f)
            if (rangePosition < MINIMUM_VALUE) {
                return rangePosition
            }
            return (ln(rangePosition) - ln(MINIMUM_VALUE)) / (-ln(MINIMUM_VALUE))
        }
    }

    private val _playButtonLabel = MutableLiveData("Play")
    val playButtonLabel: LiveData<String>
    get() {
        return _playButtonLabel
    }

    fun applyParameters(trackId: Int) {
        viewModelScope.launch {
            synthesizer?.setFrequency(trackId, frequency.value!!)
            synthesizer?.setVolume(trackId, volume.value!!)
            synthesizer?.setWavetable(trackId, wavetable)
            updatePlayButtonLabel()
        }
    }

    private fun updatePlayButtonLabel() {
        // Coroutine
        viewModelScope.launch {
            if (synthesizer?.isPlaying() == true) {
                _playButtonLabel.value = "Stop"
            } 
            else {
                _playButtonLabel.value = "Play"
            }
        }
    }
}