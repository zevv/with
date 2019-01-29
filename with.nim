
import macros
import sets


macro with*(obj: typed, cs: untyped): untyped =

  # extract list of field names from the given object or tuple
  
  var fields: seq[NimNode]

  var typ = obj.getTypeImpl
  if typ.kind == nnkRefTy:
    typ = typ[0].getTypeImpl

  if typ.kind == nnkObjectTy:
    for id in typ[2]:
      fields.add id[0]
  elif typ.kind == nnkTupleTy:
    for id in typ:
      fields.add id[0]
  else:
    error "Expected object or tuple"

  # recurse through code block AST and replace all identifiers
  # which are a field of the given object by a dotexpr obj.field

  proc aux(obj: NimNode, n: NimNode): NimNode =
    if n.kind == nnkIdent:
      for f in fields:
        if eqIdent(f, n):
          return newDotExpr(obj, n)

    result = copyNimNode(n)
    for i, nc in n.pairs:
      if n.kind == nnkDotExpr and i != 0:
        result.add nc
      else:
        result.add aux(obj, nc)

  result = aux(obj, cs)

# vi: ft=nim et ts=2 sw=2

