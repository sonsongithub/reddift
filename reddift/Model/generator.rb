
class SwiftClass
  def initialize(name, attributes = nil)
    @name = name
    @property = []
    @attributes = attributes
  end

  def addProperty(property)
    registeredNames = []
    @property.each{|item|
      registeredNames.push(item.name) 
    }
    property.each{|item|
      if registeredNames.index(item.name) == nil
        @property = @property + [item]
        registeredNames.push(item.name)
      end
    }
  end

  def source
    return if @property.length == 0

    buf = ""
    buf = buf + sprintf($file_header_template, @name.capitalize, Time.now)
    buf = buf + "class " + @name.gsub(/\s\(.+?\)/, "").capitalize + " {\n"
    @property.each{|p|
      buf = buf + p.propertyDeclaration
    }
    buf = buf + "\n\n    init(json:[String:AnyObject]) {\n"
    @property.each{|p|
      buf = buf + p.blockInInit
    }
    buf = buf +  "    }\n"
    buf = buf +  "}\n\n\n"
  end

  attr_accessor:property, :name, :attributes
end

class SwiftProperty
  
  def initialize(type, name, comment)
    @type = type
    @name = name
    @comment = comment
    @typeDictionary = {
      "array"=>"[]",
      "int"=>"Int",
      "long"=>"Int",
      "boolean"=>"Bool",
      "string"=>"String" 
    }
    @typeDefaultValue = {
      "array"=>"[]",
      "int"=>"0",
      "long"=>"0",
      "boolean"=>"false",
      "string"=>"\"\"" 
    }
  end

  def propertyDeclaration()
    type = "[AnyObject]"
    type = @typeDictionary[@type] if @typeDictionary[@type] != nil
    sprintf($property_template, @comment, @name, type)
  end

  def blockInInit
    if @typeDictionary[@type] != nil
      sprintf($initialize_template, @name, @typeDictionary[@type], @name, @name, @typeDefaultValue[@type])
    else
      sprintf($initialize_template_comment_out, @name, @typeDictionary[@type], @name, @name, @typeDefaultValue[@type])
    end
  end

  attr_accessor:type, :name, :comment
end

def main
  implementations = []
  classes = []

  html = File::open("./source.html").read

  p = nil

  html.scan(/(<h2>(.+?)<\/h2>)|(<h3>(.+?)<\/h3>)|(<tr>(.+?)<\/tr>)/m).each{|result|
    # p result[5]
    if result[1] != nil
      name = result[1].gsub(/(<.+?>)|\n/, "")
      obj = SwiftClass.new(name)
      implementations.push(obj)
      p = obj
    elsif result[3] != nil
      name = result[3].gsub(/(<.+?>)|\n/, "")
      attributes = ""
      if name =~ /(.+?)\s\((.+?)\)/
        name = $1
        attributes = $2
      end
      obj = SwiftClass.new(name, attributes)
      classes.push(obj)
      p = obj
    elsif result[5] != nil
      elements = result[5].scan(/<td.+?>.+?<\/td>/m)
      begin
        type = elements[0].gsub(/(<.+?>)|\n/, "").downcase
        name = elements[1].gsub(/(<.+?>)|\n/, "")
        comment = elements[2].gsub(/(<.+?>)|\n/, "")
        p.property.push(SwiftProperty.new(type, name, comment))
      rescue
      else
      end
    end
  }

  thing = nil
  votable = nil
  created = nil
  implementations.each{|element|
    if element.name =~ /thing/
      thing = element
    elsif element.name =~ /votable/
      votable = element
    elsif element.name =~ /created/
      created = element
    end
  }

  classes.each{|element|
    if element.property.length > 0
      if element.attributes == "implements votable | created"
        element.addProperty(thing.property)
        element.addProperty(created.property)
        element.addProperty(votable.property)
      elsif element.attributes == "implements created"
        element.addProperty(thing.property)
        element.addProperty(created.property)
      else 
        element.addProperty(thing.property)
      end
      fw = File::open("./" + element.name.capitalize + ".swift", "w")
      fw.write element.source
      fw.close
    end
  }
end

$file_header_template = <<"EOS"
//
//  %s.swift
//  reddift
//
//  Created by generator.rb via from https://github.com/reddit/reddit/wiki/JSON
//  Created at %s
//

import UIKit

EOS

$initialize_template = <<"EOS"
        if let temp = json["%s"] as? %s {
            self.%s = temp
        }
        else {
            self.%s = %s
        }
EOS

$initialize_template_comment_out = <<"EOS"
//      if let temp = json["%s"] as? %s {
//          self.%s = temp
//      }
//      else {
//          self.%s = %s
//      }
EOS

$property_template = <<"EOS"
    /** 
    %s
    */
    let %s:%s
EOS

main