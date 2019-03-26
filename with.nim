
import macros
import hashes
import strutils
import tables

# Style insensitive table for field lookups

type Fields = Table[NimNode, NimNode]
proc hash(n: NimNode): Hash = hashIgnoreStyle(n.strVal)
proc `==`(a, b: NimNode): bool = cmpIgnoreStyle(a.strVal, b.strVal) == 0


# Things that can shadow a field

const shadowSections = { nnkConstSection, nnkLetSection, nnkVarSection }

const shadowDefs = { nnkProcDef, nnkFuncDef, nnkIteratorDef, 
                     nnkConverterDef, nnkTemplateDef, nnkMacroDef }


# Collect field symbols from a object or a tuple

proc collectFields(obj: NimNode, fields: var Fields) =

  proc aux(n: NimNode, fields: var Fields) =

    # Get the implementation of the object, de-ref if needed

    var impl = n.getTypeImpl
    if impl.kind == nnkRefTy:
      impl = impl[0].getTypeImpl
    impl.expectKind {nnkObjectTy,nnkTupleTy}

    # Recurse parent objects

    if impl.kind == nnkObjectTy:
      if impl[1].kind == nnkOfInherit:
        aux(impl[1][0], fields)
      impl = impl[2]

    # Get fields from object or tuple

    for id in impl:
      let sym = id[0]
      fields[sym] = obj
      echo "field ", sym, " ", impl.repr

  aux obj, fields


# Helper function for recursing through the code block

proc doBlock(n: NimNode, fields: var Fields): NimNode =

  # fields can be shadowed by declaration of a new symbol

  if n.kind in shadowSections:
    for nid in n: fields.del nid[0]
  if n.kind in shadowDefs:
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

