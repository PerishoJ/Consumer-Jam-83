extends Node

## This was just a test to make sure MinHeap works correctly.

var heap :MinHeap =  MinHeap.new()

var actually_heap: Array[Temps]

func _enter_tree():
  #actually_heap.append(nt(100))
  #actually_heap.append(nt(45))
  #actually_heap.append(nt(12))
  #actually_heap.append(nt(8))
  #actually_heap.append(nt(87))
  #actually_heap.append(nt(14))
  #actually_heap.append(nt(21))
  #actually_heap.append(nt(34))
  #actually_heap.append(nt(99))
  #actually_heap.append(nt(12))
  #actually_heap.append(nt(3))
  #
  heap.insert(nt(100))
  heap.insert(nt(45))
  heap.insert(nt(12))
  heap.insert(nt(8))
  heap.insert(nt(87))
  heap.insert(nt(14))
  heap.insert(nt(21))
  heap.insert(nt(34))
  heap.insert(nt(99))
  heap.insert(nt(12))
  heap.insert(nt(3))
  
  #heap.heap = actually_heap
  heap.heapify()
  heap._print()
  
  while(heap.heap.size()>0):
    var sml = heap.pop()
    print(sml)

func nt(i : int):
  var t = Temps.new()
  t.val = i
  return t

class Temps:
  @export var val: int
  func get_score():
    return val
  
  func _to_string():
    return str(get_score())
