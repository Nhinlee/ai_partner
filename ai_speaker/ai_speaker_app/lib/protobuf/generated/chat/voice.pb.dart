//
//  Generated code. Do not modify.
//  source: chat/voice.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class VoiceChatRequest extends $pb.GeneratedMessage {
  factory VoiceChatRequest({
    $core.String? text,
  }) {
    final $result = create();
    if (text != null) {
      $result.text = text;
    }
    return $result;
  }
  VoiceChatRequest._() : super();
  factory VoiceChatRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VoiceChatRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VoiceChatRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'pb'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VoiceChatRequest clone() => VoiceChatRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VoiceChatRequest copyWith(void Function(VoiceChatRequest) updates) => super.copyWith((message) => updates(message as VoiceChatRequest)) as VoiceChatRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VoiceChatRequest create() => VoiceChatRequest._();
  VoiceChatRequest createEmptyInstance() => create();
  static $pb.PbList<VoiceChatRequest> createRepeated() => $pb.PbList<VoiceChatRequest>();
  @$core.pragma('dart2js:noInline')
  static VoiceChatRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VoiceChatRequest>(create);
  static VoiceChatRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => clearField(1);
}

class VoiceChatResponse extends $pb.GeneratedMessage {
  factory VoiceChatResponse({
    $core.List<$core.int>? audio,
    $core.bool? isEnd,
  }) {
    final $result = create();
    if (audio != null) {
      $result.audio = audio;
    }
    if (isEnd != null) {
      $result.isEnd = isEnd;
    }
    return $result;
  }
  VoiceChatResponse._() : super();
  factory VoiceChatResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VoiceChatResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VoiceChatResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'pb'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'audio', $pb.PbFieldType.OY)
    ..aOB(2, _omitFieldNames ? '' : 'isEnd')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VoiceChatResponse clone() => VoiceChatResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VoiceChatResponse copyWith(void Function(VoiceChatResponse) updates) => super.copyWith((message) => updates(message as VoiceChatResponse)) as VoiceChatResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VoiceChatResponse create() => VoiceChatResponse._();
  VoiceChatResponse createEmptyInstance() => create();
  static $pb.PbList<VoiceChatResponse> createRepeated() => $pb.PbList<VoiceChatResponse>();
  @$core.pragma('dart2js:noInline')
  static VoiceChatResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VoiceChatResponse>(create);
  static VoiceChatResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get audio => $_getN(0);
  @$pb.TagNumber(1)
  set audio($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAudio() => $_has(0);
  @$pb.TagNumber(1)
  void clearAudio() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isEnd => $_getBF(1);
  @$pb.TagNumber(2)
  set isEnd($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIsEnd() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsEnd() => clearField(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
