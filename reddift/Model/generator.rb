# # URLにアクセスするためのライブラリの読み込み
# require 'open-uri'
# # Nokogiriライブラリの読み込み
# require 'nokogiri'

# # スクレイピング先のURL
# url = 'https://github.com/reddit/reddit/wiki/JSON'

# charset = nil
# html = open(url, { :proxy => 'http://10.81.247.8:8080/'}) do |f|
#   charset = f.charset # 文字種別を取得
#   f.read # htmlを読み込んで変数htmlに渡す
# end

# # # htmlをパース(解析)してオブジェクトを生成
# # doc = Nokogiri::HTML.parse(html, nil, charset)

# # doc.xpath("//tr").each{|node|
# #   puts "----------------"
# #   node.children.xpath("//td").each{|node|
# #     p node.text
# #   }
# # }


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

  def sourceUsingLet
    return if @property.length == 0

    buf = ""
    buf = buf + sprintf($file_header_template, @name.capitalize, Time.now)
    buf = buf + "class " + @name.gsub(/\s\(.+?\)/, "").capitalize + " {\n"
    @property.each{|p|
      if p.type == "string"
        buf = buf +  "    /**\n    " + p.comment + "\n    */\n"
        buf = buf +  "    let " + p.name + ":String\n"
      elsif p.type == "object"
        buf = buf +  "    /**\n    " + p.comment + "\n    */\n"
        buf = buf +  "    // let " + p.name + ":AnyObject\n"
      elsif p.type == "long"
        buf = buf +  "    /**\n    " + p.comment + "\n    */\n"
        buf = buf +  "    let " + p.name + ":Int\n"
      elsif p.type == "int"
        buf = buf +  "    /**\n    " + p.comment + "\n    */\n"
        buf = buf +  "    let " + p.name + ":Int\n"
      elsif p.type == "boolean"
        buf = buf +  "    /**\n    " + p.comment + "\n    */\n"
        buf = buf +  "    let " + p.name + ":Bool\n"
      elsif p.type == "array"
        buf = buf +  "    /**\n    " + p.comment + "\n    */\n"
        buf = buf +  "    let " + p.name + ":[]\n"
      else
        buf = buf +  "    /**\n    " + p.comment + "\n    */\n"
        buf = buf +  "    // let " + p.name + " = [" + p.type + "]\n"
      end
    }
    buf = sourceInit(buf)
    buf = buf +  "}\n\n\n"
  end

  def sourceInit(buf)
    dict = {
      "array"=>"[]",
      "int"=>"Int",
      "long"=>"Int",
      "boolean"=>"Bool",
      "string"=>"String" 
    }
    value = {
      "array"=>"[]",
      "int"=>"0",
      "long"=>"0",
      "boolean"=>"false",
      "string"=>"\"\"" 
    }
    availableTypes = [
      "array",
      "int",
      "long",
      "boolean",
      "string"]
template = <<"EOS"
        if let temp = json["%s"] as? %s {
            self.%s = temp
        }
        else {
            self.%s = %s
        }
EOS

template_anyobject = <<"EOS"
//      if let temp = json["%s"] as? %s {
//          self.%s = temp
//      }
//      else {
//          self.%s = %s
//      }
EOS
    buf = buf + "    init(json:[String:AnyObject]) {\n"
    @property.each{|p|
      if availableTypes.index(p.type) != nil
        buf = buf + sprintf(template, p.name, dict[p.type], p.name, p.name, value[p.type])
      else
        buf = buf + sprintf(template_anyobject, p.name, dict[p.type], p.name, p.name, value[p.type])
      end
    }
    buf = buf +  "    }\n"
  end

  attr_accessor:property, :name, :attributes
end

class SwiftProperty
  def initialize(type, name, comment)
    @type = type
    @name = name
    @comment = comment
  end
  attr_accessor:type, :name, :comment
end

def main
  types = []

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
      fw.write element.sourceUsingLet
      fw.close
    end
  }
end

main