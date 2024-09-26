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

        // Set up the platform channel
        flutterEngine?.let {
            MethodChannel(it.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "play" -> {
                    CoroutineScope(Dispatchers.Main).launch {
                        try {
                            nativeSynthesizer.play()
                            result.success(null)
                        } catch (e: Exception) {
                            result.error("ERROR", "Failed to play", e.localizedMessage)
                        }
                    }
                }
                "stop" -> {
                    CoroutineScope(Dispatchers.Main).launch {
                        try {
                            nativeSynthesizer.stop()
                            result.success(null)
                        } catch (e: Exception) {
                            result.error("ERROR", "Failed to stop", e.localizedMessage)
                        }
                    }
                }
                "isPlaying" -> {
                    CoroutineScope(Dispatchers.Main).launch {
                        try {
                            val isPlaying = nativeSynthesizer.isPlaying()
                            result.success(isPlaying)
                        } catch (e: Exception) {
                            result.error("ERROR", "Failed to check if playing", e.localizedMessage)
                        }
                    }
                }
                "setFrequency" -> {
                    val frequency = call.argument<Double>("frequency")?.toFloat() ?: 440f
                    CoroutineScope(Dispatchers.Main).launch {
                        try {
                            nativeSynthesizer.setFrequency(frequency)
                            result.success(null)
                        } catch (e: Exception) {
                            result.error("ERROR", "Failed to set frequency", e.localizedMessage)
                        }
                    }
                }
                "setVolume" -> {
                    val volume = call.argument<Double>("volume")?.toFloat() ?: 0f
                    CoroutineScope(Dispatchers.Main).launch {
                        try {
                            nativeSynthesizer.setVolume(volume)
                            result.success(null)
                        } catch (e: Exception) {
                            result.error("ERROR", "Failed to set volume", e.localizedMessage)
                        }
                    }
                }
                "setWavetable" -> {
                    val wavetable = call.arguments as Int
                    CoroutineScope(Dispatchers.Main).launch {
                        try {
                            nativeSynthesizer.setWavetable(Wavetable.values()[wavetable])
                            result.success(null)
                        } catch (e: Exception) {
                            result.error("ERROR", "Failed to set wavetable", e.localizedMessage)
                        }
                    }
                }
                else -> result.notImplemented()
            }
        }}
    }
}
