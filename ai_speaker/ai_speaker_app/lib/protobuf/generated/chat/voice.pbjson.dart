//
//  Generated code. Do not modify.
//  source: chat/voice.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use voiceChatRequestDescriptor instead')
const VoiceChatRequest$json = {
  '1': 'VoiceChatRequest',
  '2': [
    {'1': 'text', '3': 1, '4': 1, '5': 9, '10': 'text'},
  ],
};

/// Descriptor for `VoiceChatRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voiceChatRequestDescriptor = $convert.base64Decode(
    'ChBWb2ljZUNoYXRSZXF1ZXN0EhIKBHRleHQYASABKAlSBHRleHQ=');

@$core.Deprecated('Use voiceChatResponseDescriptor instead')
const VoiceChatResponse$json = {
  '1': 'VoiceChatResponse',
  '2': [
    {'1': 'audio', '3': 1, '4': 1, '5': 12, '10': 'audio'},
    {'1': 'is_end', '3': 2, '4': 1, '5': 8, '10': 'isEnd'},
  ],
};

/// Descriptor for `VoiceChatResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voiceChatResponseDescriptor = $convert.base64Decode(
    'ChFWb2ljZUNoYXRSZXNwb25zZRIUCgVhdWRpbxgBIAEoDFIFYXVkaW8SFQoGaXNfZW5kGAIgAS'
    'gIUgVpc0VuZA==');

