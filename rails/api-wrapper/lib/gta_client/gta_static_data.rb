# GTA Static Data API request functions wrapper
module GtaStaticData
  # The Search Country provides the client with static data relating to countries held within the GTA system.
  # The API will provide a country name along with the unique code used by GTA to identify the country.
  def self.search_country(options = {})
    xml = %q(
      <SearchCountryRequest ISO="true" />
    )

    GtaClient::Client.instance.request(xml, options)
  end

  # The Search City provides the client with static data relating to cities held within the GTA system.
  # The API will provide a city name along with the unique code used by GTA to identify the city.
  def self.search_city(options = {})
    xml = %Q(
      <SearchCityRequest ISO="true" CountryCode="#{options[:country_code]}" />
    )

    GtaClient::Client.instance.request(xml, options)
  end

  # The Search Location provides the client with static data relating to locations held within the GTA system.
  # The API will provide a location name and city code along with the unique code used by GTA to identify the location.
  def self.search_location(options = {})
    xml = %Q(
      <SearchLocationRequest CityCode="#{options[:city_code]}" />
    )

    GtaClient::Client.instance.request(xml, options)
  end

  # The Search Area provides the client with static data relating to areas held within the GTA system.
  # The API will provide an area name along with the unique code used by GTA to identify the area.
  def self.search_area(options = {})
    xml = %q(
      <SearchAreaRequest />
    )

    GtaClient::Client.instance.request(xml, options)
  end

  # The Search Cities in Area provides the client with static data relating to cities within an area held within the
  # GTA system. The API will provide a list of cities and their corresponding names for the area code provided.
  def self.search_cities_in_area(options = {})
    xml = %Q(
      <SearchCitiesInAreaRequest AreaCode="#{options[:area_code]}" />
    )

    GtaClient::Client.instance.request(xml, options)
  end

  # The Search Currency provides the client with static data relating to currencies held within the GTA system.
  # The API will provide a currency name along with the unique ISO code to identify the currency.
  def self.search_currency(options = {})
    xml = %q(
      <SearchCurrencyRequest />
    )

    GtaClient::Client.instance.request(xml, options)
  end

  # The Search Room Types provides the client with static data relating to room types held within the GTA system.
  # The API will provide a room type name along with the unique code used by GTA to identify the room type.
  def self.search_room_type(options = {})
    xml = %q(
      <SearchRoomTypeRequest />
    )

    GtaClient::Client.instance.request(xml, options)
  end

  # The Search Item provides the client with static data relating to apartment, hotel and sightseeing items held within
  # the GTA system. The API will provide an item description along with the unique code used by GTA to identify the item.
  def self.search_item(options = {})
    if options[:destination].present?
      destination_xml = %Q(<ItemDestination DestinationType="#{options[:destination][:type]}" DestinationCode="#{options[:destination][:code]}" />)
    end

    xml = %Q(
      <SearchItemRequest ItemType="#{options[:type]}">
        #{destination_xml}
      </SearchItemRequest>
    )

    GtaClient::Client.instance.request(xml, options)
  end

  # The Search Item Information provides the client with varying levels of static information relating to apartment,
  # hotel and sightseeing items held within the GTA system. The client will be allowed to request various “bundles” of
  # pre-defined information by specifying the appropriate parameters.
  def self.search_item_information(options = {})
    if options[:destination].present?
      destination_xml = %Q(<ItemDestination DestinationType="#{options[:destination][:type]}" DestinationCode="#{options[:destination][:code]}" />)
    end

    xml = %Q(
      <SearchItemInformationRequest ItemType="#{options[:type]}">
        #{destination_xml}

        <ItemCode>#{options[:item_code]}</ItemCode>
      </SearchItemInformationRequest>
    )

    GtaClient::Client.instance.request(xml, options)
  end

  # The Search Sightseeing Type request provides the client with static data relating to sightseeing types held within
  # the GTA system. The API will provide a sightseeing type name along with the unique code used by GTA to identify the
  # sightseeing type.
  def self.search_sightseeing_type(options = {})
    xml = %q(
      <SearchSightseeingTypeRequest />
    )

    GtaClient::Client.instance.request(xml, options)
  end

  # The Search Sightseeing Category request provides the client with static data relating to sightseeing categories
  # held within the GTA system. The API will provide a sightseeing category name along with the unique code used by GTA
  # to identify the sightseeing category.
  def self.search_sightseeing_category(options = {})
    xml = %q(
      <SearchSightseeingCategoryRequest />
    )

    GtaClient::Client.instance.request(xml, options)
  end

  # The Search Hotel Group request provides the client with a file which will group together hotel codes where multiple
  # GTA codes exist for different room categories at the same hotel.
  def self.search_hotel_group(options = {})
    if options[:destination].present?
      destination_xml = %Q(<ItemDestination DestinationType="#{options[:destination][:type]}" DestinationCode="#{options[:destination][:code]}" />)
    end

    xml = %Q(
      <SearchHotelGroupRequest>
        #{destination_xml}
      </SearchHotelGroupRequest>
    )

    GtaClient::Client.instance.request(xml, options)
  end

  def self.download_item_information(options = {})
    options[:type] ||= 'hotel'

    xml = %Q(
      <ItemInformationDownloadRequest ItemType="#{options[:type]}" > </ItemInformationDownloadRequest>
    )

    GtaClient::Client.instance.request(xml, options)
  end
end
