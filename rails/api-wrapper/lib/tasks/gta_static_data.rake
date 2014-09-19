namespace :gta_static_data do
  desc 'Refresh all GTA Static Data'
  task :refresh_all => [:refresh_countries, :refresh_cities, :refresh_locations, :refresh_room_types, :refresh_sightseeing_categories, :refresh_sightseeing_types]

  desc 'Refresh GTA Static Data countries'
  task :refresh_countries => :environment do
    puts 'Loading GTA countries...'
    response = GtaStaticData.search_country
    if response.code == 200
      data = response.to_hash
      countries = data['Response']['ResponseDetails']['SearchCountryResponse']['CountryDetails']['Country']
      countries.each { |country|
        code = country['Code']
        name = country['__content__']
        existing_country = GtaCountry.find_by_code code
        if existing_country.present?
          if existing_country.name != name
            existing_country.name = name
            existing_country.save!
          end
        else
          GtaCountry.create! :code => code, :name => name
        end
      }
    end

  end

  desc 'Refresh GTA Static Data cities'
  task :refresh_cities => :environment do
    puts 'Loading GTA cities...'
    countries = GtaCountry.all
    countries.each { |country|
      puts "Loading GTA cities of #{country.name}..."
      response = GtaStaticData.search_city :country_code => country.code
      if response.code == 200
        data = response.to_hash
        next if data['Response']['ResponseDetails']['SearchCityResponse']['CityDetails'].blank?
        cities = data['Response']['ResponseDetails']['SearchCityResponse']['CityDetails']['City']
        if cities.class == Array
          cities.each { |city|
            code = city['Code']
            name = city['__content__']
            existing_city = GtaCity.find_by_code code
            if existing_city.present?
              if existing_city.name != name
                existing_city.name = name
                existing_city.save!
              end
            else
              GtaCity.create! :code => code, :name => name, :gta_country_id => country.id
            end
          }
        elsif cities.class == Hash
          city = cities
          puts city
          code = city['Code']
          name = city['__content__']
          existing_city = GtaCity.find_by_code code
          if existing_city.present?
            if existing_city.name != name
              existing_city.name = name
              existing_city.save!
            end
          else
            GtaCity.create! :code => code, :name => name, :gta_country_id => country.id
          end
        end

      end
    }
  end

  desc 'Refresh GTA Static Data room types'
  task :refresh_room_types => :environment do
    puts 'Loading GTA room types...'
    response = GtaStaticData.search_room_type
    if response.code == 200
      data = response.to_hash
      room_types = data['Response']['ResponseDetails']['SearchRoomTypeResponse']['RoomTypeDetails']['RoomType']
      room_types.each { |room_type|
        code = room_type['Code']
        name = room_type['__content__']
        existing_room_type = GtaRoomType.find_by_code code
        if existing_room_type.present?
          if existing_room_type.name != name
            existing_room_type.name = name
            existing_room_type.save!
          end
        else
          GtaRoomType.create! :code => code, :name => name
        end
      }
    end

  end

  desc 'Refresh GTA Static Data locations'
  task :refresh_locations => :environment do
    puts 'Loading GTA generic locations...'
    response = GtaStaticData.search_location
    if response.code == 200
      data = response.to_hash
      locations = data['Response']['ResponseDetails']['SearchLocationResponse']['LocationDetails']['Location']
      locations.each { |location|
        code = location['Code']
        name = location['__content__']
        existing_location = GtaLocation.find_by_code code
        if existing_location.present?
          if existing_location.name != name
            existing_location.name = name
            existing_location.save!
          end
        else
          GtaLocation.create! :code => code, :name => name
        end
      }
    end

    # Locations for each city
    #cities = GtaCity.all
    #cities.each { |city|
    #  puts "Loading GTA location of #{city.name}, #{city.gta_country.name}"
    #  response = GtaStaticData.search_location :city_code => city.code
    #  if response.code == 200
    #    data = response.to_hash
    #    locations = data['Response']['ResponseDetails']['SearchLocationResponse']['LocationDetails']['Location']
    #    puts locations
    #    locations.each { |location|
    #      code = location['Code']
    #      name = location['__content__']
    #      existing_location = GtaLocation.find_by_code_and_gta_city_id code, city.id
    #      if existing_location.present?
    #        if existing_location.name != name
    #          existing_location.name = name
    #          existing_location.save!
    #        end
    #      else
    #        GtaLocation.create! :code => code, :name => name, :gta_city_id => city.id
    #      end
    #    }
    #  end
    #}

  end

  desc 'Refresh GTA Static Data sightseeing categories'
  task :refresh_sightseeing_categories => :environment do
    puts 'Loading GTA sightseeing categories...'
    response = GtaStaticData.search_sightseeing_category
    if response.code == 200
      data = response.to_hash
      sightseeing_categories = data['Response']['ResponseDetails']['SearchSightseeingCategoryResponse']['SightseeingCategories']['SightseeingCategory']
      sightseeing_categories.each { |sightseeing_category|
        code = sightseeing_category['Code']
        name = sightseeing_category['__content__']
        existing_sightseeing_category = GtaSightseeingCategory.find_by_code code
        if existing_sightseeing_category.present?
          if existing_sightseeing_category.name != name
            existing_sightseeing_category.name = name
            existing_sightseeing_category.save!
          end
        else
          GtaSightseeingCategory.create! :code => code, :name => name
        end
      }
    end

  end

  desc 'Refresh GTA Static Data sightseeing types'
  task :refresh_sightseeing_types => :environment do
    puts 'Loading GTA sightseeing types...'
    response = GtaStaticData.search_sightseeing_type
    if response.code == 200
      data = response.to_hash
      sightseeing_types = data['Response']['ResponseDetails']['SearchSightseeingTypeResponse']['SightseeingTypes']['SightseeingType']
      sightseeing_types.each { |sightseeing_type|
        code = sightseeing_type['Code']
        name = sightseeing_type['__content__']
        existing_sightseeing_type = GtaSightseeingType.find_by_code code
        if existing_sightseeing_type.present?
          if existing_sightseeing_type.name != name
            existing_sightseeing_type.name = name
            existing_sightseeing_type.save!
          end
        else
          GtaSightseeingType.create! :code => code, :name => name
        end
      }
    end

  end

  desc 'Refresh GTA Static Data hotels'
  task :refresh_hotels => :environment do
    puts 'Loading GTA hotels...'
    cities = GtaCity.all
    cities_count = cities.count
    cities.each_with_index { |city, index|
      percentage = ((index + 1).to_f / cities_count.to_f)
      puts "Loading GTA hotels of city #{index + 1}/#{cities_count}: #{city.name}... #{percentage.round(2)}%"
      response = GtaStaticData.search_item :destination => { :type => 'city', :code => city.code }, :type => 'hotel'
      if response.code == 200
        data = response.to_hash
        # TODO: save hotels data to DB
      end
    }
  end

  desc 'Download GTA Static Data item information'
  task :download_item_information => :environment do
    puts 'Downloading GTA item information (please be patient)...'
    response = GtaStaticData.download_item_information :timeout => 60 * 30 # timeout 30 minutes
    if response.code == 200
      filename = "#{Rails.root}/tmp/gta_item_information.zip"
      puts "Response headers: #{response.headers['content-type']}"
      puts "Saving file to #{filename}..."
      File.open(filename, 'wb') {|f| f.write(response.body) }
    end
  end

end
