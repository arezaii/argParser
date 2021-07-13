use UnitTest;
use ArgParse;
use List;

//test that when a single int value is passed, a single value is stored
proc testSingleIntArg(test: borrowed Test) throws {
  var argList = ["progName","-i","20"];
  var parser = new argumentParser();
  var myIntArg = parser.addArgument(eltType=int,
				    name="IntArg1",
				    opts=["-i","--intVal"],
				    required=true,
				    numArgs=1,
				    defaultValue=0,
				    help="An integer value to pass as argument");
  
  //make sure default value was assigned
  test.assertTrue(myIntArg.hasValue());
  //parse the options
  parser.parseArgs(argList[1..]);
  //make sure we still have a value
  test.assertTrue(myIntArg.hasValue());
  //ensure the value passed is correct, and correct type
  test.assertEqual(myIntArg.getValue(),20);
}

//test that when a default specified without an argument, the default
//value is stored
proc testSingleIntArgDefault(test: borrowed Test) throws {
  var argList = ["progName"];
  var parser = new argumentParser();
  var myIntArg = parser.addArgument(eltType=int,
				    name="IntArg1",
				    opts=["-i","--intVal"],
				    required=false,
				    numArgs=1,
				    defaultValue=5,
				    help="An integer value to pass as argument");
  
  //make sure default value was assigned
  test.assertTrue(myIntArg.hasValue());
  test.assertEqual(myIntArg.getValue(),5);
  //parse the options
  parser.parseArgs(argList[1..]);
  //make sure we still have a value
  test.assertTrue(myIntArg.hasValue());
  //ensure the default value is assigned the proper value after parsing
  test.assertEqual(myIntArg.getValue(),5);
}

//test that when a default specified without an argument, the default
//value is stored
proc testSingleStringArgDefault(test: borrowed Test) throws {
  var argList = ["progName"];
  var parser = new argumentParser();
  var myIntArg = parser.addArgument(eltType=int,
				    name="IntArg1",
				    opts=["-i","--intVal"],
				    required=false,
				    numArgs=1,
				    defaultValue=5,
				    help="An integer value to pass as argument");
  
  //make sure default value was assigned
  test.assertTrue(myIntArg.hasValue());
  test.assertEqual(myIntArg.getValue(),5);
  //parse the options
  parser.parseArgs(argList[1..]);
  //make sure we still have a value
  test.assertTrue(myIntArg.hasValue());
  //ensure the default value is assigned the proper value after parsing
  test.assertEqual(myIntArg.getValue(),5);
}

//test that when an int option is specified multiple times
//that the final value is stored
proc testIntArgMultipleLastAssigned(test: borrowed Test) throws {
  var argList = ["progName","-i","20","-i","30","-i","40"];
  var parser = new argumentParser();
  var myIntArg = parser.addArgument(eltType=int,
				    name="IntArg1",
				    opts=["-i","--intVal"],
				    required=true,
				    defaultValue=0,
				    help="An integer value to pass as argument");
  


  //make sure default value assigned
  test.assertTrue(myIntArg.hasValue());

  parser.parseArgs(argList[1..]);
  test.assertTrue(myIntArg.hasValue());
  test.assertEqual(myIntArg.getValue(),40);
}

//test that mixing short and long option strings multiple times
//stores the final value
proc testIntArgShortLongLastAssigned(test: borrowed Test) throws {
  var argList = ["progName","-i","20","--intVal","30","--intVal","40"];
  var parser = new argumentParser();
  var myIntArg = parser.addArgument(eltType=int,
				    name="IntArg1",
				    opts=["-i","--intVal"],
				    required=true,
				    defaultValue=0,
				    help="An integer value to pass as argument");
  
  test.assertTrue(myIntArg.hasValue());

  parser.parseArgs(argList[1..]);
  test.assertTrue(myIntArg.hasValue());
  test.assertEqual(myIntArg.getValue(),40);
}

//test that int types don't allow alphanumeric values
proc testIntBadArgumentAlphaNum(test: borrowed Test) throws {
  var argList = ["progName","-i","20A"];
  var parser = new argumentParser();
  var myIntArg = parser.addArgument(eltType=int,
				    name="IntArg1",
				    opts=["-i","--intVal"],
				    required=true,
				    defaultValue=0,
				    help="An integer value to pass as argument");
  
  test.assertTrue(myIntArg.hasValue());
  try {
    parser.parseArgs(argList[1..]);
  } catch ex : ArgumentError {
      test.assertTrue(true);
      return;  
  }
  test.assertTrue(false);
}
 
//test that int types don't allow alpha values
proc testIntBadArgumentAlpha(test: borrowed Test) throws {
  var argList = ["progName","-i","A"];
  var parser = new argumentParser();
  var myIntArg = parser.addArgument(eltType=int,
				    name="IntArg1",
				    opts=["-i","--intVal"],
            numArgs=1,
				    required=true,
				    help="An integer value to pass as argument");
  
  //make sure no default value assigned, as we didn't provide one
  test.assertFalse(myIntArg.hasValue());
  try {
    parser.parseArgs(argList[1..]);
  } catch ex : ArgumentError {
      test.assertTrue(true);
      return;  
  }
  test.assertTrue(false);  
}

UnitTest.main();