Rule kafkaRule = {
    services: {
        "Kafka": {
            remoteFunctions: [kafkaOnConsumerRecordRule, kafkaOnErrorRule, NO_REMOTE_FUNCTION_RULE],
            resourceFunctions: [NO_RESOURCE_FUNCTION_RULE],
            methodRule: []
        }
    }
};

final RemoteFunctionRule kafkaOnConsumerRecordRule = {
    functionName: "onConsumerRecord",
    signature: [[[callerParam, recordsParam, payloadParam], returnType]],
    repeatability: ONE
};

final RemoteFunctionRule kafkaOnErrorRule = {
    functionName: "onError",
    signature: [[[errorParam, callerParam], returnType]],
    repeatability: ZERO_OR_ONE
};

// Parameter definitions
final Parameter callerParam = {
    'type: {typeName: "Caller", module: ["ballerina", "kafka"]},
    paramName: (),
    repeatability: ZERO_OR_ONE
};

final Parameter recordsParam = {
    'type: ["array", {typeName: "ConsumerRecord", module: ["ballerina", "kafka"]}, ()],
    paramName: (),
    repeatability: ZERO_OR_MORE
};

final Parameter payloadParam = {
    'type: ["array", "anydata", ()],
    paramName: (),
    repeatability: ZERO_OR_MORE
};

final Parameter errorParam = {
    'type: "error",
    paramName: (),
    repeatability: ZERO_OR_ONE
};

final ReturnType returnType = {
    'type: ["|", ["error", "()"]]
};
