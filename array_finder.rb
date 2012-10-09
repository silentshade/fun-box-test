class Array
  
  def finder
    return nil if self.empty?
    find_two self, 0, self.size   
  end

  def finder2
    (self[0]..self[-1]).to_a - self
  end

  private
    def find_one(arr,left,right)
      while right > left+1 do
        center = (right+left)/2
        if arr[center] == arr[left] + (center - left) 
          left = center
        else
          right = center
        end
      end
      arr[left] + 1
    end
    
    def find_two(arr,left,right)
      while right > left+1 do
        center = (right+left)/2
        if arr[center] == arr[left] + (center - left) 
          left = center
        elsif arr[center] == arr[left] + (center - left) + 2
          right = center
        else
          return [(find_one arr, left, center), (find_one arr, center, right)]
        end
      end
      [arr[left]+1,arr[left]+2]
    end
end