require "net/http"
require "nokogiri"
require "open-uri"
require "pry"

BASE_URI = "http://mars.nasa.gov/mer/gallery/all/"

SOL_SELECT_CSS_PATHS = [
"#Engineering_Cameras_Front_Hazcam",
"#Engineering_Cameras_Rear_Hazcam",
"#Engineering_Cameras_Navigation_Camera",
"#Engineering_Cameras_Panoramic_Camera",
"#Engineering_Cameras_Microscopic_Imager",
"select[id^=Engineering_Cameras_Entry]"
]

CAMERAS = {
  f: "FHAZ",
  r: "RHAZ",
  n: "NAVCAM",
  p: "PANCAM",
  m: "MINITES",
  e: "ENTRY"
}

doc = Nokogiri::HTML(open(BASE_URI + "opportunity.html"))

paths = Array.new
SOL_SELECT_CSS_PATHS.each do |s|
  select = doc.css(s).first
  select.css("option").each do |option|
    paths << option.attributes["value"].value
  end
end

paths.first(10).each do |path|
  photos_page = Nokogiri::HTML(open(BASE_URI + path))
  table = photos_page.css("table")[10]
  photo_links = table.css("tr[bgcolor='#F4F4E9']").map { |p| p.css("a") }
  photo_links.each do |links|
    links.each do |link|
      path = link.attributes["href"].value
      parts = path.split("/")
      sol = parts[2].to_i
      camera = CAMERAS[parts[1].to_sym]
      photo_page = Nokogiri::HTML(open(BASE_URI + path))
      early_path = path.scan(/\d\/\w\/\d+\//).first
      src = BASE_URI + early_path + photo_page.css("table")[10].css("img").first.attributes["src"].value
    end
  end
end
