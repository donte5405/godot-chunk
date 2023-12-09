# Godot Chunk
A dead-simple chunk loading/unloading addon to help making open-world games easier in Godot 3.x.

---

## Why Not 4.x?
I hate Godot 4 :p

---

## Future Features
- Lazy-loading chunk nodes.
- (maybe) LOD chunk baker.
- (maybe) Occlusion culling.

---

## Getting Started
1. Add both `chunk` and `global_signal.gd` from `addons` into the project.
2. On the scene that you want to start using chunk system, add `main.gd` node into the scene.
3. On the `Chunk` node, in property inspector, there are few options that you need to setup. Configure properties 
    - **Chunk Size** indicates your scene size, measured by object scaling. Default as 16, which is the same size as ones in the project example and `chunk_default.tscn`.
    - **Chunk Distance** indicates render distance from the center of the point of interest (**Node To Follow**). Default as 2.
    - **Chunk Position** indicates firstly loaded chunk position Default as `(0, 0)`.
    - **Chunk Default Scene** indicates `PackedScene` that will be loaded by default if there aren't any scenes. Default as sameple scene inside the plugin directory.
    - **Chunk Directory** indicates a directory (folder) that store all chunk files.
    - **Node To Follow** indicates a `Spatial` node that will be referenced as an object of interest. Chunks will be loaded around this node. Default as the chunk itself.

---

## Chunk Partitioning
You need to name scene file in the chunk directory as the format of chunk's coordinate. For example, if your chunk is located at `(2, 0)`, the scene name will be named as:
```
_2_0.tscn
```
Another example, if its coordinate is `(-1, -2)`, the scene name will be named as:
```
_-1_-2.tscn
```
However, it can be tricky to organise the project in this form of naming. Good way to deal with this is to have separated level designer scenes that combine multiple chunk sections together, and omit them out in the production environment. This is an example of the optimal project structure.
```
- root
    - _world (omitted from production)
        - village_0.tscn
        - open_large_field_near_village_0.tscn
        - very_large_castle_area.tscn
    - world (actual chunk directory)
        - _-1_0.tscn
        - _0_0.tscn
        - _1_0.tscn
        - _-1_-1.tscn
        - _0_-1.tscn
        - _1_-1.tscn
        - _-1_1.tscn
        - _0_1.tscn
        - _1_1.tscn
        ...
```
To save the scene into chunk form, on each chunk, use `Save Branch as Scene` option and save them accordingly. After the scene is saved, undo the change to revert the node back to previous (local) type again.

---

## Teleporting
There's a limitation on how "player" node travels across chunks. Moving them to the destination point directly may cause unexpected behaviour or significant slowdown (there's an apparent reason why open-world games with fast-travel functionalities all have loading screen).  It's recommended to use functions from the plugin to move the node correctly. First, you need to figure out target chunk position, and then the desired point that you want to teleport the node to. For example, the target chunk is `(3, 4)` and you want to travel the "player" node to the waypoint named `TeleportPosition`, you need to use function `Chunk.set_position()`. Here is an example of how this will work:
```gdscript
Chunk.set_position(Vector2(3, 4))
var target_position: Spatial = get_tree().current_scene.find_node("TeleportPosition", true, false) # Very slow but for sake of simplicity
your_player_node.global_translation = target_position.global_translation
```

---
