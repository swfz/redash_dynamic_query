require "redash_dynamic_query/version"

module RedashDynamicQuery
  class Error < StandardError; end
  autoload :Client, "redash_dynamic_query/client"
end
