class UpsServices
  SERVICES = {
          "01" => "UPS Next Day Air",
          "02" => "UPS Second Day Air",
          "03" => "UPS Ground",
          "07" => "UPS Worldwide Express",
          "08" => "UPS Worldwide Expedited",
          "11" => "UPS Standard",
          "12" => "UPS Three-Day Select",
          "13" => "UPS Next Day Air Saver",
          "14" => "UPS Next Day Air Early A.M.",
          "54" => "UPS Worldwide Express Plus",
          "59" => "UPS Second Day Air A.M.",
          "65" => "UPS Saver",
          "82" => "UPS Today Standard",
          "83" => "UPS Today Dedicated Courier",
          "84" => "UPS Today Intercity",
          "85" => "UPS Today Express",
          "86" => "UPS Today Express Saver"
        }

  def self.transform_codes_into_names(hash)
    mappings = Hash.new
    hash.keys.each do |key|
      mappings[key] = SERVICES[key]
    end
    Hash[hash.map {|k, v| [mappings[k], v] }]
  end
end
