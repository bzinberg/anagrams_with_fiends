module ApplicationHelper
  class String
    def charwise_remove(s)
      c = String.new(self)
      while !s.empty?
        if c.sub!(s[0], '').nil?
          return false
        else
          s[0] = ''
        end
      end
      return c
    end

    def contain_anagram_of?(s)
      charwise_remove(s) ? true : false
    end
  end
end
