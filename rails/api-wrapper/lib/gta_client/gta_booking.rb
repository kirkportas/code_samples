# GTA Booking API request functions wrapper
module GtaBooking
  # Generate random string with specified length. To be used to generate booking code
  def self.generate_random_string(length = 8)
    chars = ('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a
    chars_length = chars.length

    random_string = ''
    (0..(length - 1)).each { |i| random_string += chars[rand(chars_length)] }

    random_string
  end

  # Generate unique booking code to make booking request
  def self.generate_booking_code
    "TJ-#{self.generate_random_string}-#{DateTime.now.to_i}"
  end

  # This request is used to add new bookings through the API.
  def self.add_booking(options = {})
    if (options[:pax_names].present?)
      pax_names_xml = options[:pax_names].each_with_index.map { |pax_name, pax_index|
        if (pax_name[:pax_type].present? && pax_name[:child_age].present?)
          %Q(<PaxName PaxId="#{pax_index}" PaxType="#{pax_name[:pax_type]}" ChildAge="#{pax_name[:child_age]}">#{pax_name[:pax_name]}}</PaxName>)
        else
          %Q(<PaxName PaxId="#{pax_index}">#{pax_name[:pax_name]}</PaxName>)
        end
      }.join

      pax_names_xml = %Q(<PaxNames>#{pax_names_xml}</PaxNames>)
    end

    if (options[:booking_items].present?)
      booking_items_xml = options[:booking_items].each_with_index.map { |booking_item, item_index|
        if (options[:hotel_item]).present?
          if options[:hotel_item][:period_of_stay].present?
            period_of_stay_xml = %Q(
              <PeriodOfStay>
                <CheckInDate>#{options[:hotel_item][:period_of_stay][:check_in_date].to_date.to_s(:locale => :en_US)}</CheckInDate>
                <Duration>#{options[:hotel_item][:period_of_stay][:duration]}</Duration>
              </PeriodOfStay>
            )
          end



          hotel_item_xml = %Q(
            <HotelItem>
              #{period_of_stay_xml}
            </HotelItem>
          )
        end

        %Q(
          <BookingItem ItemType="#{booking_item[:item_type]}">
            <ItemReference>#{item_index}</ItemReference>
            <ItemCity Code="#{booking_item[:item_city_code]}"/>
            <Item Code="#{booking_item[:item_code]}"/>
            #{hotel_item_xml}
          </BookingItem>
        )
      }.join

      booking_items_xml = %Q(<BookingItems>#{}</BookingItems>)
    end

    xml = %Q(
      <AddBookingRequest>
        <BookingReference>#{self.generate_booking_code}</BookingReference>
        #{pax_names_xml}
        #{booking_items_xml}
      </AddBookingRequest>
    )

    options[:request_mode] ||= GtaConstant::REQUEST_MODE::ASYNCHRONOUS
    GtaClient::Client.instance.request(xml, options)
  end
end
