task :sendmail => :environment do
    
    GuildMailer.send_weekly_summaries

end


