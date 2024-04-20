//
//  Generated code. Do not modify.
//  source: chat/voice.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'voice.pb.dart' as $0;

export 'voice.pb.dart';

@$pb.GrpcServiceName('pb.VoiceChatService')
class VoiceChatServiceClient extends $grpc.Client {
  static final _$voiceChat = $grpc.ClientMethod<$0.VoiceChatRequest, $0.VoiceChatResponse>(
      '/pb.VoiceChatService/VoiceChat',
      ($0.VoiceChatRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.VoiceChatResponse.fromBuffer(value));

  VoiceChatServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseStream<$0.VoiceChatResponse> voiceChat($0.VoiceChatRequest request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$voiceChat, $async.Stream.fromIterable([request]), options: options);
  }
}

@$pb.GrpcServiceName('pb.VoiceChatService')
abstract class VoiceChatServiceBase extends $grpc.Service {
  $core.String get $name => 'pb.VoiceChatService';

  VoiceChatServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.VoiceChatRequest, $0.VoiceChatResponse>(
        'VoiceChat',
        voiceChat_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.VoiceChatRequest.fromBuffer(value),
        ($0.VoiceChatResponse value) => value.writeToBuffer()));
  }

  $async.Stream<$0.VoiceChatResponse> voiceChat_Pre($grpc.ServiceCall call, $async.Future<$0.VoiceChatRequest> request) async* {
    yield* voiceChat(call, await request);
  }

  $async.Stream<$0.VoiceChatResponse> voiceChat($grpc.ServiceCall call, $0.VoiceChatRequest request);
}
