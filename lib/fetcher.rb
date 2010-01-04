class Fetcher
    def self.fetch( url )
        #puts ".. fetching #{url}"
        xml = open(url, "User-agent" => 'Mozilla/5.0 (Windows; U; Windows NT 5.0; en-GB; rv:1.8.1.4) Gecko/20070515 Firefox/2.0.0.4', "Accept-Language" => ARMORY_LANGUAGE) do |f|
            Hpricot.XML(f)
        end
        return xml
    end
end

    