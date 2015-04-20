
require 'JSON'

class SpecInfo
  def initialize(type, name, description)
    @type = type
    @name = name
    @description = description
  end
  attr_accessor:type, :name, :description
end

class Property

  def initialize(className, type, name, description, example)
    @className = className
    @type = type
    @name = name
    @description = description
    @example = example
  end

  def declare
    sprintf($template, @description, @example, @name)
  end

  def mod_init
    sprintf($init_template, @name, @className, @name)
  end

end

def main
  fr = File::open("./data/t1.json")
  raw = fr.read
  fr.close

  fr = File::open("./data/t1_spec.html")
  spec = fr.read
  fr.close

  spec_hash = {}

  spec.scan(/<td.*?>(.+?)<\/td>\n<td.*?>(.+?)<\/td>\n<td.*?>(.+?)<\/td>\n/).each{|entry|
    type = entry[0].gsub(/(<.+?>)|(\n)/m, "")
    name = entry[1].gsub(/(<.+?>)|(\n)/m, "")
    description = entry[2].gsub(/(<.+?>)|(\n)/m, "")
    puts name
    spec_hash[name] = SpecInfo.new(type, name, description)
  }

  raw_json = JSON.parse(raw)

  raw_json = raw_json["data"]
  properties = []
  raw_json.each{|key, value|
    spec = spec_hash[key]
    type = spec.type if spec != nil
    description = spec.description if spec != nil
    properties.push(Property.new("comment", type, key, description, value))
  }

  properties.each{|e|
    puts e.declare
  }

  properties.each{|e|
    puts e.mod_init
  }

end

$template = <<"EOS"
    /**
    %s
    example: %s
    */
    var %s = ""
EOS

$init_template = <<"EOS"
        if let temp = data["%s"] as? String {
            %s.%s = temp
        }
EOS

main
