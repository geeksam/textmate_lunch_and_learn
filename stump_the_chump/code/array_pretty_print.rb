# Retrieved from http://blog.bleything.net/2006/7/11/munging-large-arrays-for-pretty-code
# haven't tried this, though

require 'enumerator'

def pp_array(array, num_output_cols = 1)
  @array, @num_output_cols = array, num_output_cols
  find_column_widths

  lines = []
  row_lines.each_slice(@num_output_cols) do |slice|
    lines << '  ' + slice.join(' ')
  end
  return "[\n#{lines.join("\n")}\n]\n"
end

def row_lines
  rows = []
  @array.each_with_index do |row, row_idx|
    inner_cols = []
    row.each_with_index do |col, col_idx|
      col_text = "'#{col}'" + (row.last_col?(col_idx) ? '' : ',')
      len = column_width(row_idx, col_idx)
      inner_cols << sprintf("%1$*2$s", col_text, 0-len)
    end
    rows << "[#{inner_cols.join(' ')}],"
  end
  rows
end

def find_column_widths
  # @column_widths is a 2D array.
  # Inner/outer indices correspond to inner/outer columns.
  # For example, the following structure has two outer and three inner columns:
  # [
  #   ['foo', 'bar', 'baz'], ['spam', 'eggs', 'bacon'],   # some Python habits remain...
  # ]
  #    0:0    0:1    0:2      1:0     1:1     1:2   <--- outer/inner indices
  setup_column_widths
  @array.each_with_index do |row, row_idx|
    row.each_with_index do |col, col_idx|
      outer, inner = outer_inner(row_idx, col_idx)
      @column_widths[outer][inner] = [col.to_s.length, @column_widths[outer][inner]].max
    end
  end
  adjust_column_widths_for_separators
end

##### Everything below this is a refactored helper method; the good stuff is above. #####

def column_width(row_idx, col_idx)
  outer, inner = outer_inner(row_idx, col_idx)
  @column_widths[outer][inner]
end

def outer_inner(row_idx, col_idx = 0); 
  [row_idx.modulo(@num_output_cols), col_idx]
end

def setup_column_widths
  columns_per_input_row = @array.collect { |row| row.length }.max
  @column_widths = []
  1.upto(@num_output_cols) { |i| @column_widths << Array.new(columns_per_input_row, 0) }
end

def adjust_column_widths_for_separators
  # Column widths must account for single quotes and commas
  addl_char_len = "''".length
  separator_len = ','.length
  @column_widths.each do |inner_widths|
    inner_widths.each_with_index do |len, idx|
      inner_widths[idx] += addl_char_len
      inner_widths[idx] += separator_len unless inner_widths.last_col?(idx)
    end
  end
end

class Array
  def last_col?(idx); idx == (self.length - 1); end
end
