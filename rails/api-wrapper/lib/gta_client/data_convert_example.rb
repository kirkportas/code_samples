# Examples of data conversion back and forth between XML, JSON and YAML

require 'rubygems'
require 'xmlsimple' # gem install xml-simple
require 'yaml'

xml_data = %q(
<AddBookingRequest Currency="GBP">
  <BookingName>MC20031301</BookingName>
  <BookingReference>MC20031201a</BookingReference>
  <BookingDepartureDate>2004-01-01</BookingDepartureDate>
  <PaxNames>
    <PaxName PaxId="1">Mr John Doe</PaxName>
    <PaxName PaxId="2">Mrs Sarah Doe</PaxName>
  </PaxNames>
  <BookingItems>
    <BookingItem ItemType="hotel">
      <ItemReference>1</ItemReference>
      <ItemCity Code="AMS" />
      <Item Code="NAD" />
      <HotelItem>
        <PeriodOfStay>
          <CheckInDate>2004-01-01</CheckInDate>
          <CheckOutDate>2004-01-11</CheckOutDate>
        </PeriodOfStay>
        <HotelRooms>
          <HotelRoom Code="TB" Id="001:NAD">
            <PaxIds>
              <PaxId>1</PaxId>
              <PaxId>2</PaxId>
            </PaxIds>
          </HotelRoom>
        </HotelRooms>
      </HotelItem>
    </BookingItem>
  </BookingItems>
</AddBookingRequest>
)

hash_data = {
  "AddBookingRequest" => {
    "@Currency" => "GBP",
    "BookingName" => "MC20031301",
    "BookingReference" => "MC20031201a",
    "BookingDepartureDate" => "2004-01-01",
    "PaxNames" => {
      "PaxName"=> [
        { "@PaxId" => "1", "content" => "Mr John Doe" },
        { "@PaxId" => "2", "content" => "Mrs Sarah Doe" }
      ]
    },
    "BookingItems" => {
      "BookingItem" => {
        "@ItemType" => "hotel",
        "ItemReference" => "1",
        "ItemCity" => { "@Code" => "AMS" },
        "Item" => { "@Code" => "NAD" },
        "HotelItem" => {
          "PeriodOfStay" => { "CheckInDate" => "2004-01-01", "CheckOutDate" => "2004-01-11" },
          "HotelRooms" => {
            "HotelRoom" => {
              "@Code" => "TB",
              "@Id" => "001:NAD",
              "PaxIds" => { "PaxId" => ["1", "2"] }
            }
          }
        }
      }
    }
  }
}

yaml_data = %q(
---
AddBookingRequest:
  ! '@Currency': GBP
  BookingName: MC20031301
  BookingReference: MC20031201a
  BookingDepartureDate: '2004-01-01'
  PaxNames:
    PaxName:
    - ! '@PaxId': '1'
      content: Mr John Doe
    - ! '@PaxId': '2'
      content: Mrs Sarah Doe
  BookingItems:
    BookingItem:
      ! '@ItemType': hotel
      ItemReference: '1'
      ItemCity:
        ! '@Code': AMS
      Item:
        ! '@Code': NAD
      HotelItem:
        PeriodOfStay:
          CheckInDate: '2004-01-01'
          CheckOutDate: '2004-01-11'
        HotelRooms:
          HotelRoom:
            ! '@Code': TB
            ! '@Id': 001:NAD
            PaxIds:
              PaxId:
              - '1'
              - '2'
)

# Convert XML to HASH
hash = XmlSimple.xml_in xml_data, 'KeepRoot' => true, 'AttrPrefix' => true, 'ForceArray' => false

# Convert HASH to XML
xml  = XmlSimple.xml_out hash_data, 'RootName' => 'XmlRequest', 'AttrPrefix' => true

# Convert YAML to HASH
hash = YAML.load yaml_data

# Convert HASH to YAML
yaml = hash_data.to_yaml
