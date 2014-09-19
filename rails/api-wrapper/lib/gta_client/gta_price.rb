# GTA Price API request functions wrapper
module GtaPrice
  # The Search Hotel Price provides the client with the ability to search for and price available hotel rooms through
  # the API.
  #
  # @param
  #   options = {
  #     :destination => { :type => 'city', :code => 'NYC' },
  #     :period_of_stay => { :check_in_date => DateTime.now.advance(:months => 2), :duration => 4 },
  #     :rooms => [
  #       { :code => 'DB', :number_of_rooms => 1, :extra_beds => [ { :age => 4 } ] }
  #     ]
  #   }
  def self.search_hotel_price(options = {})
    if options[:destination].present?
      destination_xml = %Q(<ItemDestination DestinationType="#{options[:destination][:type]}" DestinationCode="#{options[:destination][:code]}" />)
    end

    if options[:period_of_stay].present?
      period_of_stay_xml = %Q(
        <PeriodOfStay>
          <CheckInDate>#{options[:period_of_stay][:check_in_date].to_date.to_s(:locale => :en_US)}</CheckInDate>
          <Duration>#{options[:period_of_stay][:duration]}</Duration>
        </PeriodOfStay>
      )
    end

    if options[:rooms].present?
      rooms_xml = options[:rooms].map{ |room|
        if room[:extra_beds].present?
          extra_beds_xml = room[:extra_beds].map { |extra_bed|
            %Q(<Age>#{extra_bed[:age]}</Age>)
          }
          extra_beds_xml = %Q(<ExtraBeds>#{extra_beds_xml}</ExtraBeds>)
        end

        number_of_rooms_attr = %Q( NumberOfRooms="#{room[:number_of_rooms]}") if room[:number_of_rooms].present?
        number_of_cots_attr = %Q( NumberOfCots="#{room[:number_of_cots]}") if room[:number_of_cots].present?

        %Q(<Room Code="#{room[:code]}"#{number_of_rooms_attr}#{number_of_cots_attr}>#{extra_beds_xml}</Room>)
      }.join

      rooms_xml = %Q(<Rooms>#{rooms_xml}</Rooms>)
    end

    xml = %Q(
      <SearchHotelPriceRequest>
        #{destination_xml}
        #{period_of_stay_xml}
        #{rooms_xml}
      </SearchHotelPriceRequest>
    )

    GtaClient::Client.instance.request(xml, options)
  end

  # The Search Sightseeing Price provides the client with the ability to search for and price available sightseeing
  # items through the API.
  #
  # @param
  #   options = {
  #     :destination => { :type => 'city', :code => 'NYC' },
  #     :tour_date => DateTime.now.advance(:months => 2),
  #     :number_of_adults => 2,
  #     :children => [{ :age => 3 }]
  #   }
  def self.search_sightseeing_price(options = {})
    if options[:destination].present?
      destination_xml = %Q(<ItemDestination DestinationType="#{options[:destination][:type]}" DestinationCode="#{options[:destination][:code]}" />)
    end

    if options[:tour_date].present?
      tour_date_xml = %Q(<TourDate>#{options[:tour_date].to_date.to_s(:locale => :en_US)}</TourDate>)
    end

    if options[:number_of_adults].present?
      number_of_adults_xml = %Q(<NumberOfAdults>#{options[:number_of_adults].to_i}</NumberOfAdults>)
    end

    if options[:children].present?
      children_xml = options[:children].map { |child|
        %Q(<Age>#{child[:age]}</Age>)
      }.join

      children_xml = %(<Children>#{children_xml}</Children>)
    end

    xml = %Q(
      <SearchSightseeingPriceRequest>
        #{destination_xml}
        #{tour_date_xml}
        #{number_of_adults_xml}
        #{children_xml}
      </SearchSightseeingPriceRequest>
    )

    GtaClient::Client.instance.request(xml, options)
  end
end
