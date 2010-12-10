require 'open-uri'

class Fetcher
    def self.fetch( url )
        #puts ".. fetching #{url}"
        xml = open(url, "Accept-Language" => ARMORY_LANGUAGE) do |f|
            Hpricot.XML(f)
        end
        return xml
    end
end

    