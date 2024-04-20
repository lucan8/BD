from abc import abstractmethod
from typing import List
from enum import Enum
import random
from time import time

class Complexity(Enum):
    N_SQUARED = 1
    N_LOG2_N = 2
    N_PLUS_MAX = 3


def timer(func):
    def wrapper(*args, **kwargs):
        start = time()
        sorted_arr = func(*args, **kwargs)
        end = time()
        
        return (sorted_arr, round(end - start, 2))
    return wrapper


class SortingAlgorithm:
    def __init__(self, name: str = None, complexity: str = None, in_place: bool = False, max_val: int = 0, max_size: int = 0):
        self.name = name
        self.complexity = complexity
        self.in_place = in_place
        self.max_val = max_val
        self.max_size = max_size

    @abstractmethod
    def sort(self, array: List[int], array_size: int, max_value: int, reverse: bool = False):
        ...

    #decorated method that tracks time passed for all sorts
    @timer
    def sortTimed(self, array: List[int], array_size: int, max_value: int, reverse: bool = False):
        return self.sort(array, array_size, max_value, reverse)

    def verifWithinLimits(self, val: int, size: int):
        if val > self.max_val or size > self.max_size:
            return False

        return True


class DefaultSort(SortingAlgorithm):
    def sort(self, array: List[int], array_size: int, max_value: int, reverse: bool = False):
        if self.verifWithinLimits(max_value, array_size):
            return sorted(array, reverse=reverse)
        else:
            return []


class CountingSort(SortingAlgorithm):
    def sort(self, array: List[int], array_size: int, max_value: int, reverse: bool = False):
        ...


#Maxim baza 2^16
class RadixSort(SortingAlgorithm):
    def __init__(self, name: str = None, complexity: str = None, in_place: bool = False, base : int = 10, max_val: int = 0, max_size: int = 0):
        SortingAlgorithm.__init__(self, name, complexity, in_place, max_val, max_size)
        self.base = base

    def __countingSort(self, array: List[int], array_size: int, base: int, exp: int):
        output = [0] * array_size
        count = [0] * base

        # Calculate count of elements
        for i in range(0, array_size):
            index = array[i] // exp
            count[index % base] += 1

        # Calculate cumulative count
        for i in range(1, base):
            count[i] += count[i - 1]

        # Place the elements in sorted order
        i = array_size - 1
        while i >= 0:
            index = array[i] // exp
            output[count[index % base] - 1] = array[i]
            count[index % base] -= 1
            i -= 1

        return output

    def sort(self, array: List[int], array_size: int, max_value: int, reverse: bool = False):
        if self.verifWithinLimits(max_value, array_size) and self.base <= 1 << 16:
            exp = 1
            # Sorting by each digit with counting sort
            while max_value // exp:
                array = self.__countingSort(array, array_size, self.base, exp)

                exp *= self.base

            if reverse:
                return array[::-1]

            return array
        else:
            return []


class ShellSort(SortingAlgorithm):
    def sort(self, array: List[int], array_size: int, max_value: int, reverse: bool = False):
        if self.verifWithinLimits(max_value, array_size):
            gap = array_size // 2

            while gap > 0:
                for i in range(gap, array_size):
                    temp = array[i]
                    j = i
                    while j >= gap and array[j - gap] > temp:
                        array[j] = array[j - gap]
                        j -= gap

                    array[j] = temp

                gap //= 2

            if reverse:
                return array[::-1]

            return array
        else:
            return []


class QuickSort(SortingAlgorithm):
    def __quicksort(self, array: List[int], left_idx: int, right_idx: int):
        if left_idx < right_idx:
            pivot_idx = self.__random_partition(array, left_idx, right_idx)
            self.__quicksort(array, left_idx, pivot_idx - 1)
            self.__quicksort(array, pivot_idx + 1, right_idx)

    def __random_partition(self, array: List[int], left_idx: int, right_idx: int):
        pivot_idx = random.randint(left_idx, right_idx)

        # Change the first element with the pivot
        # this works since in __partition we will take
        # the first element as the pivot (witch will be random thanks to this)
        array[left_idx], array[pivot_idx] = array[pivot_idx], array[left_idx]
        return self.__partition(array, left_idx, right_idx)

    def __partition(self, array: List[int], left_idx: int, right_idx: int):
        pivot_idx = left_idx
        pivot_val = array[pivot_idx]
        left_margin = left_idx + 1

        for curr_idx in range(left_idx + 1, right_idx + 1):
            if array[curr_idx] <= pivot_val:
                array[curr_idx], array[left_margin] = array[left_margin], array[curr_idx]
                left_margin += 1

        (array[pivot_idx], array[left_margin - 1]) = (
            array[left_margin - 1], array[pivot_idx])

        pivot_idx = left_margin - 1
        return pivot_idx

    def sort(self, array: List[int], array_size: int, max_value: int, reverse: bool = False):
        if self.verifWithinLimits(max_value, array_size):
            self.__quicksort(array, 0, array_size - 1)
        else:
            return []
        if reverse:
            array = array[::-1]
        return array


class HeapSort(SortingAlgorithm):
    def __heapsort(self, array: List[int], array_size: int):
        self.__build_maxheap(array, array_size)
        for idx in range(array_size - 1, 0, -1):
            array[idx], array[0] = array[0], array[idx]
            self.__heapify(array, idx, 0)

    def __heapify(self, array: List[int], array_size: int, root: int):
        left_node = 2 * root + 1
        right_node = 2 * root + 2

        max_node = root

        # cheks if the left child larger than the root
        if left_node < array_size and array[left_node] > array[max_node]:
            max_node = left_node

        # cheks if the right child larger than the root
        if right_node < array_size and array[right_node] > array[max_node]:
            max_node = right_node

        if max_node != root:
            array[max_node], array[root] = array[root], array[max_node]

            # continue to heapify the rest of the tree
            self.__heapify(array, array_size, max_node)

    def __build_maxheap(self, array: List[int], array_size: int):
        for idx in range(array_size // 2 - 1, -1, -1):
            self.__heapify(array, array_size, idx)

    def sort(self, array: List[int], array_size: int, max_value: int, reverse: bool = False):
        if self.verifWithinLimits(max_value, array_size):
            self.__heapsort(array, array_size)
        else:
            return []
        if reverse:
            array = array[::-1]
        return array
