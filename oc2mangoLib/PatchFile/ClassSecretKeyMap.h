
#import <Foundation/Foundation.h>

static NSString * jsonEncryptString = @"{\"ORNode\": {\"m\": {\"withSemicolon\": \"0\"}, \"n\": \"0\", \"f\": [\"withSemicolon\"]}, \"ORTypeNode\": {\"m\": {\"type\": \"0\", \"name\": \"1\", \"modifier\": \"2\"}, \"n\": \"1\", \"f\": [\"type\", \"name\", \"modifier\"]}, \"ORVariableNode\": {\"m\": {\"isBlock\": \"0\", \"ptCount\": \"1\", \"varname\": \"2\"}, \"n\": \"2\", \"f\": [\"isBlock\", \"ptCount\", \"varname\"]}, \"ORDeclaratorNode\": {\"m\": {\"type\": \"0\", \"var\": \"1\"}, \"n\": \"3\", \"f\": [\"type\", \"var\"]}, \"ORFunctionSignNode\": {\"m\": {\"isMultiArgs\": \"0\", \"returnNode\": \"1\", \"declarators\": \"2\", \"isBlock\": \"3\", \"ptCount\": \"4\", \"varname\": \"5\"}, \"n\": \"4\", \"f\": [\"isMultiArgs\", \"returnNode\", \"declarators\", \"isBlock\", \"ptCount\", \"varname\"]}, \"ORCArrayVariable\": {\"m\": {\"capacity\": \"0\", \"isBlock\": \"1\", \"ptCount\": \"2\", \"varname\": \"3\"}, \"n\": \"5\", \"f\": [\"capacity\", \"isBlock\", \"ptCount\", \"varname\"]}, \"ORBlockNode\": {\"m\": {\"statements\": \"0\"}, \"n\": \"6\", \"f\": [\"statements\"]}, \"ORValueExpression\": {\"m\": {\"value_type\": \"0\", \"value\": \"1\"}, \"n\": \"7\", \"f\": [\"value_type\", \"value\"]}, \"ORIntegerValue\": {\"m\": {\"value\": \"0\"}, \"n\": \"8\", \"f\": [\"value\"]}, \"ORUIntegerValue\": {\"m\": {\"value\": \"0\"}, \"n\": \"9\", \"f\": [\"value\"]}, \"ORDoubleValue\": {\"m\": {\"value\": \"0\"}, \"n\": \"10\", \"f\": [\"value\"]}, \"ORBoolValue\": {\"m\": {\"value\": \"0\"}, \"n\": \"11\", \"f\": [\"value\"]}, \"ORMethodCall\": {\"m\": {\"methodOperator\": \"0\", \"isAssignedValue\": \"1\", \"caller\": \"2\", \"names\": \"3\", \"values\": \"4\"}, \"n\": \"12\", \"f\": [\"methodOperator\", \"isAssignedValue\", \"caller\", \"names\", \"values\"]}, \"ORCFuncCall\": {\"m\": {\"caller\": \"0\", \"expressions\": \"1\"}, \"n\": \"13\", \"f\": [\"caller\", \"expressions\"]}, \"ORFunctionImp\": {\"m\": {\"declare\": \"0\", \"scopeImp\": \"1\"}, \"n\": \"14\", \"f\": [\"declare\", \"scopeImp\"]}, \"ORSubscriptExpression\": {\"m\": {\"caller\": \"0\", \"keyExp\": \"1\"}, \"n\": \"15\", \"f\": [\"caller\", \"keyExp\"]}, \"ORAssignExpression\": {\"m\": {\"assignType\": \"0\", \"value\": \"1\", \"expression\": \"2\"}, \"n\": \"16\", \"f\": [\"assignType\", \"value\", \"expression\"]}, \"ORInitDeclaratorNode\": {\"m\": {\"declarator\": \"0\", \"expression\": \"1\"}, \"n\": \"17\", \"f\": [\"declarator\", \"expression\"]}, \"ORUnaryExpression\": {\"m\": {\"operatorType\": \"0\", \"value\": \"1\"}, \"n\": \"18\", \"f\": [\"operatorType\", \"value\"]}, \"ORBinaryExpression\": {\"m\": {\"operatorType\": \"0\", \"left\": \"1\", \"right\": \"2\"}, \"n\": \"19\", \"f\": [\"operatorType\", \"left\", \"right\"]}, \"ORTernaryExpression\": {\"m\": {\"expression\": \"0\", \"values\": \"1\"}, \"n\": \"20\", \"f\": [\"expression\", \"values\"]}, \"ORIfStatement\": {\"m\": {\"condition\": \"0\", \"last\": \"1\", \"scopeImp\": \"2\"}, \"n\": \"21\", \"f\": [\"condition\", \"last\", \"scopeImp\"]}, \"ORWhileStatement\": {\"m\": {\"condition\": \"0\", \"scopeImp\": \"1\"}, \"n\": \"22\", \"f\": [\"condition\", \"scopeImp\"]}, \"ORDoWhileStatement\": {\"m\": {\"condition\": \"0\", \"scopeImp\": \"1\"}, \"n\": \"23\", \"f\": [\"condition\", \"scopeImp\"]}, \"ORCaseStatement\": {\"m\": {\"value\": \"0\", \"scopeImp\": \"1\"}, \"n\": \"24\", \"f\": [\"value\", \"scopeImp\"]}, \"ORSwitchStatement\": {\"m\": {\"value\": \"0\", \"cases\": \"1\", \"scopeImp\": \"2\"}, \"n\": \"25\", \"f\": [\"value\", \"cases\", \"scopeImp\"]}, \"ORForStatement\": {\"m\": {\"varExpressions\": \"0\", \"condition\": \"1\", \"expressions\": \"2\", \"scopeImp\": \"3\"}, \"n\": \"26\", \"f\": [\"varExpressions\", \"condition\", \"expressions\", \"scopeImp\"]}, \"ORForInStatement\": {\"m\": {\"expression\": \"0\", \"value\": \"1\", \"scopeImp\": \"2\"}, \"n\": \"27\", \"f\": [\"expression\", \"value\", \"scopeImp\"]}, \"ORControlStatement\": {\"m\": {\"type\": \"0\", \"expression\": \"1\"}, \"n\": \"28\", \"f\": [\"type\", \"expression\"]}, \"ORPropertyDeclare\": {\"m\": {\"keywords\": \"1\", \"var\": \"2\"}, \"n\": \"29\", \"f\": [\"keywords\", \"var\"]}, \"ORMethodDeclare\": {\"m\": {\"isClassMethod\": \"0\", \"returnType\": \"1\", \"methodNames\": \"2\", \"parameterTypes\": \"3\", \"parameterNames\": \"4\"}, \"n\": \"30\", \"f\": [\"isClassMethod\", \"returnType\", \"methodNames\", \"parameterTypes\", \"parameterNames\"]}, \"ORMethodImplementation\": {\"m\": {\"declare\": \"0\", \"scopeImp\": \"1\"}, \"n\": \"31\", \"f\": [\"declare\", \"scopeImp\"]}, \"ORClass\": {\"m\": {\"className\": \"0\", \"superClassName\": \"1\", \"protocols\": \"2\", \"properties\": \"3\", \"privateVariables\": \"4\", \"methods\": \"5\"}, \"n\": \"32\", \"f\": [\"className\", \"superClassName\", \"protocols\", \"properties\", \"privateVariables\", \"methods\"]}, \"ORProtocol\": {\"m\": {\"protcolName\": \"0\", \"protocols\": \"1\", \"properties\": \"2\", \"methods\": \"3\"}, \"n\": \"33\", \"f\": [\"protcolName\", \"protocols\", \"properties\", \"methods\"]}, \"ORStructExpressoin\": {\"m\": {\"sturctName\": \"0\", \"fields\": \"1\"}, \"n\": \"34\", \"f\": [\"sturctName\", \"fields\"]}, \"ORUnionExpressoin\": {\"m\": {\"unionName\": \"0\", \"fields\": \"1\"}, \"n\": \"35\", \"f\": [\"unionName\", \"fields\"]}, \"OREnumExpressoin\": {\"m\": {\"valueType\": \"0\", \"enumName\": \"1\", \"fields\": \"2\"}, \"n\": \"36\", \"f\": [\"valueType\", \"enumName\", \"fields\"]}, \"ORTypedefExpressoin\": {\"m\": {\"expression\": \"0\", \"typeNewName\": \"1\"}, \"n\": \"37\", \"f\": [\"expression\", \"typeNewName\"]}}";
static NSString * jsonDecryptString = @"{\"0\": {\"m\": {\"0\": \"withSemicolon\"}, \"c\": \"ORNode\", \"f\": [\"0\"]}, \"1\": {\"m\": {\"0\": \"type\", \"1\": \"name\", \"2\": \"modifier\"}, \"c\": \"ORTypeNode\", \"f\": [\"0\", \"1\", \"2\"]}, \"2\": {\"m\": {\"0\": \"isBlock\", \"1\": \"ptCount\", \"2\": \"varname\"}, \"c\": \"ORVariableNode\", \"f\": [\"0\", \"1\", \"2\"]}, \"3\": {\"m\": {\"0\": \"type\", \"1\": \"var\"}, \"c\": \"ORDeclaratorNode\", \"f\": [\"0\", \"1\"]}, \"4\": {\"m\": {\"0\": \"isMultiArgs\", \"1\": \"returnNode\", \"2\": \"declarators\", \"3\": \"isBlock\", \"4\": \"ptCount\", \"5\": \"varname\"}, \"c\": \"ORFunctionSignNode\", \"f\": [\"0\", \"1\", \"2\", \"3\", \"4\", \"5\"]}, \"5\": {\"m\": {\"0\": \"capacity\", \"1\": \"isBlock\", \"2\": \"ptCount\", \"3\": \"varname\"}, \"c\": \"ORCArrayVariable\", \"f\": [\"0\", \"1\", \"2\", \"3\"]}, \"6\": {\"m\": {\"0\": \"statements\"}, \"c\": \"ORBlockNode\", \"f\": [\"0\"]}, \"7\": {\"m\": {\"0\": \"value_type\", \"1\": \"value\"}, \"c\": \"ORValueExpression\", \"f\": [\"0\", \"1\"]}, \"8\": {\"m\": {\"0\": \"value\"}, \"c\": \"ORIntegerValue\", \"f\": [\"0\"]}, \"9\": {\"m\": {\"0\": \"value\"}, \"c\": \"ORUIntegerValue\", \"f\": [\"0\"]}, \"10\": {\"m\": {\"0\": \"value\"}, \"c\": \"ORDoubleValue\", \"f\": [\"0\"]}, \"11\": {\"m\": {\"0\": \"value\"}, \"c\": \"ORBoolValue\", \"f\": [\"0\"]}, \"12\": {\"m\": {\"0\": \"methodOperator\", \"1\": \"isAssignedValue\", \"2\": \"caller\", \"3\": \"names\", \"4\": \"values\"}, \"c\": \"ORMethodCall\", \"f\": [\"0\", \"1\", \"2\", \"3\", \"4\"]}, \"13\": {\"m\": {\"0\": \"caller\", \"1\": \"expressions\"}, \"c\": \"ORCFuncCall\", \"f\": [\"0\", \"1\"]}, \"14\": {\"m\": {\"0\": \"declare\", \"1\": \"scopeImp\"}, \"c\": \"ORFunctionImp\", \"f\": [\"0\", \"1\"]}, \"15\": {\"m\": {\"0\": \"caller\", \"1\": \"keyExp\"}, \"c\": \"ORSubscriptExpression\", \"f\": [\"0\", \"1\"]}, \"16\": {\"m\": {\"0\": \"assignType\", \"1\": \"value\", \"2\": \"expression\"}, \"c\": \"ORAssignExpression\", \"f\": [\"0\", \"1\", \"2\"]}, \"17\": {\"m\": {\"0\": \"declarator\", \"1\": \"expression\"}, \"c\": \"ORInitDeclaratorNode\", \"f\": [\"0\", \"1\"]}, \"18\": {\"m\": {\"0\": \"operatorType\", \"1\": \"value\"}, \"c\": \"ORUnaryExpression\", \"f\": [\"0\", \"1\"]}, \"19\": {\"m\": {\"0\": \"operatorType\", \"1\": \"left\", \"2\": \"right\"}, \"c\": \"ORBinaryExpression\", \"f\": [\"0\", \"1\", \"2\"]}, \"20\": {\"m\": {\"0\": \"expression\", \"1\": \"values\"}, \"c\": \"ORTernaryExpression\", \"f\": [\"0\", \"1\"]}, \"21\": {\"m\": {\"0\": \"condition\", \"1\": \"last\", \"2\": \"scopeImp\"}, \"c\": \"ORIfStatement\", \"f\": [\"0\", \"1\", \"2\"]}, \"22\": {\"m\": {\"0\": \"condition\", \"1\": \"scopeImp\"}, \"c\": \"ORWhileStatement\", \"f\": [\"0\", \"1\"]}, \"23\": {\"m\": {\"0\": \"condition\", \"1\": \"scopeImp\"}, \"c\": \"ORDoWhileStatement\", \"f\": [\"0\", \"1\"]}, \"24\": {\"m\": {\"0\": \"value\", \"1\": \"scopeImp\"}, \"c\": \"ORCaseStatement\", \"f\": [\"0\", \"1\"]}, \"25\": {\"m\": {\"0\": \"value\", \"1\": \"cases\", \"2\": \"scopeImp\"}, \"c\": \"ORSwitchStatement\", \"f\": [\"0\", \"1\", \"2\"]}, \"26\": {\"m\": {\"0\": \"varExpressions\", \"1\": \"condition\", \"2\": \"expressions\", \"3\": \"scopeImp\"}, \"c\": \"ORForStatement\", \"f\": [\"0\", \"1\", \"2\", \"3\"]}, \"27\": {\"m\": {\"0\": \"expression\", \"1\": \"value\", \"2\": \"scopeImp\"}, \"c\": \"ORForInStatement\", \"f\": [\"0\", \"1\", \"2\"]}, \"28\": {\"m\": {\"0\": \"type\", \"1\": \"expression\"}, \"c\": \"ORControlStatement\", \"f\": [\"0\", \"1\"]}, \"29\": {\"m\": {\"1\": \"keywords\", \"2\": \"var\"}, \"c\": \"ORPropertyDeclare\", \"f\": [\"1\", \"2\"]}, \"30\": {\"m\": {\"0\": \"isClassMethod\", \"1\": \"returnType\", \"2\": \"methodNames\", \"3\": \"parameterTypes\", \"4\": \"parameterNames\"}, \"c\": \"ORMethodDeclare\", \"f\": [\"0\", \"1\", \"2\", \"3\", \"4\"]}, \"31\": {\"m\": {\"0\": \"declare\", \"1\": \"scopeImp\"}, \"c\": \"ORMethodImplementation\", \"f\": [\"0\", \"1\"]}, \"32\": {\"m\": {\"0\": \"className\", \"1\": \"superClassName\", \"2\": \"protocols\", \"3\": \"properties\", \"4\": \"privateVariables\", \"5\": \"methods\"}, \"c\": \"ORClass\", \"f\": [\"0\", \"1\", \"2\", \"3\", \"4\", \"5\"]}, \"33\": {\"m\": {\"0\": \"protcolName\", \"1\": \"protocols\", \"2\": \"properties\", \"3\": \"methods\"}, \"c\": \"ORProtocol\", \"f\": [\"0\", \"1\", \"2\", \"3\"]}, \"34\": {\"m\": {\"0\": \"sturctName\", \"1\": \"fields\"}, \"c\": \"ORStructExpressoin\", \"f\": [\"0\", \"1\"]}, \"35\": {\"m\": {\"0\": \"unionName\", \"1\": \"fields\"}, \"c\": \"ORUnionExpressoin\", \"f\": [\"0\", \"1\"]}, \"36\": {\"m\": {\"0\": \"valueType\", \"1\": \"enumName\", \"2\": \"fields\"}, \"c\": \"OREnumExpressoin\", \"f\": [\"0\", \"1\", \"2\"]}, \"37\": {\"m\": {\"0\": \"expression\", \"1\": \"typeNewName\"}, \"c\": \"ORTypedefExpressoin\", \"f\": [\"0\", \"1\"]}}";
