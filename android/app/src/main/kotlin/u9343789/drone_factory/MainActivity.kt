package u9343789.drone_factory

import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class MainActivity: FlutterActivity() {
    private val CHANNEL = "u9343789.drone_factory/synth_channel"
    private val nativeSynthesizer = NativeSynthesizer()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        flutterEngine?.let {
            MethodChannel(it.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "play" -> {
                    CoroutineScope(Dispatchers.Main).launch {
                        try {
                            nativeSynthesizer.play()
                            result.success(null)
                        } 
                        catch (e: Exception) {
                            result.error("ERROR", "Failed to play", e.localizedMessage)
                        }
                    }
                }
                "stop" -> {
                    CoroutineScope(Dispatchers.Main).launch {
                        try {
                            nativeSynthesizer.stop()
                            result.success(null)
                        } 
                        catch (e: Exception) {
                            result.error("ERROR", "Failed to stop", e.localizedMessage)
                        }
                    }
                }
                "isPlaying" -> {
                    CoroutineScope(Dispatchers.Main).launch {
                        try {
                            val isPlaying = nativeSynthesizer.isPlaying()
                            result.success(isPlaying)
                        } 
                        catch (e: Exception) {
                            result.error("ERROR", "Failed to check if playing", e.localizedMessage)
                        }
                    }
                }
                "setFrequency" -> {
                    val trackId = call.argument<Int>("trackId") ?: 0
                    val frequency = call.argument<Double>("frequency")?.toFloat() ?: 110f
                    //Log.d("Synth", "Setting frequency to $frequency for track $trackId")
                    CoroutineScope(Dispatchers.Main).launch {
                        try {
                            nativeSynthesizer.setFrequency(trackId, frequency)
                            result.success(null)
                        } 
                        catch (e: Exception) {
                            result.error("ERROR", "Failed to set frequency", e.localizedMessage)
                        }
                    }
                }
                "setVolume" -> {
                    val trackId = call.argument<Int>("trackId") ?: 0
                    val volume = call.argument<Double>("volume")?.toFloat() ?: 0f
                    val volumeInDb = volume * 60 - 60
                    //Log.d("Synth", "Setting volume to $volume for track $trackId")
                    CoroutineScope(Dispatchers.Main).launch {
                        try {
                            nativeSynthesizer.setVolume(trackId, volumeInDb)
                            result.success(null)
                        } 
                        catch (e: Exception) {
                            result.error("ERROR", "Failed to set volume", e.localizedMessage)
                        }
                    }
                }
                "setWavetable" -> {
                    val args = call.arguments as Map<*, *>
                    val trackId = args["trackId"] as? Int ?: 0
                    val wavetable = args["wavetable"] as? Int ?: 0
                    CoroutineScope(Dispatchers.Main).launch {
                        try {
                            nativeSynthesizer.setWavetable(trackId, Wavetable.values()[wavetable])
                            result.success(null)
                        } 
                        catch (e: Exception) {
                            result.error("ERROR", "Failed to set wavetable", e.localizedMessage)
                        }
                    }
                }
                "setIsMuted" -> {
                    val trackId = call.argument<Int>("trackId") ?: 0
                    val isMuted = call.argument<Boolean>("isMuted") ?: false
                    CoroutineScope(Dispatchers.Main).launch {
                        try {
                            nativeSynthesizer.setIsMuted(trackId, isMuted)
                            result.success(null)
                        } 
                        catch (e: Exception) {
                            result.error("ERROR", "Failed to set mute for track $trackId", e.localizedMessage)
                        }
                    }
                }
                "getVisualizationData" -> {
                    CoroutineScope(Dispatchers.Main).launch {
                        try {
                            val visualizationData = nativeSynthesizer.getVisualizationData()
                            result.success(visualizationData?.toList())
                        } 
                        catch (e: Exception) {
                            result.error("ERROR", "Failed to get visualization data", e.localizedMessage)
                        }
                    }
                }
                else -> result.notImplemented()
            }
        }}
    }
}
