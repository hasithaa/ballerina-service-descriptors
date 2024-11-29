import ballerina/lang.regexp;

final ResourceFunctionRule ANY_RESOURCE_FUNCTION_RULE = {
    accessors: (),
    signature: (),
    paths: (),
    repeatability: ZERO_OR_MORE
};

final ResourceFunctionRule NO_RESOURCE_FUNCTION_RULE = {
    accessors: (),
    signature: (),
    paths: (),
    repeatability: ZERO
};

final RemoteFunctionRule ANY_REMOTE_FUNCTION_RULE = {
    functionName: (),
    signature: (),
    repeatability: ZERO_OR_MORE
};

final RemoteFunctionRule NO_REMOTE_FUNCTION_RULE = {
    functionName: (),
    signature: (),
    repeatability: ZERO
};

type Rule readonly & record {|
    map<ServiceTypeRule> services;
|};

# Represent Service Level Rules
type ServiceTypeRule readonly & record {|

    # Allowed Resource Functions
    # - If absent, any resource function is allowed.
    # - If present, the given resource functions must be allowed.
    ResourceFunctionRule[]? resourceFunctions = ();

    # Allowed Remote Functions
    # - If absent, any remote function is allowed.
    # - If present, the given remote functions must be allowed.
    RemoteFunctionRule[]? remoteFunctions = ();

    # Allowed Functions
    # - If absent, any function is allowed.
    # - If present, the given functions must be allowed.
    MethodRule[]? methodRule = ();

    # Allowed annotation attachments.
    # - If absent, any annotation attachment is allowed.
    # - If present, the given annotations must be attached to the function.
    AnnotationAttachment[]? annotationAttachments = ();
|};

# Represents a rule for a resource function in a service.
type ResourceFunctionRule readonly & record {|
    # Allowed accessors (e.g., GET).
    # - If absent, any accessor is allowed.
    # - If present, the given accessors must be allowed.
    ResourceAccessList? accessors;

    # Allowed resource paths.
    # - If absent, any path is allowed.
    # - If present, the given paths must be allowed.
    ResourcePathList? paths;

    # Function signature rules.
    # - If absent, any signature is allowed.
    # - If present, the given signatures must be allowed.
    FunctionSignatureList? signature;

    # Allowed annotation attachments.
    # - If absent, any annotation attachment is allowed.
    # - If present, the given annotations must be attached to the function.
    AnnotationAttachment[]? annotationAttachments = ();

    # Repeatability rule for the resource function.
    REPEATABILITY repeatability = ONE;
|};

# Represents a rule for a remote function.
type RemoteFunctionRule readonly & record {|
    // Bug: Can't import readonly record.
    *FunctionRule;

    # The function kind, always "REMOTE" for remote functions.
    string kind = "REMOTE";
|};

type MethodRule readonly & record {|
    *FunctionRule;

    # The function kind, always "METHOD" for method rules.
    string kind = "METHOD";
|};

# Represents a general rule for functions.
type FunctionRule record {|
    # The name of the function.
    # - If absent, any name is allowed.
    # - If a string, the given name must match exactly.
    # - If a RegExp, the given name must match the pattern.
    Name? functionName;

    # Allowed function signatures.
    # - If absent, any signature is allowed.
    # - If present, the given signatures must be allowed.
    FunctionSignatureList? signature;

    # Allowed annotation attachments.
    # - If absent, any annotation attachment is allowed.
    # - If present, the given annotations must be attached to the function.
    AnnotationAttachment[]? annotationAttachments = ();

    # Repeatability rule for the function.
    REPEATABILITY repeatability = ONE;
|};

# A list of function signatures, where each signature contains a parameter list and a return type.
type FunctionSignatureList readonly & [FunctionSignature, FunctionSignature...];

type FunctionSignature readonly & [ParameterList, ReturnType];

# A list of parameters for a function.
type ParameterList readonly & [Parameter...];

# Represents a return type, which can be a built-in type or a user-defined type.
type ReturnType readonly & record {|
    # The type of the parameter.
    Type 'type;

    # Allowed annotation attachments for the parameter.
    # - If absent, any annotation attachment is allowed.
    # - If present, the given annotations must be attached to the parameter.
    AnnotationAttachment[]? annotationAttachments = ();
|};

# Represents a parameter in a function.
type Parameter readonly & record {|
    # The type of the parameter.
    Type 'type;

    # The name of the parameter.
    # - If absent, any name is allowed.
    # - If a string, the given name must match exactly.
    # - If a RegExp, the given name must match the pattern.
    Name paramName = ();

    # Allowed annotation attachments for the parameter.
    # - If absent, any annotation attachment is allowed.
    # - If present, the given annotations must be attached to the parameter.
    AnnotationAttachment[]? annotationAttachments = ();

    # Repeatability rule for the parameter.
    REPEATABILITY repeatability = ONE;
|};

# Represents an annotation attachment.
type AnnotationAttachment readonly & record {|
    # The name of the annotation.
    string annotationName;

    # The module of the annotation. If absent, the current module is assumed.
    ModuleReference? module = ();

    # Repeatability rule for the annotation.
    REPEATABILITY repeatability = ONE;
|};

// Had to add () to make it work.
type Type ()|BuiltInType|TypeReference|UnionType|IntersectionType|MapType|ArrayType|TupleType|StreamType|TableType;

type BuiltInType "string"|"int"|"boolean"|"float"|"decimal"|"()"|"error"|"xml"|"json"|"readonly"|"any"|"anydata";

// JBallerina Bug: readonly & ["|", Type...] is not allowed.
type UnionType readonly & ["|", [Type, Type...]];

type IntersectionType readonly & ["&", Type, Type];

type MapType readonly & ["map", Type];

type ArrayType readonly & ["array", Type, int|()];

# First element indicates the tuple type, second element is fixed type, third element is the rest type.
type TupleType readonly & ["tuple", Type[], Type];

# First element indicates the stream type, second element is the type of the stream, third element is the rest type.
type StreamType readonly & ["stream", Type, Type|()];

type TableType readonly & ["table", Type, string[]];

# Represents a reference to a user-defined type.
# - Built-in types are represented as strings.
# - User-defined types are represented as `TypeReference`.
type TypeReference readonly & record {|
    # The name of the type.
    string typeName;

    # The module of the type. If absent, the current module is assumed.
    ModuleReference? module = ();
|};

type Name string|regexp:RegExp?;

# Represents a module as a tuple of organization and module names.
type ModuleReference [string, string];

# Represents a list of allowed method accessors.
type ResourceAccessList [string, string...]|["GET", "get"];

# Represents a list of allowed resource paths.
type ResourcePathList [ResourcePath, ResourcePath...];

# Represents a resource path, which can be a series of segments or a single `.`.
type ResourcePath [ResourcePathSegment, ResourcePathSegment...]|".";

# Represents a segment of a resource path.
type ResourcePathSegment string|record {|
    # The type of the path segment.
    # - If absent, any type is allowed.
    # - If present, the given type must match.
    SimpleType? segmentType = ();

    # The name of the path segment.
    # - If absent, any name is allowed.
    # - If present, the given name must match.
    string? segmentName = ();
|};

# Represents a set of built-in simple types.
type SimpleType "string"|"int"|"boolean"|"float"|"decimal";

# Defines repeatability options for elements.
enum REPEATABILITY {
    ZERO = "0",
    ONE = "1",
    ONE_OR_MORE = "+",
    ZERO_OR_MORE = "*",
    ZERO_OR_ONE = "?"
}
