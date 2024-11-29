import ballerina/io;

public function main() returns error? {
    check io:fileWriteJson("../svcdesc/ballerina/kafka.json", kafkaRule.toJson());
}
