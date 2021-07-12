

/* Documentation for argParse */
public module ArgParse {
  
  private use List;
  private use Map;

  if chpl_warnUnstable then
    compilerWarning("Argument Parser is unstable: see github.com/chapel-lang/chapel/issue #...");
  
//enum ArgCounts { oneOrMore = -1, zeroOrMore = -2 } 

class ArgumentError : Error {
  var msg:string;
  proc init(msg:string) {
    this.msg = msg;
  }
  override proc message() {
    return msg;
  }
}

// indicates a result of argument parsing
class Argument {
  var present: bool=false;
  var values: list(string);
  var myType: string="string";
  proc getEltType() {
    return myType;
  }
  
  proc getValue(){
    //return values.first:eltType;
  }
  proc getValues(){
    // return values:list(eltType);
  }
  proc hasValue(){
    return !this.values.isEmpty() && this.present;
  }
}

 class TypedArgument : Argument{
   type eltType;
   var myType:string = eltType:string;

   override proc getEltType() {
     return this.eltType:string;
   }
   
   override proc getValue() {
     var rtn:eltType;
     try!{
       rtn = this.values.first():eltType;
     }
     return rtn;
   }
   override proc getValues() {
     var rtn = new list(this.eltType);
     try!{
       rtn.extend(this.values:list(eltType));
     }
     return rtn;
   }
 }


/* class ArgumentHandler { */
/*   proc noteMatch(startIndex: int) { */
/*     this.present = true; */
/*     this.startIndex = startIndex; */
/*     } */
/*   // consumes matching arguments starting at args[i] */
/*   // possibly by appending some to otherArgs */
/*   // returns the number of arguments consumed */
/*   proc consume(const args: list(string), */
/*                i: int, */
/*                ref result:map(string, Argument), */
/*                out nconsumed:int) throws { */
/*     return 0; */
/*   } */
/* } */


 
 class Action {
   var name:string;
   var numOpts:int;
   var opts:[0..numOpts-1] string;
   var required:bool;
   var help:string;
   var numDefaults:int;
   var defaultValue:[0..numDefaults-1] string;
   var numArgs:range;

   proc getEltType(){

   }
 }
 
 class TypedAction: Action {
   type eltType;
   override proc getEltType(){
     return eltType;
   }
}

 record argumentParser {
  var result: map(string, shared Argument);
  var actions: map(string, owned Action);
  var options: map(string, string);
  var unknownArgs: list(string);
  var missingArgs: list(string);
  
  //this is not elegant...probably bug prone....needs rework
  proc consumeArgs(arguments:[?argsD]string, inout pos:int){
    compilerAssert(argsD.rank==1, "consumeArgs requires 1D array");
    if pos == argsD.high then return;
    while pos <= argsD.high {
      if arguments[pos].startsWith("-") then {
	writeln("found entry " + arguments[pos]);
	if !options.contains(arguments[pos]) then {
	  //should check positional arguments list when we have one
	  this.unknownArgs.append(arguments[pos]);
	  pos+=1;
	  continue;
	}
	// an argument we have an opt flag for!
	// get the name, use that to get the action
	var argName = options.getValue(arguments[pos]);
	var argAction = actions.getBorrowed(argName);
	var argContainer = this.result.getBorrowed(argName);
	var j = 0;
	if !argAction.numArgs.hasHighBound() then {
	  pos += 1;
	  argContainer.values.clear();
	  while pos < argsD.high && !arguments[pos].startsWith("-") {
	    /* if argContainer.getEltType().startsWith("int") && !isInt(arguments[pos]){ */
	    /*   this.unknownArgs.append(arguments[pos]); */
	    /*   pos+=1; */
	    /*   continue; */
	    /* } */
	    argContainer.values.append(arguments[pos]);
	    argContainer.present=true;
	    pos += 1;
       	    writeln("position updated to: " + pos:string);
	  }
	}else if argAction.numArgs.low == argAction.numArgs.high then {
	  writeln("Begin parsing " + argAction.name);
	  var j = 0;
	  pos += 1;
	  argContainer.values.clear();
	  while j <= argAction.numArgs.high && pos <= argsD.high {
	    if arguments[pos].startsWith("-") then
	      //expected argAction.numArgs but only got j argument values
	      this.missingArgs.append(argAction.name);
	    /* if argContainer.getEltType().startsWith("int") && !isInt(arguments[pos]){ */
	    /*   this.unknownArgs.append(arguments[pos]); */
	    /*   pos+=1; */
	    /*   j+=1; */
	    /*   continue; */
	    /* } */
	    this.result.getBorrowed(argName).values.append(arguments[pos]);
	    this.result.getBorrowed(argName).present=true;
  	    j += 1;
	    pos += 1;
       	    writeln("position updated to: " + pos:string);
	  }
	  if j < argAction.numArgs.high then
	    //expected argAction.numArgs but only got j argument values
	    this.missingArgs.append(argAction.name);
	}else if argAction.numArgs.low < argAction.numArgs.high then {
	  pos += 1;
	  var j = 0;
	  writeln("Begin parsing " + argAction.name);
	  while j <= argAction.numArgs.low && !arguments[pos].startsWith("-") {
	    /* if argContainer.getEltType().startsWith("int") && !isInt(arguments[pos]){ */
	    /*   this.unknownArgs.append(arguments[pos]); */
	    /*   pos+=1; */
	    /*   j+=1; */
	    /*   continue; */
	    /* } */
	    argContainer.values[0]=arguments[pos];
	    argContainer.present=true;
	    j += 1;
	    pos += 1;
	  }
	  if j == argAction.numArgs.low then {
	    //check if there are remaining arguments to add, up to numArgs.high, or we hit another flag
	    while j <= argAction.numArgs.high && !arguments[pos].startsWith("-") {
	    /*   if argContainer.getEltType().startsWith("int") && !isInt(arguments[pos]){ */
	    /*   this.unknownArgs.append(arguments[pos]); */
	    /*   pos+=1; */
	    /*   j+=1; */
	    /*   continue; */
	    /* } */
	      argContainer.values[0]=arguments[pos];
	      argContainer.present=true;
	      j += 1;
	      pos += 1;
	    }
	  }else{
	    this.missingArgs.append(argAction.name);
	  }
	  //this.result.getBorrowed(argName).values[0]=arguments[pos];
	  //this.result.getBorrowed(argName).present=true;
	  //pos += 1;
          writeln("position updated to: " + pos:string);
	}
	/* else if argAction.numArgs == 0 then { */
	/*   writeln("Begin parsing " + argAction.name); */
	/*   this.result.getBorrowed(argName).values[0]="true"; */
	/*   this.result.getBorrowed(argName).present=true; */
	/*   pos+=1; */
	/* } */
      }else{
	writeln("Unknown Argument found at pos " + pos:string+ " " + arguments[pos]);
	this.unknownArgs.append(arguments[pos]);
	pos +=1;
      }
      
    }

  }
  
  proc parseArgs(arguments:[]string) throws {
    var pos = arguments.domain.low;
    this.consumeArgs(arguments, pos);
    if this.unknownArgs.size > 0 then {
      throw new ArgumentError("Unknown Arguments found during parsing: " + " ".join(unknownArgs.toArray()));
    }
    if pos != arguments.domain.high + 1 then {
      writeln("pos= " + pos:string);
      writeln("domain.high = " + arguments.domain.high:string);
      throw new ArgumentError("Unknown Arguments left after parsing: " + " ".join(arguments[pos..]));
    }
    if this.missingArgs.size > 0 then {
      writeln(this.missingArgs);
      throw new ArgumentError("Some required argument values were not supplied for : " + " ".join(missingArgs.toArray()));
    }
  }

  proc addArgument(type eltType,
		   name:string,
                   opts:[] string,
                   numArgs:int = 1,
                   defaultValue:eltType,
                   required:bool = false,
                   help:string = "") throws 
		   {
		     return addArgument(eltType, name, opts, numArgs-1..numArgs-1,
					[defaultValue], required, help);
		   }
   
   proc addArgument(type eltType,
		    name:string,
		    opts:[] string,
		    numArgs:range,
		    defaultValue:[] eltType,
		    required:bool = false,
		    help:string="") throws {
     compilerAssert(numArgs.hasLowBound(), "numArgs must have a lower bound");
     var act = new Action(name=name, numOpts=opts.size,opts= opts,
					numArgs=numArgs, required=required,
					help=help,
					numDefaults=defaultValue.size);
     //for val in defaultValue do act.defaultValue.append(val:string);
     return addArgument(act, eltType);   
   }

   proc addArgument(in action : Action, type eltType) throws {
     var name = action.name;
     

     var arg = new shared TypedArgument(eltType=eltType);
     for opt in action.opts do options.add(opt, name);
		     		    
     for val in action.defaultValue do arg.values.append(val:string);
		     
     result.add(action.name, arg);
     actions.add(name, action);
     return arg;
   }
       
  
  proc addArgument(type eltType,
		   name:string,
                   opts:[] string,
                   numArgs:int = 1,
                   defaultValue:[] eltType,
                   required:bool = false,
                   help:string = "") throws 
		   {
		    
		     var act = new Action(name=name, numOpts=opts.size,
						     opts= opts, numArgs=numArgs-1..numArgs-1,
						     required=required,help=help,
						     
						     numDefaults=defaultValue.size);
		     //for val in defaultValue do act.defaultValue.append(val:string);
		     return addArgument(act, eltType);
		   }
  
  }
}
