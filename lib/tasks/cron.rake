task :cron => :environment do
    
    # send mail _first_, in case the long-running stuff below craps out.
    if Time.now.gmtime.wday == 1 and Time.now.gmtime.hour > 4 # monday morning
        GuildMailer.send_weekly_summaries
    end

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
    $stdout.flush
end


