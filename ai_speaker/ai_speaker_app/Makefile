gen-proto-dart:
	rm -rf lib/protobuf/generated
	mkdir -p lib/protobuf/generated
	protoc --proto_path=../backend/proto \
 			--dart_out=grpc:lib/protobuf/generated \
 			../backend/proto/**/*.proto
