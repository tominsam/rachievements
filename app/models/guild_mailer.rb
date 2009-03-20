class GuildMailer < ActionMailer::Base

    helper :application
    
    def GuildMailer.send_weekly_summaries
        Guild.find_each{|g|
            if !g.email.blank?
                puts "#{ g.to_s }"
                GuildMailer.deliver_weekly_summary( g )
            end
        }
    end

    def weekly_summary( guild )
        if guild.email.blank?
            raise "no email address for guild #{ guild }"
        end
        recipients guild.email
        from "Tom's Magical Mail Sending Robot <tom@jerakeen.org>"
        subject "This week in the magical world of #{ guild.name }"
        sent_on Time.now

        all_items = guild.character_achievements.all( :conditions => [ 'character_achievements.created_at >= ?', Date.today - 1.week ] )
        people = all_items.group_by{|i| i.character }.sort_by{|character, items| [ character.achpoints * -1, character.rank ] }
        level_80 = guild.characters.count(:conditions => { :level => 80 } )
        total = guild.characters.count
        levels = all_items.select{|i| i.achievement.name.match(/^Level \d+/) }.map{|i| [ i.character, i.achievement.name.downcase ] }.sort_by{|char, level| level }.reverse.uniq_by{|character, level| character }

        body( { :guild => guild, :people => people, :level_80 => level_80, :total => total, :levels => levels } )
        
    end

end
