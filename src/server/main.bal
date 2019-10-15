import wso2/graphql;

public function main() {

    json requestQuery = {
                "query":"Query{getEmployee(id:$ID){ name, age,email}}",
                "opertaionName":"Query",
                "variables":"{'ID':'1'}"
            };

    graphql:ParseSchema(Schema,resolver);
    json|error response = graphql:Execute(requestQuery);

}

