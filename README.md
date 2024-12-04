# Ballerina Service Descriptors

## Goal

Most Ballerina service types are loosely validated using the Ballerina type system. Instead, they utilize a compiler plugin to validate the service descriptor at compile time due to reasons such as optional parameters, optional remote functions, and optional resource functions. The Service Object does not have sufficient language-level support to express these validation rules.

Bringing these validation rules to the language is not an easy task. Therefore, it was decided to validate the service type descriptor at compile time using a schema-based approach.

- Define a schema for the service descriptor.
- Define an annotation to attach the schema to the service type.
- Create a compiler plugin to validate the service descriptor annotation.
- Use this schema to generate low-code forms.

## Schema (WIP)

- A draft schema has been created and can be found in the [schema](schema/schema.bal).
- Example schemas:
  - [Kafka Service](schema/svc_ballerina_kafka.json)
  - [gRPC Service](schema/svc_ballerina_grpc.json)
  - [HTTP Service](schema/svc_ballerina_http.json)

## Validation Rules (WIP)

- Rules are validated in the order they are defined in the schema.
  - For remote functions, resource functions, and methods:
    - Rules are validated in the sequence they are listed.
    - If a rule is not matched:
      - If the `matchRule` is STRICT, it will not check for the next rule once a rule is not matched, resulting in a validation error.
      - If the `matchRule` is IGNORE, it will skip the unmatched rule and proceed to the next one.

# Annotation (WIP)

Module: `ballerina/lang.service`

Annotation:

```ballerina
@descriptor {
  typeRule: ...
}
```