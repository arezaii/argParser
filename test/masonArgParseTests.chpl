use UnitTest;
use MasonArgParse;
use List;
use IO;

config const myArg = "nothing";
writeln("myArg=" + myArg);
// a short string opt with single value and expected # values supplied
proc testSingleStringShortOpt(test: borrowed Test) throws {
  var argList = ["progName","-n","twenty"];
  var parser = new argumentParser();
  var myStrArg = parser.addOption(name="StringOpt",
                                  opts=["-n","--stringVal"],
                                  numArgs=1);

  //make sure no value currently exists
  test.assertFalse(myStrArg.hasValue());
  //parse the options
  parser.parseArgs(argList);
  //make sure we now have a value
  test.assertTrue(myStrArg.hasValue());
  //ensure the value passed is correct
  test.assertEqual(myStrArg.value(),"twenty");
}

// a short string opt with single value with = and expected # values supplied
proc testSingleStringShortOptEquals(test: borrowed Test) throws {
  var argList = ["progName","-n=twenty"];
  var parser = new argumentParser();
  var myStrArg = parser.addOption(name="StringOpt",
                                  opts=["-n","--stringVal"],
                                  numArgs=1);

  //make sure no value currently exists
  test.assertFalse(myStrArg.hasValue());
  //parse the options
  parser.parseArgs(argList);
  //make sure we now have a value
  test.assertTrue(myStrArg.hasValue());
  //ensure the value passed is correct
  test.assertEqual(myStrArg.value(),"twenty");
}

// a short string opt with single value with = and extra # values supplied
proc testSingleStringShortOptEqualsExtra(test: borrowed Test) throws {
  var argList = ["progName","-n=twenty","thirty"];
  var parser = new argumentParser();
  var myStrArg = parser.addOption(name="StringOpt",
                                  opts=["-n","--stringVal"],
                                  numArgs=1);

  //make sure no value currently exists
  test.assertFalse(myStrArg.hasValue());
  //parse the options
  try {
    parser.parseArgs(argList);
  }catch ex: ArgumentError {
    test.assertTrue(true);
    stderr.writeln(ex.message());
    return;
  }
  test.assertTrue(false);
}

// test to catch undefined args entered at beginning of cmd string
proc testBadArgsAtFront(test: borrowed Test) throws {
  var argList = ["progName","badArg1","--BadFlag","-n=twenty"];
  var parser = new argumentParser();
  var myStrArg = parser.addOption(name="StringOpt",
                                  opts=["-n","--stringVal"],
                                  numArgs=1);

  //make sure no value currently exists
  test.assertFalse(myStrArg.hasValue());
  //parse the options
  try {
    parser.parseArgs(argList);
  }catch ex: ArgumentError {
    test.assertTrue(true);
    stderr.writeln(ex.message());
    return;
  }
  test.assertTrue(false);
}

// a short string opt with range of value with = and OK # values supplied
proc testMultiStringShortOptEqualsOK(test: borrowed Test) throws {
  var argList = ["progName","-n=twenty","thirty"];
  var parser = new argumentParser();
  var myStrArg = parser.addOption(name="StringOpt",
                                  opts=["-n","--stringVal"],
                                  numArgs=1..10,
                                  required=false,
                                  defaultValue=none);

  //make sure no value currently exists
  test.assertFalse(myStrArg.hasValue());
  //parse the options
  parser.parseArgs(argList);
  //make sure we now have a value
  test.assertTrue(myStrArg.hasValue());
  //ensure the value passed is correct
  test.assertEqual(new list(myStrArg.values()),
                   new list(["twenty","thirty"]));
}

UnitTest.main();