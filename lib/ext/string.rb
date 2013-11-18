class String
  def charwise_remove(str)
    c = Hash.new(0)

    self.each_char do |char|
      c[char] += 1
    end

    str.each_char do |char|
      if c[char] > 0
        c[char] -= 1
      else
        return nil
      end
    end

    ret = ''
    c.each do |char, count|
        ret << char*count
    end

    return ret
  end

  def contain_anagram_of?(str)
    c = Hash.new(0)

    self.each_char do |char|
      c[char] += 1
    end

    str.each_char do |char|
      if c[char] > 0
        c[char] -= 1
      else
        return false
      end
    end

    return true
  end

end
