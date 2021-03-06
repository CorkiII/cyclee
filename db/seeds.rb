Hotspot.destroy_all
Parking.destroy_all
Danger.destroy_all
Ride.destroy_all
User.destroy_all

filepath = 'db/scrape/parkings_spots.json'
@parkings_all = JSON.parse(File.read(filepath))
# Spot.where(category: "parking").near([destination_latitude, destination_longitude], 1, units: :km)
@parkings = @parkings_all.select do |element|
  element['geometry']['coordinates'][1].between?(48.8155755, 48.902156) &&
    element['geometry']['coordinates'][0].between?(2.224122, 2.4697602)
end
@parking_markers = @parkings.map do |element|
  {
    lat: element['geometry']['coordinates'][1],
    lng: element['geometry']['coordinates'][0]
    # image_url: helpers.asset_url('parking') // a creuser pour remplacer l'image du marker
  }
end

@parking_markers.each do |parking_marker|
  Hotspot.create!(category: "parking", latitude: parking_marker[:lat], longitude: parking_marker[:lng])
end

filepath = 'db/scrape/pumps_spots.yaml'
@pumps = YAML.load_file(filepath)

@pumps.each do |pump|
  Hotspot.create!(category: "pump", latitude: pump[:lat], longitude: pump[:lng])
end


filepath = 'db/scrape/bikes_shops_spots.yaml'
@repairers_data = YAML.load_file(filepath)

@repairers = @repairers_data.map do |repairer|
  {
    lat: repairer[:latitude],
    lng: repairer[:longitude]
  }
end

@repairers.each do |repairer|
  Hotspot.create!(category: "repairer", latitude: repairer[:lat], longitude: repairer[:lng])
end

puts "Parkings, pumps and repairers succesfully created!"


# Pour afficher des dangers sur la show
filepath = 'db/scrape/show_danger.yaml'
@dangers_list_data = YAML.load_file(filepath)

@dangers_list = @dangers_list_data.map do |danger_list|
  {
    lat: danger_list[:latitude],
    lng: danger_list[:longitude],
    cat: danger_list[:category]
  }
end
user = User.create(email: "test@test.com", password: 123123)
ride = Ride.create(user: user, origin_longitude: 2.377265, origin_latitude: 48.855393, destination_longitude: 2.362258, destination_latitude: 48.863521, destination_address: "28, rue de Rivoli, Paris France")
@dangers_list.each do |danger_list|
  Danger.create!(category: danger_list[:cat], latitude: danger_list[:lat], longitude: danger_list[:lng], ride: ride)
end







