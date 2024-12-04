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
    parameters: [kafkaCallerParam, kafkaRecordsParam, kafkaPayloadParam],
    minParams: 1,
    maxParams: 3,
    returnType: kafkaReturnType
};

final FunctionSignature kafkaOnErrorSignature = {
    parameters: [kafkaErrorParam, kafkaCallerParam],
    minParams: 1,
    maxParams: 1,
    returnType: kafkaReturnType
};

// Parameter definitions
final Parameter kafkaCallerParam = {
    'type: {typeName: "Caller", module: ["ballerina", "kafka"]},
    paramName: (),
    repeatability: ZERO_OR_ONE
};

final Parameter kafkaRecordsParam = {
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

final Parameter kafkaPayloadParam = {
    'type: ["array", "anydata", ()],
    paramName: (),
    repeatability: ZERO_OR_MORE
};

final Parameter kafkaErrorParam = {
    'type: {typeName: "Error", module: ["ballerina", "kafka"]},
    paramName: (),
    repeatability: ZERO_OR_ONE
};

final ReturnType kafkaReturnType = {
    'type: ["?", ["error"]]
};
