ModuleData kafkaRule = {
    servicesRules: {
        "Service": {
            module: ["ballerina", "kafka"],
            remoteFunctions: [kafkaOnConsumerRecordRule, kafkaOnErrorRule, NO_REMOTE_FUNCTION_RULE],
            resourceFunctions: [NO_RESOURCE_FUNCTION_RULE],
            methodRule: []
        }
    }
};

final RemoteFunctionRule kafkaOnConsumerRecordRule = {
    functionName: "onConsumerRecord",
    signatures: [kafkaOnConsumerRecordSignature],
    repeatability: ONE
};

final RemoteFunctionRule kafkaOnErrorRule = {
    functionName: "onError",
    signatures: [kafkaOnErrorSignature],
    repeatability: ZERO_OR_ONE
};

final FunctionSignature kafkaOnConsumerRecordSignature = {
    parameters: [callerParam, recordsParam, payloadParam],
    minParams: 1,
    maxParams: 3,
    returnType: returnType
};

final FunctionSignature kafkaOnErrorSignature = {
    parameters: [errorParam, callerParam],
    minParams: 1,
    maxParams: 1,
    returnType: returnType
};

// Parameter definitions
final Parameter callerParam = {
    'type: {typeName: "Caller", module: ["ballerina", "kafka"]},
    paramName: (),
    repeatability: ZERO_OR_ONE
};

final Parameter recordsParam = {
    'type: [
        "1?",
        [
            ["array", {typeName: "AnydataConsumerRecord", module: ["ballerina", "kafka"]}, ()],
            ["array", {typeName: "ByteConsumerRecords", module: ["ballerinax", "kafka"]}, ()],
            ["array", "anydata", ()]
        ]
    ],
    paramName: (),
    repeatability: ZERO_OR_MORE
};

final Parameter payloadParam = {
    'type: ["array", "anydata", ()],
    paramName: (),
    repeatability: ZERO_OR_MORE
};

final Parameter errorParam = {
    'type: {typeName: "Error", module: ["ballerina", "kafka"]},
    paramName: (),
    repeatability: ZERO_OR_ONE
};

final ReturnType returnType = {
    'type: ["?", ["error"]]
};
