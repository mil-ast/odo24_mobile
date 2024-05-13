package ru.odo24.mobile

import kotlin.random.Random
import java.io.File
import android.net.Uri
import android.util.Log
import android.os.Build
import android.app.Activity
import android.content.Intent
import androidx.core.content.FileProvider
import androidx.annotation.NonNull
import androidx.activity.result.ActivityResult
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result

class MainActivity: FlutterFragmentActivity() {
  val TAG = "ODO24"
  private var appInstallResult: Result? = null

  private val apkInstallLauncher: ActivityResultLauncher<Intent> = registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
    Log.d(TAG, "resultCode: ${result.resultCode}")
    when (result.resultCode) {
      Activity.RESULT_OK -> {
        appInstallResult?.success(null)
      }
      Activity.RESULT_CANCELED -> {
        appInstallResult?.error("apkInstallLauncher canceled", "resultCode: ${result.resultCode}", null)
      }
      Activity.RESULT_FIRST_USER -> {
        val intent: Intent? = result.data
        val installStatus = intent?.getIntExtra("android.intent.extra.INSTALL_RESULT", 0)

        var details: String = ""
        when (installStatus) {
          -3 -> {
            details = "The API is not available on this device"
          }
          -5 -> {
            details = "The install is unavailable to this user or device"
          }
          -6 -> {
            details = "The download/install is not allowed, due to the current device state (e.g. low battery, low disk space, ...)"
          }
          -7 -> {
            details = "The install/update has not been (fully) downloaded yet"
          }
          -8 -> {
            details = "The install is already in progress and there is no UI flow to resume"
          }
          -10 -> {
            details = "The app is not owned by any user on this device. An app is 'owned' if it has been acquired from Play"
          }
          else -> {
            details = "INSTALL_RESULT: ${installStatus}"
          }
        }
        appInstallResult?.error("apkInstallLauncher install error", details, null)
      }
    }
    appInstallResult = null
  }

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "odo24/channel").setMethodCallHandler {
      call, result ->
        when (call.method) {
          "getSupportedAbis" -> {
            result.success(listOf<String>(*Build.SUPPORTED_ABIS))
          }
          "installAppFromFile" -> {
            val filePathArg: String? = call.argument("filePath")
            appInstallResult = result
            installApk(filePathArg!!)
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

  /* private fun install(path: String) {
    val file = File(path)
    val uri = FileProvider.getUriForFile(
      this.applicationContext,
      "${this.applicationContext.packageName}.provider",
      file
    )
    val intent = Intent(Intent.ACTION_VIEW).apply {
      putExtra(Intent.EXTRA_NOT_UNKNOWN_SOURCE, true)
      putExtra(Intent.EXTRA_RETURN_RESULT, true)
      setDataAndType(uri, "application/vnd.android.package-archive")
      flags = Intent.FLAG_ACTIVITY_CLEAR_TASK and Intent.FLAG_ACTIVITY_NEW_TASK
      flags = Intent.FLAG_GRANT_READ_URI_PERMISSION
    }
    apkInstallLauncher?.launch(intent)
  } */

  private fun installApk(path: String) {
    val file = File(path)
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
      val uri = FileProvider.getUriForFile(
        this,
        "${this.applicationContext.packageName}.provider",
        file
      )
      val intent = Intent(Intent.ACTION_VIEW).apply {
        putExtra(Intent.EXTRA_NOT_UNKNOWN_SOURCE, true)
        putExtra(Intent.EXTRA_RETURN_RESULT, true)
        setDataAndType(uri, "application/vnd.android.package-archive")
        flags = Intent.FLAG_ACTIVITY_CLEAR_TASK and Intent.FLAG_ACTIVITY_NEW_TASK
        flags = Intent.FLAG_GRANT_READ_URI_PERMISSION
      }
      apkInstallLauncher?.launch(intent)
    } else {
      val intent = Intent(Intent.ACTION_VIEW)
      intent.setDataAndType(Uri.fromFile(file), "application/vnd.android.package-archive")
      intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
      apkInstallLauncher?.launch(intent)
    }
  }
}