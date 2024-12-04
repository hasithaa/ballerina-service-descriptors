// Examples : https://ballerina.io/learn/by-example/grpc-service-simple/


ModuleData grpcRule = {
    servicesRules: {
        "Service": {
            module: ["ballerina", "grpc"],
            remoteFunctions: [grpcRemoteFunctionRule, NO_REMOTE_FUNCTION_RULE],
            resourceFunctions: [NO_RESOURCE_FUNCTION_RULE],
            methodRule: []
        }
    }
};

final RemoteFunctionRule grpcRemoteFunctionRule = {
    functionName: (),
    // TODO: Add Wrapper based  the remote function signatures.
    signatures: [grpcRemoteFunctionSimpleSignature, grpcRemoteFunctionCallerSignature],
    repeatability: ONE_OR_MORE
};

// Example signatures

final FunctionSignature grpcRemoteFunctionSimpleSignature = {
    parameters: [grpcRequiredDataParam],
    minParams: 0,
    returnType: grpcRemoteFunctionSimpleReturnType
};

final Parameter grpcRequiredDataParam = {
    'type: [
        "1?",
        [
            ["stream", "anydata", grpcOptionalErrorOrNil],
            "anydata"
        ]
    ],
    paramName: (),
    repeatability: ONE_OR_MORE
};

final ReturnType grpcRemoteFunctionSimpleReturnType = {
    'type: [
        "1?",
        [
            ["stream", "anydata", grpcOptionalErrorOrNil],
            "anydata"
        ]
    ]
};

// If caller present, return type is subtype of error? including ().
final FunctionSignature grpcRemoteFunctionCallerSignature = {
    parameters: [grpcCallerParam, grpcOptionalDataParam],
    minParams: 1,
    returnType: grpcErrorReturn
};

final Parameter grpcCallerParam = {
    'type: {typeName: "Caller", module: ["ballerina", "grpc"]},
    paramName: (),
    repeatability: ONE
};

final Parameter grpcOptionalDataParam = {
    'type: grpcRequiredDataParam.'type,
    paramName: (),
    repeatability: ZERO_OR_MORE
};

final ReturnType grpcErrorReturn = {
    'type: grpcOptionalErrorOrNil
};

final Type grpcOptionalErrorOrNil = [
    "1?",
    [
        [
            "?",
            ["error"]
        ],
        "()"
    ]
];

// TODO: Add Wrapper based  the remote function signatures.

