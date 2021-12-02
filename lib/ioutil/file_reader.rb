# frozen_string_literal: true

## FileReader provides file reading capabilities to a class/module.
module FileReader
  def read_file(file_name)
    File.open(file_name, &:readlines)
  end
end
