task :cron => :environment do
    Guild.all.each{|g|
        g.refresh_from_armory
    }
    Character.all.each{|t|
        t.refresh_from_armory
    }
end
