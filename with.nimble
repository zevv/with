version       = "0.5.0"
author        = "zevv"
description   = "Simple 'with' macro for Nim"
license       = "MIT"
skipDirs      = @["tests"]

requires "nim >= 0.19.0"

task test, "Run tests":
  exec "nim c -r " & "tests/tests.nim"
