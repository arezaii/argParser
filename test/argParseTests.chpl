use UnitTest;
use ArgParse;
use List;

proc testSingleIntArg(test: borrowed Test) throws {
  var argList = ["progName","-i","20"];
  var parser = new argumentParser();
  var defaultVal = 0;
  var myIntArg = parser.addArgument(eltType=int,
				    name="IntArg1",
				    opts=["-i","--intVal"],
				    required=true,
				    numArgs=1,
				    defaultValue=defaultVal,
				    help="An integer value to pass as argument");
  
  test.assertFalse(myIntArg.hasValue());

  parser.parseArgs(argList[1..]);
  test.assertTrue(myIntArg.hasValue());
  test.assertEqual(myIntArg.getValue(),20);
}

proc testIntArgMultipleLastAssigned(test: borrowed Test) throws {
  var argList = ["progName","-i","20","-i","30","-i","40"];
  var parser = new argumentParser();
  var myIntArg = parser.addArgument(eltType=int,
				    name="IntArg1",
				    opts=["-i","--intVal"],
				    required=true,
				    defaultValue=0,
				    help="An integer value to pass as argument");
  
  test.assertFalse(myIntArg.hasValue());

  parser.parseArgs(argList[1..]);
  test.assertTrue(myIntArg.hasValue());
  test.assertEqual(myIntArg.getValue(),40);
}

proc testIntArgShortLongLastAssigned(test: borrowed Test) throws {
  var argList = ["progName","-i","20","--intVal","30","--intVal","40"];
  var parser = new argumentParser();
  var myIntArg = parser.addArgument(eltType=int,
				    name="IntArg1",
				    opts=["-i","--intVal"],
				    required=true,
				    defaultValue=0,
				    help="An integer value to pass as argument");
  
  test.assertFalse(myIntArg.hasValue());

  parser.parseArgs(argList[1..]);
  test.assertTrue(myIntArg.hasValue());
  test.assertEqual(myIntArg.getValue(),40);
}

proc testIntBadArgumentAlphaNum(test: borrowed Test) throws {
  var argList = ["progName","-i","20A"];
  var parser = new argumentParser();
  var myIntArg = parser.addArgument(eltType=int,
				    name="IntArg1",
				    opts=["-i","--intVal"],
				    required=true,
				    defaultValue=0,
				    help="An integer value to pass as argument");
  
  test.assertFalse(myIntArg.hasValue());
  try {
    parser.parseArgs(argList[1..]);
  } catch ex : ArgumentError {
      test.assertTrue(true);
  }
  test.assertTrue(false);
  // test.assertThrows(parser.parseArgs(argList[1..]), ArgumentError);
}

proc testIntBadArgumentAlpha(test: borrowed Test) throws {
  var argList = ["progName","-i","A"];
  var parser = new argumentParser();
  var myIntArg = parser.addArgument(eltType=int,
				    name="IntArg1",
				    opts=["-i","--intVal"],
				    required=true,
				    defaultValue=0,
				    help="An integer value to pass as argument");
  
  test.assertFalse(myIntArg.hasValue());
  // test.assertThrows(parser.parseArgs(argList[1..]), ArgumentError);
}

proc test2(test: borrowed Test) throws {
  //var argList = ["progName","--flag1","flag1Val1","flag1Val2","-s","shortOpt1"];
  //var parser = new argumentParser();
  //var result = parser.parseArgs(argList);
  //test.assertEqual(argList, result);
}

proc test3(test: borrowed Test) throws {
  //var argList = new list(["progName","--flag1","flag1Val1","flag1Val2","-s","shortOpt1"]);
  //var parser = new argumentParser();
  //var result = parser.parseArgs(argList);
  //test.assertEqual(argList, result);
}

UnitTest.main();