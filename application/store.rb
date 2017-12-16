require('pry')
require_relative('models/artist')
require_relative('models/genre')
require_relative('models/album')
require_relative('models/stock_album')

DbHelper.run_sql_no_prep(File.new("./db/music_store_database.sql").read())


# SECTION ARTISTS
# art_ledzep = Artist.new({"art_name" => "Led Zepelin"})
# puts art_ledzep.art_name
# art_ledzep.save()
# puts art_ledzep.art_name
#
# art_ledzep.art_name = "Led Zeppelin"
# p art_ledzep
# art_ledzep.save()
# puts art_ledzep.art_name
#
# Artist.delete(art_ledzep)
# art_ledzep = Artist.find_by_id(art_ledzep.art_id)
# p art_ledzep
#
# art_ledzep = Artist.new({"art_name" => "Led Zepelin"})
# art_ledzep.save()
#
# art_ledzep = Artist.find_by_id(art_ledzep.art_id)
# p art_ledzep

# SECTION GENRE
# gen_rock = Genre.new({"gen_name" => "Rockk"})
# puts gen_rock.gen_name
# gen_rock.save()
# puts gen_rock.gen_name
#
# gen_rock.gen_name = "Rock"
# p gen_rock
# gen_rock.save()
# p gen_rock
#
# Genre.delete(gen_rock)
# gen_rock = Genre.find_by_id(gen_rock.gen_id)
# p gen_rock
#
# gen_rock = Genre.new({"gen_name" => "Rock"})
# gen_rock.save()
#
# gen_rock = Genre.find_by_id(gen_rock.gen_id)
# p gen_rock


# SECTION ALBUM

u2       = Artist.new({"art_name" => "U2"})
u2.save()
pop_rock = Genre.new({"gen_name" => "Pop/Rock"})
pop_rock.save()

song_of_innocence_options = { "alb_title" => "Song of innocence",
                             "alb_price" => 15,
                             "alb_cover_image" => "son_of_innocence.jpg",
                             "alb_art_id" => u2.art_id,
                             "alb_gen_id" => pop_rock.gen_id}

song_of_innocence = Album.new(song_of_innocence_options)
song_of_innocence.save()
p song_of_innocence

stock_song_of_innocence_options = { "sto_qty_available"  => 5,
                                    "sto_qty_min"        => 3,
                                    "sto_qty_max"        => 10,
                                    "sto_alb_id"         => song_of_innocence.alb_id,
                                    "album"              => song_of_innocence}
stock_song_of_innocence = StockAlbum.new(stock_song_of_innocence_options)
stock_song_of_innocence.save()
p stock_song_of_innocence
