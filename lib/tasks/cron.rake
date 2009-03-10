# I'm sure that this is a builtin or something. Must be. It seems obvious.
$threads = []
$poolsize = 5
def do_in_thread( obj, &block )
    while $threads.size >= $poolsize
        $threads.shift.join
    end
    $threads << Thread.new(obj, &block)
end
def wait_for_threads()
    $threads.each { |t|  t.join }
    $threads = []
end

# so, I don't believe that activerecord is actually threadsafe. But I'm going
# to make sure that updating an object from the armoury only touches that object, 
# and no others of that class. note that touching a guild object can update Character
# objects, though, so make sure we wait_for_threads after updating the guilds.


task :cron => :environment do
    ActiveRecord::Base.allow_concurrency = true # DOOM

    Guild.find(:all, :conditions => [ "fetched_at < ? or fetched_at is null", Time.now - 30.minutes ], :order => "fetched_at" ).each{|g|
        do_in_thread(g) { |guild|
            guild.refresh_from_armory
        }
    }
    wait_for_threads
    puts "** guild fetch complete"

    Character.find(:all, :conditions => [ "fetched_at < ? or fetched_at is null", Time.now - 2.hours ], :order => "fetched_at" ).each{|c|
        do_in_thread(c) { |character|
            character.refresh_from_armory
        }
    }
    wait_for_threads
    puts "** character fetch complete"
end


