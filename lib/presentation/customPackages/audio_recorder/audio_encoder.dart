enum AudioEncoderType {
  /// Will output to MPEG_4 format container.
  // ignore: constant_identifier_names
  AAC,

  /// Will output to MPEG_4 format container.
  // ignore: constant_identifier_names
  AAC_LD,

  /// Will output to MPEG_4 format container.
  // ignore: constant_identifier_names
  AAC_HE,

  /// sampling rate should be set to 8kHz.
  /// Will output to 3GP format container on Android.
  // ignore: constant_identifier_names
  AMR_NB,

  /// sampling rate should be set to 16kHz.
  /// Will output to 3GP format container on Android.
  // ignore: constant_identifier_names
  AMR_WB,

  /// Will output to MPEG_4 format container.
  /// /!\ SDK 29 on Android /!\
  /// /!\ SDK 11 on iOs /!\
  // ignore: constant_identifier_names
  OPUS,
}
