desc 'Fetch WoW achievement data from the Armory.'
task :cron => :environment do
    
    Guild.find(:all, :conditions => [ "fetched_at < ? or fetched_at is null", Time.now.utc - 30.minutes ], :order => "fetched_at", :include => [ :realm ] ).each{|guild|
        guild.refresh_from_armory
        $stdout.flush
    }

    count = 0
    total = 0

    Character.find(:all, :conditions => [ "fetched_at < ? or fetched_at is null", Time.now.utc - 2.hours ], :order => "fetched_at", :include => [ :realm ] ).each{|character|
        total += 1
        if character.refresh_from_armory
            count += 1
        end
        sleep 2 # The armory has a throttling policy.
        $stdout.flush
    }
    puts "** character fetch complete - fetched #{ count } of #{ total } successfully"

    # everyone without the 'level 10' achievement needs backfilling. not totally
    # reliable, this, but there's little I can do. Can't do all of them, that
    # would upset heroku, but we can do them sloooowly.
    level_10s = Achievement.find_by_armory_id(6).character_achievements.map(&:character_id)
    needs_backfill = Character.all.select{|c| c.character_achievements.size > 0 and !level_10s.include?(c.id) }[0]
    if needs_backfill
        needs_backfill.backfill
    end

end


