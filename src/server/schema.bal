
map<json> empMap = 
  { 
        "1":    {"id": "1","name": "Kasun","age": "21","email":"Kasun@gmail.com"},
        "2":    {"id": "2","name": "Ruwan","age": "22","email":"ruwan@gmail.com"},
        "3":    {"id": "3","name": "Raveen","age": "24","email":"raveen@gmail.com"},
        "4":    {"id": "4","name": "Roshan","age": "25","email":"roshan@gmail.com"},
        "5":    {"id": "5","name": "singam","age": "23","email":"singam@gmail.com"},
        "6":    {"id": "6","name": "sandun","age": "23","email":"sandun@gmail.com"},
        "7":    {"id": "7","name": "nipuna","age": "26","email":"nipuna@gmail.com"},
        "8":    {"id": "8","name": "nuwan","age": "23","email":"nuwan@gmail.com"},
        "9":    {"id": "9","name": "shan","age": "27","email":null}
    
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

type GetEmployeeResolverParams record{|
    string ID;
|};

public type Resolver record{|
      function (GetEmployeeResolverParams) returns employee|error getEmployee;
|};

Resolver resolver = {
    getEmployee:function(GetEmployeeResolverParams r) returns employee|error{
            json tempEmp =  empMap[r.ID];
            employee|error emp = employee.constructFrom(tempEmp);
            if(emp is employee){
                return emp;
            }
            return emp;
        }
};


type EmployeeResolver record{|
    function (employee) returns string Id;
    function (employee) returns string Name;
    function (employee) returns string Age;
    function (employee) returns string Email;
    
|};

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



 





