
import macros
import hashes
import strutils
import tables

# Style insensitive table for identifier lookups

type Fields = Table[NimNode, NimNode]
proc hash(n: NimNode): Hash = hashIgnoreStyle(n.strVal)
proc `==`(a, b: NimNode): bool = cmpIgnoreStyle(a.strVal, b.strVal) == 0


# Collect field identifiers from object or tuple

proc collectFields(obj: NimNode, fields: var Fields) =

  # Get the type of the object, de-ref if needed

  var typ = obj.getTypeImpl
  if typ.kind == nnkRefTy:
    typ = typ[0].getTypeImpl

  # Extract fields from object or tuple

  if typ.kind == nnkObjectTy:
    for id in typ[2]:
      fields[id[0]] = obj
  elif typ.kind == nnkTupleTy:
    for id in typ:
      fields[id[0]] = obj
  else:
    error "Expected object or tuple"


# Helper function for recursing through the code block

proc doBlock(n: NimNode, fields: var Fields): NimNode =

  # fields can be shadowed by operations that declare new symbols

  if n.kind in {nnkConstSection,nnkLetSection,nnkVarSection}:
    for nid in n: fields.del nid[0]
  if n.kind in {nnkProcDef,nnkFuncDef,nnkIteratorDef,nnkConverterDef}:
    fields.del n[0]

  # Replace identifier with dotExpr(obj.field) if found in fields list

  if n.kind == nnkIdent:
    if n in fields:
      return newDotExpr(fields[n], n)

  # Recurse through all children

  var fields = fields
  result = copyNimNode(n)
  for i, nc in n.pairs:
    if n.kind == nnkDotExpr and i != 0:
      result.add nc
    else:
      result.add doBlock(nc, fields)


macro with*(obj: typed, cs: untyped): untyped =
  var fields = initTable[NimNode, NimNode]()
  if obj.kind == nnkTupleConstr:
    for cobj in obj:
      collectFields(cobj, fields)
  else:
    collectFields(obj, fields)
  result = doBlock(cs, fields)

# vi: ft=nim et ts=2 sw=2

