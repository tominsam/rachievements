module Enumerable
  def uniq_by
    seen = Hash.new { |h,k| h[k] = true; false }
    reject { |v| seen[yield(v)] }
  end
end


