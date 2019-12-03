import wso2/graphql;

public function main() {

    graphql:ResolverFunctions resolverFunctions = new ResolverFunctions();

    json requestQuery = {
                "query":"Query{getEmployee(id:$ID){ name, age,email}}",
                "opertaionName":"Query",
                "variables":"{'ID':'1'}"
            };

    graphql:ParseSchema(Schema,resolverFunctions);
    
    json|error response = graphql:Execute(requestQuery);

}

