{ lib, homeManagerModule, nixosModule }:

let
  expectToThrow = { expr, msg ? "" }:
    let
      expectedError = {
        inherit msg;
        type = "ThrownError";
      };
    in { inherit expr expectedError; };
in {
  testPass = {
    expr = 1;
    expected = 1;
  };

  testFail = {
    expr = { x = 1; };
    expected = { x = 1; };
  };

  testFailEval = expectToThrow {
    expr = abort "No U";
    msg = "No aaa";
  };

  testFailEval2 = {
    expr = throw "NO U";
    expectedError.type = "ThrownError";
    expectedError.msg = "NO aa";
    #expected = 0;
  };

  nested = {
    testFoo = {
      expr = "bar";
      expected = "bar";
    };
  };
}
