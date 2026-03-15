package ru.odo24.mobile

import android.net.Uri
import android.os.Build
import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterFragmentActivity() {
  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "odo24/channel").setMethodCallHandler {
      call, result ->
        when (call.method) {
          "getSupportedAbis" -> {
            result.success(listOf<String>(*Build.SUPPORTED_ABIS))
          }
          "launchURL" -> {
            val urlArg: String? = call.argument("url")
            val urlIntent = Intent(
                Intent.ACTION_VIEW,
                Uri.parse(urlArg)
            )
            startActivity(urlIntent)
            result.success(null);
          }
          else -> result.notImplemented()
        }
    }
  }
}