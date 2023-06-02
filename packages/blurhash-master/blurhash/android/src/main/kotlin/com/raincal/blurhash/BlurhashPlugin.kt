package com.raincal.blurhash

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import java.io.ByteArrayOutputStream

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class BlurhashPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "blurhash")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "blurHashEncode") {
      val image = call.argument<ByteArray>("image")!!
      val componentX = call.argument<Int>("componentX")!!
      val componentY = call.argument<Int>("componentY")!!

      var bitmap = BitmapFactory.decodeByteArray(image, 0, image.size)
      val blurHash = BlurHashEncoder.encode(bitmap, componentX, componentY)

      result.success(blurHash)
    } else if (call.method == "blurHashDecode") {
      val blurHash = call.argument<String>("blurHash")!!
      val width = call.argument<Int>("width")!!
      val height = call.argument<Int>("height")!!
      val punch = call.argument<Float>("punch")!!.toFloat()
      val useCache = call.argument<Boolean>("useCache")!!

      val bitmap = BlurHashDecoder.decode(blurHash, width, height, punch, useCache)

      if (bitmap == null) {
        result.error("INVALID_BLURHASH", "Failed to decode BlurHash", null)
      }

      val stream = ByteArrayOutputStream()
      bitmap!!.compress(Bitmap.CompressFormat.PNG, 100, stream)
      val byteArray = stream.toByteArray()
      bitmap.recycle()

      result.success(byteArray)
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
