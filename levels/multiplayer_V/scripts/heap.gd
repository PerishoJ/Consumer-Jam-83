extends Object
class_name MinHeap
## For heap to work, the stored objects must 
## have the function get_score()

var heap : Array

## turn an unordered array into a heap
func heapify():
  for i in range( heap.size()-1, -1, -1): # start from the end, go backwards
    _sift_down(i)
    
## Consumes the smallest object and returns
func pop():
  var smallest = heap[0] # The front is the littlest object
  _swap(0,heap.size()-1) # swap it with the back
  heap.pop_back() # remove the consumed item
  _sift_down(0) # sort that swapped element back into heap order
  return smallest

## does NOT consume the front element
func peek():
  return heap[0]
  
## Add and heapify 
func insert( obj ):
  heap.append(obj) # push to the end
  _sift_up( heap.size()-1 ) # sort
  

func _sift_down(i : int):
  ### find the smallest of current node and it's (potentially) two children
  var smallest = i
  smallest = _min(smallest , _get_left_child(i))
  smallest = _min(smallest , _get_right_child(i))
  if smallest != i :
    _swap(smallest, i)
    _sift_down(smallest)
    
    
func _sift_up(i : int):
  if _has_parent(i):
    var parent = _parent(i)
    if heap[i].get_score() < heap[parent].get_score() :
      _swap(i,parent)
      _sift_up(parent)
        
        
func _has_parent(i : int):
  return i>0
  
  
func _parent(i : int):
  return floor( i / 2)


func _min ( orig: int , other: int ):
  if _exists(other) and heap[other].get_score() < heap[orig].get_score():
    return other
  else:
    return orig


func _swap( i : int , j : int ):
  var temp = heap[j]
  heap[j] = heap[i]
  heap[i] = temp 


func _exists(i : int):
  return heap.size()>i and i>=0


func _get_left_child(i: int):
  return  i * 2  
  
  
func _get_right_child(i: int):
  return  i * 2 + 1
    
    
func _print():
  ### Just for debugging
  var depth = 0
  var i = 0
  while i < heap.size():
    var row = ""
    # this should build like a pyramid shape with the first element at the top
    for row_pos in range (0 , pow(2,depth)):
      if(_exists(i)):
        row = row + "[%s]%s, "%[i, heap[i]]
        i += 1
      else:
        break
    print(row)
    depth += 1
