# GraphQL-Ballerina Server Library Design

This is a sample design for GraphQL-Ballerina server library. Specially here we focus on how to defining a Schema and Resolvers using ballerina language.

## Example

We use following example to describe how to create a schema and resolvers to access these data through a graphql server.

    //data set
    map<json> empMap = 
        { 
            "1":    {"id": "1","name": "Kasun","age": "21","email":"Kasun@gmail.com"},
            "2":    {"id": "2","name": "Ruwan","age": "22","email":"ruwan@gmail.com"},
            "3":    {"id": "3","name": "Raveen","age": "24","email":"raveen@gmail.com"},
        };

    public const string Schema = "schema {
                                        query: Query
                                    }
                                    
                                    type Query {
                                        getEmployee(id: ID!):Employee!
                                    }
                                    
                                    type Employee {
                                        id: ID!
                                        name: String!
                                        age: String!
                                        email: String
                                    }";


    type employee record{|
            string ID;
            string NameField;
            string AgeField;
            string EmailField;
        |};

    type GeyEmployeeResolverParams record{
            string ID;
        };

    type Resolver record{
            function (GetEmployeeResolverParams) returns employee|error getEmployee;
        };

    Resolver resolver = {
            getEmployee:function(GetEmployeeResolverParams rp) returns employee|error{
                    json tempEmp =  empMap[rp.ID];
                    employee|error emp = employee.constructFrom(tempEmp);
                    if(emp is employee){
                        return emp;
                    }
                    return emp;
                }
        };



    type EmployeeResolver record{
            function (employee) returns string Id;
            function (employee) returns string Name;
            function (employee) returns string Age;
            function (employee) returns string Email;
        
        };

    EmployeeResolver employeeResolver = {
        
            Id:function(employee emp) returns string {
                            return emp.ID;
                        },

            Name:function(employee emp) returns string {
                            return emp.NameField;
                        },

            Age:function(employee emp) returns string {
                            return emp.AgeField;
                        },
                
            Email:function(employee emp) returns string {
                            return emp.EmailField;
                        }

        };

 


## Schema

In this design, Schema is taken as a string by the graphql server. Schema should be defined using graphql Schema Definition Language(SDL) which is specified in GraphQL specification.

Sample schema for above data set:

    public const string Schema = "schema {
                                        query: Query
                                    }
                                    
                                    type Query {
                                        getEmployee(id: ID!):Employee!
                                    }
                                    
                                    type Employee {
                                        id: ID!
                                        name: String!
                                        age: String!
                                        email: String
                                    }";



## Resolvers

Resolvers are functions that include the logic for retriving data. Every field of schema should be backed by a resolver function and that function name should be matched the schema's field name in a non-case-sensitive way.

Sample resolvers:

    type employee record{|
        string ID;
        string NameField;
        string AgeField;
        string EmailField;
    |};

    type GetEmployeeResolverParams record{
        string ID;
    };

    type Resolver record{
        function (GetEmployeeResolverParams) returns employee|error getEmployee;
    };

    Resolver resolver = {
        getEmployee:function(GetEmployeeResolverParams rp) returns employee|error{
                json tempEmp =  empMap[rp.ID];
                employee|error emp = employee.constructFrom(tempEmp);
                if(emp is employee){
                    return emp;
                }
                return emp;
            }
    };


Here we have defined two records except Resolver function. 
- The ***employee***  record is for indicate the return type of resolver function and Its fields should be defined according to your database.
- The ***GetEmployeeResolverParams*** is for declare the parameters of **getEmployee** resolver function.

According to the above schema, when the **getEmployee** field of type Query(in Schema) is called, *getEmployee* function will be executed. The function will return **employee** type record.

Also,rest of the resolver functions(sub resolver functions) will be executed according to the query that client sent. Functions will take the return value of ***getEmployee*** function as its input. Sample code is given below.


    type EmployeeResolver record{
        function (employee) returns string Id;
        function (employee) returns string Name;
        function (employee) returns string Age;
        function (employee) returns string Email;
        
    };

    EmployeeResolver employeeResolver = {
        
                Id:function(employee emp) returns string {
                            return emp.ID;
                            },

                Name:function(employee emp) returns string {
                            return emp.NameField;
                            },

                Age:function(employee emp) returns string {
                            return emp.AgeField;
                            },
                
                Email:function(employee emp) returns string {
                            return emp.EmailField;
                            }

            };


Main.bal

This is the main class of client. First, client should import the graphql-ballerina library.Set the schema and resolver using ParseSchema() function.Then, by using Execute() function which returns server response, client can send a query to the server. (***ParseSchema*** and ***Execute*** functions are provided by the graphql-ballerina library.)

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
