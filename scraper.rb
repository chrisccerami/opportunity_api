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

paths.each do |path|
  photos_page = Nokogiri::HTML(open(BASE_URI + path))
  table = photos_page.css("table")[10]
  photos = table.css("img[border='1']")
  photos.each do |photo|
    src = photo.attributes["src"].value
    parts = src.split("/")
    sol = parts[2]
    camera = parts[1]
  end
end
