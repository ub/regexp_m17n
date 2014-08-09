
# monkey-patching String class to overcome ruby implementation shortcomings
class String
  alias original_encode_method encode

  # workaround for Ruby unimplemented encodings bug
  def encode(*args)
    return original_encode_method(*args)
  rescue Encoding::ConverterNotFoundError
    STDERR.puts "WARNING: '#{args[0]}' encoding is not supported in #{RUBY_ENGINE} #{RUBY_VERSION}"
    return dup.force_encoding(args[0]) # incidentally, this hack gives correct result  for ISO-2022-JP-2 and UTF-7 when self == "." :)
  end
end


module RegexpM17N
  def self.non_empty?(str)

    #  One solution could be encode str parameter back to UTF-8:
    #
    #  (1)    str.encode(Encoding::UTF_8) =~ /^\X+$/
    #
    # The code above works, for all but two 'broken' dummy encodings ISO-2022-JP-2 and UTF-7
    # It is the least 'hackish' solution, suitable for most cases in everyday coding.
    # ========================================================================================

    # NOW FOR THE REAL SOLUTION, ( more in the spirit of the problem, as formulated in README.md)
    #
    # The algorithm below determines non-empty strings with 'broken' encodings as well:
    #
    #   utf7str = 'Hi Mom -+Jjo--!'.force_encoding(Encoding::UTF_7)
    #   utf7str.dup.force_encoding("binary") =~ /^.+$/m         # => 0
    #

    str.dup.force_encoding("binary") =~ /^.+$/m # use dup to eliminate side-effects and ensure thread safety (while losing efficiency)
  end
end