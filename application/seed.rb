require('pry')
require_relative('models/artist')
require_relative('models/genre')
require_relative('models/album')
require_relative('models/supplier')
require_relative('models/customer')

DbHelper.run_sql_no_prep(File.new("./db/music_store_database.sql").read())


#Genres
genres = ["Pop", "Rock", "Death Metal", "Disco",
          "Hip Hop", "Country", "Singing", "Classical", "Punk Rock",
          "Reggae", "Rap", "Funk", "Techno", "Electronic", "Soul", "Opera", "Grunge", "New Wave"]

genres.each do |genre|
  Genre.new({"gen_name" => genre}).save()
end


#Artists & Albums
artits_albums =
[
  { name: "U2" , album: ["All That You Can't Leave Behind", "War", "Achtung Baby", "Please"]},
  { name: "Massive Attack" , album: ["Blue Lines"]},
  { name: "Roxy Music" , album: ["For Your Pleasure", "Siren"]},
  { name: "M.I.A." , album: ["Kala"]},
  { name: "The Beatles" , album: ["Let It Be", "Help", "A Hard Day's Night"]},
  { name: "Jackson Browne" , album: ["The Pretender", "Late for the Sky"]},
  { name: "The White Stripes" , album: ["Elephant"]},
  { name: "Bob Dylan" , album: ["Love and Theft", "John Wesley Harding", "The Basement Tapes"]},
  { name: "The Who" , album: ["A Quick One", "Quadrophenia", "The Who Sings My Generation", "Live at Leeds"]},
  { name: "Modern Lovers" , album: ["Modern Lovers"]},
  { name: "Oasis" , album: ["Morning Glory"]},
  { name: "Bjork" , album: ["Post"]},
  { name: "Jefferson Airplane" , album: ["Volunteers"]},
  { name: "The Police" , album: ["Reggatta de Blanc", "Ghost in the Machine"]},
  { name: "Arctic Monkeys" , album: ["Whatever People Say"]},
  { name: "The Doors" , album: ["LA Woman"]},
  { name: "Dire Straits" , album: ["Brothers in Arms"]},
  { name: "Neil Young" , album: ["Rust Never Sleeps", "Tonight is the Night"]},
  { name: "Lou Reed" , album: ["Berlin", "Transformer"]},
  { name: "Meat Loaf" , album: ["Bat Out of Hell"]},
  { name: "Moby" , album: ["Play"]},
  { name: "Radiohead" , album: ["In Rainbows", "Amnesiac"]},
  { name: "James Brown" , album: ["In the Jungle Groove"]},
  { name: "The Cure" , album: ["Disintegration"]},
  { name: "Eric Clapton" , album: ["Slowhand"]},
  { name: "David Bowie" , album: ["Station to Station", "Aladdin Sane"]},
  { name: "Nick Drake" , album: ["Pink Moon"]},
  { name: "Red Hot Chili Peppers" , album: ["Blood Sugar Sex Magik"]},
  { name: "Grateful Dead" , album: ["Anthem of the Sun"]},
  { name: "The Rolling Stones" , album: ["Some Girls", "Tattoo You"]},
  { name: "Metallica" , album: ["Master of Puppets"]},
  { name: "Aerosmith" , album: ["Toys in the Attic"]},
  { name: "Pink Floyd" , album: ["Wish You Were Here"]},
  { name: "Cat Stevens" , album: ["Tea for the Tillerman"]},
  { name: "Santana" , album: ["Abraxas"]},
  { name: "Michael Jackson" , album: ["Bad"], "photo" => "michaeljackson"},
  { name: "Bob Marley" , album: ["Natty Dread"]},
  { name: "Led Zeppelin" , album: ["Houses of the Holy", "Stairway to Heaven"]}
]



artits_albums.each do |art|
  artist = Artist.new({"art_name" => art[:name]})
  artist.save

  art[:album].each do |album|
    options = { "alb_title" => album,
                "alb_price" => (8..50).to_a.sample,
                "alb_image" => album.downcase,
                "alb_art_id" => artist.art_id,
                "alb_gen_id" => (1..4).to_a.sample,
                "alb_qty_available" => (0..20).to_a.sample,
                "alb_qty_min" => (0..5).to_a.sample,
                "alb_qty_max" => (10..20).to_a.sample}

    image = options["alb_image"].split(" ")

    image_name = ""
    image.each do |item|
      image_name += item
    end

    image = image_name.split("'")
    image_name = ""
    image.each do |item|
      image_name += item
    end

    options["alb_image"] = image_name

    Album.new(options).save()
  end

end



#Suppliers
suppliers = ["Epic", "PolyGram", "Warner Music", "Island Record", "Mercury"]

suppliers.each do |supplier|
  Supplier.new({"sup_name" => supplier}).save()
end

#Customers
customers = ["Batman", "Iron Man", "Silver Surfer", "Tornade", "Emma Frost", "Marge", "Homer", "Jane"]

customers.each do |customer|
  Customer.new({"cus_name" => customer}).save()
end
