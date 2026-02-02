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
  # Usage: entryBetween ["item-before"] ["item-after"] data
  # Means: item-before -> this-entry -> item-after
  # Note: Parameters swapped from previous implementation to match semantic expectations
  # (previously had inverted mapping causing cycles in dependent configurations)
  entryBetween = before: after: data: {
    inherit data;
    after = if isList before then before else [before];  # We come AFTER the before items
    before = if isList after then after else [after];    # We come BEFORE the after items
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
    
    # Build reverse mapping for before constraints (O(n²) once instead of O(n³))
    # For each entry with before=[X], add this entry to X's list of items that should come after it
    beforeReversed = foldl' (acc: name:
      let
        entry = entries.${name};
        beforeList = entry.before or [];
      in
        foldl' (acc2: beforeName:
          acc2 // {
            ${beforeName} = (acc2.${beforeName} or []) ++ [name];
          }
        ) acc beforeList
    ) {} (attrNames entries);
    
    # Convert "before" constraints to "after" constraints using reverse mapping
    entriesWithExpandedBefore = mapAttrs (name: entry:
      entry // {
        after = entry.after ++ (beforeReversed.${name} or []);
      }
    ) entries;

    # Helper function for DFS with cycle detection
    # visited: set of fully processed nodes (black)
    # visiting: set of nodes currently being processed (gray)
    visit = visited: visiting: stack: name: 
      if visiting.${name} or false
      then throw "Cycle in DAG detected involving node: ${name}"
      else if visited.${name} or false
      then { inherit visited visiting stack; }
      else let
        entry = entriesWithExpandedBefore.${name};
        deps = entry.after;
        newVisiting = visiting // { ${name} = true; };

        # Visit dependencies first
        visitDeps = foldl' (acc: dep:
          if hasAttr dep entriesWithExpandedBefore
          then visit acc.visited acc.visiting acc.stack dep
          else acc
        ) { inherit visited; visiting = newVisiting; inherit stack; } deps;

      in {
        visited = visitDeps.visited // { ${name} = true; };
        visiting = removeAttrs visitDeps.visiting [name];
        stack = visitDeps.stack ++ [name];
      };

    # Visit all nodes
    sortResult = foldl' (acc: name:
      if acc.visited.${name} or false
      then acc
      else visit acc.visited acc.visiting acc.stack name
    ) { visited = {}; visiting = {}; stack = []; } (attrNames entriesWithExpandedBefore);
    
    # Convert sorted node names to list of {name, data} pairs
    result = map (name: {
      inherit name;
      data = entriesWithExpandedBefore.${name}.data;
    }) sortResult.stack;

  in { inherit result; };

  # Create a DAG type
  dagOf = elemType: types.attrsOf (dagEntryOf elemType);

in {
  inherit entryBefore entryAfter entryBetween entryAnywhere topoSort dagOf;
}
