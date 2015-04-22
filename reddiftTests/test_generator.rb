
require 'JSON'

def main
  fr = File::open("./data/t3.json")
  raw = fr.read
  fr.close
  raw_json = JSON.parse(raw)

  raw_json.each{|k,v|
    v = v.gsub(/\"/, "\\\"" ) if v.kind_of?(String)
    v = v.gsub(/\n/, "\\n" ) if v.kind_of?(String)

    template = $template_bool_int
    template = $template if v.kind_of?(String)
    puts sprintf(template, k, v, "check " + k + "'s value.")
  }

end

$template = <<"EOS"
XCTAssertEqual(object.%s, "%s", "%s")
EOS

$template_bool_int = <<"EOS"
XCTAssertEqual(object.%s, %s, "%s")
EOS

main
