version       = "0.2.0"
author        = "zevv"
description   = "Simple 'with' macro for Nim"
license       = "MIT"
skipDirs      = @["tests"]

requires "nim >= 0.17.1"

task test, "Run tests":
  exec "nim c -r " & "tests/tests.nim"
