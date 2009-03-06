task :cron => :environment do
    Guild.all.each{|g|
        g.refresh_from_armory
        g.toons.each(&:refresh_from_armory)
    }
end
