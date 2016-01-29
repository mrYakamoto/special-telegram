require 'csv'
require 'nokogiri'
require 'open-uri'


CSV.open('parsed_results_one_row.csv', "ab:UTF-8") do |csv|
  csv << ["name","full_address","address","city", "state", "zip"]
end
CSV.open('parsed_results_two_rows.csv', "ab:UTF-8") do |csv|
  csv << ["name","full_address","address","city", "state", "zip"]
end
CSV.open('parsed_results_three_rows.csv', "ab:UTF-8") do |csv|
  csv << ["name","full_address","address","city", "state", "zip"]
end
CSV.open('parsed_results_four_rows.csv', "ab:UTF-8") do |csv|
  csv << ["name","full_address","address","city", "state", "zip"]
end
CSV.open('parsed_results_five_rows.csv', "ab:UTF-8") do |csv|
  csv << ["name","full_address","address","city", "state", "zip"]
end
CSV.open('parsed_results_six_rows.csv', "ab:UTF-8") do |csv|
  csv << ["name","full_address","address","city", "state", "zip"]
end
CSV.open('parsed_results_seven_rows.csv', "ab:UTF-8") do |csv|
  csv << ["name","full_address","address","city", "state", "zip"]
end
def life_call_parser_cpcs
  state_names_in_array.each do |state|
    p state
    state_page = Nokogiri::HTML(open("http://www.lifecall.org/cpc/#{state}.html"))
    state_page_parser(state_page)
  end
end



def state_page_parser(state_page)
  state_page_clinics_div_html = state_page.css( 'div.panes div p')
  state_name = state_page.css( 'div.panes div h3.state-name' ).text
  state_name = state_name.sub(/(\\t|\\r|\\n)/, "")
  state = state_names_and_abbrev_in_hash[state_name]

  state_page_clinics_div_html.each do |p_tag|
    p state_name
    p_tag.children.each do |node|
      node_text = remove_whitespace(node)

      if useless_data(node)
        node.remove
      elsif useless_text?(node_text)
        node.remove
      elsif po_box?(node_text)
        p_tag.remove
      elsif p_tag.children.length == 1
        p_tag.remove
      end
    end
  end

  state_page_clinics_div_html.each do |p_tag|
    # state = state_page.css( 'div.panes div h3.state-name' ).text

    if p_tag.children.length == 3

      name = remove_whitespace(p_tag.children[0])
      full_address = "#{remove_whitespace(p_tag.children[1])}, #{remove_whitespace(p_tag.children[2])}"
      address = remove_whitespace(p_tag.children[1])
      city = remove_whitespace(p_tag.children[2]).match(/.+?(?=,)/)
      zip = remove_whitespace(p_tag.children[2]).match(/\d{5}/)

      CSV.open('parsed_results_three_rows.csv', "ab:UTF-8") do |csv|
        csv << [name, full_address, address, city, state, zip]
      end

    elsif p_tag.children.length == 1
      first_row = remove_whitespace(p_tag.children[0])
      CSV.open('parsed_results_one_row.csv', "ab:UTF-8") do |csv|
        csv << [first_row]
      end

    elsif p_tag.children.length == 2
      first_row = remove_whitespace(p_tag.children[0])
      second_row = remove_whitespace(p_tag.children[1])
      CSV.open('parsed_results_two_rows.csv', "ab:UTF-8") do |csv|
        csv << [first_row, second_row]
      end

    elsif p_tag.children.length == 4
      first_row = remove_whitespace(p_tag.children[0])
      second_row = remove_whitespace(p_tag.children[1])
      third_row = remove_whitespace(p_tag.children[2])
      fourth_row = remove_whitespace(p_tag.children[3])
      CSV.open('parsed_results_four_rows.csv', "ab:UTF-8") do |csv|
        csv << [first_row, second_row, third_row, fourth_row]
      end

    elsif p_tag.children.length == 5
      first_row = remove_whitespace(p_tag.children[0])
      second_row = remove_whitespace(p_tag.children[1])
      third_row = remove_whitespace(p_tag.children[2])
      fourth_row = remove_whitespace(p_tag.children[3])
      fifth_row = remove_whitespace(p_tag.children[4])
      CSV.open('parsed_results_five_rows.csv', "ab:UTF-8") do |csv|
        csv << [first_row, second_row, third_row, fourth_row, fifth_row]
      end

    elsif p_tag.children.length == 6
      first_row = remove_whitespace(p_tag.children[0])
      second_row = remove_whitespace(p_tag.children[1])
      third_row = remove_whitespace(p_tag.children[2])
      fourth_row = remove_whitespace(p_tag.children[3])
      fifth_row = remove_whitespace(p_tag.children[4])
      sixth_row = remove_whitespace(p_tag.children[5])
      CSV.open('parsed_results_six_rows.csv', "ab:UTF-8") do |csv|
        csv << [first_row, second_row, third_row, fourth_row, fifth_row, sixth_row]
      end

    elsif p_tag.children.length == 7
      first_row = remove_whitespace(p_tag.children[0])
      second_row = remove_whitespace(p_tag.children[1])
      third_row = remove_whitespace(p_tag.children[2])
      fourth_row = remove_whitespace(p_tag.children[3])
      fifth_row = remove_whitespace(p_tag.children[4])
      sixth_row = remove_whitespace(p_tag.children[5])
      seventh_row = remove_whitespace(p_tag.children[6])
      CSV.open('parsed_results_seven_rows.csv', "ab:UTF-8") do |csv|
        csv << [first_row, second_row, third_row, fourth_row, fifth_row, sixth_row, seventh_row]
      end

    end

  end
end





def remove_whitespace(node)
  node_text = node.text
  node_text.sub!(/(\\t|\\r|\\n)/, "")
  node_text.sub!(/^\s*/, "")
  node_text.sub!(/(\\t|\\r|\\n|\s)*$/, "")
  node_text.gsub!("/", " ")
  node_text.gsub!(/[#'&½’"¼-]/, "")
  node_text.gsub(/\s\s/, " ")
end

def po_box?(text)
  (text.match("P.O. Box")||text.match("PO Box"))
end

def useless_data(node)
  if (node.name == "br") || (node.name == "a")
    return true
  else
    return false
  end
end

def useless_text?(node_text)
  if
    (node_text.match("Website:")) ||
    (node_text.match("Email:")) ||
    (node_text.match("E-Mail:")) ||
    (node_text.match("email:")) ||
    (node_text.match("Website:")) ||
    (node_text.match("website")) ||
    (node_text.match("Facebook:")) ||
    (node_text.match("Web Site:")) ||
    (node_text.match("www.")) ||
    (node_text.match(".com")) ||
    (node_text.match(".org")) ||
    (node_text.match(".net")) ||
    (node_text.match("hotline"))||
    (node_text.match("Hotline"))||
    (node_text.match("Helpline"))||
    (node_text.match(".SAFE"))||
    (node_text.match("1.800."))||
    (node_text.match(/\d{3}.HELP/))||
    (node_text.match("Text:"))||
    (node_text.match(/\d{3}.CALM"/))||
    (node_text.match("Hours:"))||
    (node_text.match("Age 18"))||
    (node_text.match("Under 18"))||
    (node_text.match("^or"))||
    (node_text.match("18 yrs"))||
    (node_text.match("21 yrs"))||
    (node_text.match("Limited ultrasound"))||
    (node_text.match("limited ultrasound"))||
    (node_text.match("Services provided"))||
    (node_text.match("Limited OB"))||
    (node_text.match("Post abortion"))||
    (node_text.match("Adoption referrals"))||
    (node_text.match("closed"))||
    (node_text.match("Closed"))||
    (node_text.match("Monday"))||
    (node_text.match("Foster care"))||
    (node_text.match("Lakefront Plaza"))||
    (node_text.match("South College Medical"))||
    (node_text.match("end inside-content"))||
    (node_text.match("Building 2, Unit 201A"))||
    (node_text.match("Abortion pill reversal"))||
    (node_text.match("Able to travel"))||
    (node_text.match("1.888."))||
    (node_text.match(/\d*am-\d*pm/))||
    (node_text.match(/\d{3}.\d{3}.\d{3}/))||
    (node_text.match(/\d*:\d*(a|p)m-\d*:\d*(a|p)m/))||
    (node_text.match(/\(\d{3}\)\s\d{3}-\d{4}/))||
    ((node_text.gsub(/\D/, "").length == (10)) && node_text.gsub(/\d/, "").length < 4)||
    (node_text.gsub(/\D/, "").length == (11)) ||
    (node_text.length <= 1)
    true
  elsif
    node_text.sub!(/(\\t|\\r|\\n)/, "")
    node_text.sub!(/^\s*/, "")
    true if node_text.length === 0
  else
    false
  end
end

def state_names_in_array
  ["Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland_dc", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New_Hampshire", "New_Jersey", "New_Mexico", "New_York", "North_Carolina", "North_Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode_Island", "South_Carolina", "South_Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West_Virginia", "Wisconsin", "Wyoming"]
end

def state_names_and_abbrev_in_hash
  {"Alabama"=>"AL", "Alaska"=> "AK", "Arizona"=>"AZ", "Arkansas"=>"AR", "California"=>"CA", "Colorado"=>"CO", "Connecticut"=>"CT", "Delaware"=>"DE", "Florida"=>"FL", "Georgia"=>"GA", "Hawaii"=>"HI", "Idaho"=>"ID", "Illinois"=>"IL", "Indiana"=>"IN", "Iowa"=>"IA", "Kansas"=>"KS", "Kentucky"=>"KY", "Louisiana"=>"LA", "Maine"=>"ME", "Maryland & D.C."=>"MD", "Massachusetts"=>"MA", "Michigan"=>"MI", "Minnesota"=>"MN", "Mississippi"=>"MS", "Missouri"=>"MO", "Montana"=>"MT", "Nebraska"=>"NE", "Nevada"=>"NV", "New_Hampshire"=>"NH", "New Jersey"=>"NJ", "New Mexico"=>"NM", "New York"=>"NY", "North Carolina"=>"NC", "North Dakota"=>"ND", "Ohio"=>"OH", "Oklahoma"=>"OK", "Oregon"=>"OR", "Pennsylvania"=>"PA", "Rhode Island"=>"RI", "South Carolina"=>"SC", "South Dakota"=>"SD", "Tennessee"=>"TN", "Texas"=>"TX", "Utah"=>"UT", "Vermont"=>"VT", "Virginia"=>"VA", "Washington"=>"WA", "West Virginia"=>"WV", "Wisconsin"=>"WI", "Wyoming"=>"WY"}
end

life_call_parser_cpcs




