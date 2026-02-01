# DAG (Directed Acyclic Graph) system for topological ordering
# Critical for firewall rule ordering and service dependencies
{ lib }:
with lib;
let
  inherit (builtins) attrNames attrValues mapAttrs;

  # DAG entry types
  dagEntryOf = elemType: let
    submoduleOptions = { name, config, ... }: {
      options = {
        data = mkOption {
          type = elemType;
        };
        after = mkOption {
          type = types.listOf types.str;
          default = [];
        };
        before = mkOption {
          type = types.listOf types.str;
          default = [];
        };
      };
    };
  in types.submodule submoduleOptions;

  # Create a DAG entry that comes before other entries
  entryBefore = before: data: {
    inherit data;
    before = if isList before then before else [before];
    after = [];
  };

  # Create a DAG entry that comes after other entries
  entryAfter = after: data: {
    inherit data;
    after = if isList after then after else [after];
    before = [];
  };

  # Create a DAG entry that comes between other entries
  entryBetween = before: after: data: {
    inherit data;
    before = if isList before then before else [before];
    after = if isList after then after else [after];
  };

  # Create a DAG entry with no specific ordering
  entryAnywhere = data: {
    inherit data;
    before = [];
    after = [];
  };

  # Topological sort implementation
  topoSort = dag: let
    # Convert DAG to adjacency list
    entries = mapAttrs (name: value: value) dag;

    # Helper function for DFS
    visit = visited: stack: name: let
      entry = entries.${name};
      deps = entry.after;
      newVisited = visited // { ${name} = true; };

      # Visit dependencies first
      visitDeps = foldl' (acc: dep:
        if hasAttr dep entries && !(acc.visited.${dep} or false)
        then visit acc.visited acc.stack dep
        else acc
      ) { inherit visited stack; } deps;

    in {
      visited = visitDeps.visited // { ${name} = true; };
      stack = visitDeps.stack ++ [name];
    };

    # Visit all nodes
    result = foldl' (acc: name:
      if acc.visited.${name} or false
      then acc
      else visit acc.visited acc.stack name
    ) { visited = {}; stack = []; } (attrNames entries);

  in result.stack;

  # Create a DAG type
  dagOf = elemType: types.attrsOf (dagEntryOf elemType);

in {
  inherit entryBefore entryAfter entryBetween entryAnywhere topoSort dagOf;
}
